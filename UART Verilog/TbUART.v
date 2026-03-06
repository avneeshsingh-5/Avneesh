`timescale 1ns/1ps

module uart_tb;

    reg clk = 0;
    always #20 clk = ~clk;   // 25 MHz

    reg rst;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire tx_done;
    wire [7:0] rx_data;
    wire rx_valid;

    uart_top dut(
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_done(tx_done),
        .rx(tx),           // loopback
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0, uart_tb);

        rst = 1;
        tx_start = 0;
        #200;
        rst = 0;

        #200;

        send_byte(8'hA5);
        send_byte(8'h3C);
        send_byte(8'h55);
        send_byte(8'hAA);

        #2000;
        $finish;
    end

    task send_byte(input [7:0] data);
    begin
        @(posedge clk);
        tx_data = data;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        wait(rx_valid);
        $display("Sent = %h  Received = %h", data, rx_data);
        @(posedge clk);
    end
    endtask

endmodule