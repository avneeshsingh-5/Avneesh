`timescale 1ns/1ps

// ============================================================
// BAUD RATE GENERATOR
// ============================================================
module baud_rate_gen #(
    parameter CLK_FREQ  = 25_000_000,
    parameter BAUD_RATE = 390_625
)(
    input  wire clk,
    input  wire rst,
    output reg  baud_tick,
    output reg  sample_tick
);

    localparam TX_DIV = CLK_FREQ / BAUD_RATE;          // 64
    localparam RX_DIV = CLK_FREQ / (BAUD_RATE * 16);   // 4

    reg [15:0] tx_cnt;
    reg [15:0] rx_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_cnt <= 0;
            baud_tick <= 0;
        end else begin
            if (tx_cnt == TX_DIV-1) begin
                tx_cnt <= 0;
                baud_tick <= 1;
            end else begin
                tx_cnt <= tx_cnt + 1;
                baud_tick <= 0;
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_cnt <= 0;
            sample_tick <= 0;
        end else begin
            if (rx_cnt == RX_DIV-1) begin
                rx_cnt <= 0;
                sample_tick <= 1;
            end else begin
                rx_cnt <= rx_cnt + 1;
                sample_tick <= 0;
            end
        end
    end
endmodule


// ============================================================
// UART TRANSMITTER
// ============================================================
module uart_tx #(
    parameter PARITY_EN   = 1,
    parameter PARITY_TYPE = 0   // 0 = EVEN, 1 = ODD
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx,
    output reg        tx_busy,
    output reg        tx_done
);

    localparam IDLE = 0,
               SEND = 1;

    reg state;
    reg [7:0] shift_reg;
    reg [3:0] bit_cnt;
    reg parity;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1;
            tx_busy <= 0;
            tx_done <= 0;
            bit_cnt <= 0;
            shift_reg <= 0;
        end else begin

            tx_done <= 0;

            case (state)

            IDLE: begin
                tx <= 1;
                tx_busy <= 0;

                if (tx_start) begin
                    shift_reg <= tx_data;
                    parity <= (PARITY_TYPE) ? 1'b1 : 1'b0;
                    bit_cnt <= 0;
                    tx_busy <= 1;
                    state <= SEND;
                end
            end

            SEND: begin
                if (baud_tick) begin
                    case (bit_cnt)

                        0: tx <= 0;  // start bit

                        1,2,3,4,5,6,7,8: begin
                            tx <= shift_reg[0];        // LSB first
                            parity <= parity ^ shift_reg[0];
                            shift_reg <= shift_reg >> 1;
                        end

                        9: begin
                            if (PARITY_EN)
                                tx <= parity;
                            else
                                tx <= 1;
                        end

                        10: begin
                            tx <= 1;      // stop bit
                            tx_done <= 1;
                            state <= IDLE;
                        end
                    endcase

                    bit_cnt <= bit_cnt + 1;
                end
            end

            endcase
        end
    end
endmodule


// ============================================================
// UART RECEIVER  (Fully Stable)
// ============================================================
module uart_rx #(
    parameter PARITY_EN   = 1,
    parameter PARITY_TYPE = 0
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       sample_tick,
    input  wire       rx,
    output reg [7:0]  rx_data,
    output reg        rx_valid,
    output reg        framing_err,
    output reg        parity_err
);

    localparam IDLE  = 0,
               START = 1,
               DATA  = 2,
               PAR   = 3,
               STOP  = 4;

    reg [2:0] state;
    reg [3:0] tick_cnt;
    reg [2:0] bit_idx;
    reg [7:0] data_reg;
    reg parity_calc;
    reg parity_bit;

    // Synchronizer
    reg s1, s2;
    always @(posedge clk) begin
        s1 <= rx;
        s2 <= s1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tick_cnt <= 0;
            bit_idx <= 0;
            rx_valid <= 0;
            framing_err <= 0;
            parity_err <= 0;
        end else begin

            rx_valid <= 0;

            case (state)

            IDLE: begin
                if (!s2) begin
                    tick_cnt <= 0;
                    state <= START;
                end
            end

            START: begin
                if (sample_tick) begin
                    if (tick_cnt == 7) begin
                        tick_cnt <= 0;
                        bit_idx <= 0;
                        parity_calc <= (PARITY_TYPE) ? 1'b1 : 1'b0;
                        state <= DATA;
                    end else
                        tick_cnt <= tick_cnt + 1;
                end
            end

         DATA: begin
    if (sample_tick) begin
        if (tick_cnt == 15) begin
            tick_cnt <= 0;

            data_reg[bit_idx] <= s2;
            parity_calc <= parity_calc ^ s2;

            bit_idx <= bit_idx + 1;

            if (bit_idx == 3'd7) begin
                state <= (PARITY_EN) ? PAR : STOP;
            end

        end else begin
            tick_cnt <= tick_cnt + 1;
        end
    end
end
            PAR: begin
                if (sample_tick) begin
                    if (tick_cnt == 15) begin
                        tick_cnt <= 0;
                        parity_bit <= s2;
                        state <= STOP;
                    end else
                        tick_cnt <= tick_cnt + 1;
                end
            end

            STOP: begin
                if (sample_tick) begin
                    if (tick_cnt == 15) begin
                        tick_cnt <= 0;

                        if (s2) begin
                            rx_data <= data_reg;
                            rx_valid <= 1;
                            if (PARITY_EN)
                                parity_err <= (parity_bit != parity_calc);
                        end else
                            framing_err <= 1;

                        state <= IDLE;
                    end else
                        tick_cnt <= tick_cnt + 1;
                end
            end

            endcase
        end
    end
endmodule


// ============================================================
// UART TOP
// ============================================================
module uart_top #(
    parameter CLK_FREQ  = 25_000_000,
    parameter BAUD_RATE = 390_625
)(
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output tx,
    output tx_done,
    input rx,
    output [7:0] rx_data,
    output rx_valid
);

    wire baud_tick;
    wire sample_tick;

    baud_rate_gen #(CLK_FREQ, BAUD_RATE)
        u_baud(clk, rst, baud_tick, sample_tick);

    uart_tx u_tx(
        clk, rst, baud_tick,
        tx_start, tx_data,
        tx, , tx_done
    );

    uart_rx u_rx(
        clk, rst, sample_tick,
        rx,
        rx_data, rx_valid, ,
    );

endmodule
