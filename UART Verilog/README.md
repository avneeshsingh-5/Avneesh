# UART Transmitter and Receiver in Verilog

## Overview
This project implements a **Universal Asynchronous Receiver Transmitter (UART)** using **Verilog HDL**. UART is a widely used serial communication protocol for transmitting data between digital systems such as microcontrollers, FPGAs, and computers.

The design includes a **UART Transmitter (TX)**, **UART Receiver (RX)**, and a **Baud Rate Generator**. The transmitter converts parallel data into serial format, and the receiver reconstructs the serial data back into parallel form.

The project was simulated using **Xilinx Vivado**, and the output was verified using waveform analysis.

---

## Features
- UART Transmitter (TX)
- UART Receiver (RX)
- Baud Rate Generator
- Parallel to Serial Conversion
- Serial to Parallel Conversion
- Start Bit and Stop Bit Handling
- Testbench for Simulation
- Waveform Verification

---

## UART Frame Format

Each UART frame in this design consists of:

| Component | Bits |
|----------|------|
| Start Bit | 1 |
| Data Bits | 8 |
| Stop Bit | 1 |

Total: **10 bits per frame**

Start | D0 D1 D2 D3 D4 D5 D6 D7 | Stop
0 Data Bits 1



---

## Project Architecture

Main modules used in the design:

- Baud Rate Generator
- UART Transmitter
- UART Receiver





---

## Working Principle

### UART Transmitter
1. Parallel data is loaded into the transmitter.
2. A **start bit (0)** is added at the beginning.
3. Data bits are transmitted **LSB first**.
4. A **stop bit (1)** is appended at the end.
5. Bits are transmitted according to the **baud rate clock**.

### UART Receiver
1. Receiver waits for a **start bit**.
2. Once detected, it begins sampling the incoming serial data.
3. Data bits are captured sequentially.
4. The **stop bit** is checked to validate the frame.
5. Data is reconstructed into parallel format.

---

## Simulation

The design was simulated using **Xilinx Vivado**.

Simulation verifies:
- Correct serial transmission
- Correct reception of data
- Proper UART frame generation

Observed signals include:

- `clk`
- `tx`
- `rx`
- `data_in`
- `data_out`

---

## Tools Used

- Verilog HDL
- Xilinx Vivado
- EDA Playgrounds

---

## Applications

UART communication is commonly used in:

- Microcontroller communication
- FPGA communication
- Serial debugging interfaces
- Embedded systems
- Sensor communication

---

## Future Enhancements

Possible improvements to this project:

- Configurable baud rate
- Parity bit support
- FIFO buffering
- Interrupt-driven UART
- Full ASIC implementation flow

---

## Author

**Avneesh Singh**  

