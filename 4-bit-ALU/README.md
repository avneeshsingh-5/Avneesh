# 4-bit ALU Design in Verilog

## Overview

This project implements a **4-bit Arithmetic Logic Unit (ALU)** using Verilog HDL.
The ALU performs arithmetic and logical operations based on a **3-bit opcode** and generates several processor-style flags.

The design was simulated and verified using a **Verilog testbench** and waveform analysis.

---

## Operations Supported

| Opcode | Operation    |
| ------ | ------------ |
| 000    | NOP          |
| 001    | Addition     |
| 010    | Subtraction  |
| 011    | AND          |
| 100    | OR           |
| 101    | Complement A |
| 110    | Complement B |
| 111    | NOP          |

---

## Flags Generated

The ALU generates common processor flags:

* **Carry Flag (CF)** – indicates overflow in arithmetic operations
* **Auxiliary Carry Flag (AC)** – carry from bit3 to bit4
* **Zero Flag (ZF)** – result equals zero
* **Sign Flag (SF)** – MSB of result (signed interpretation)
* **Parity Flag (PF)** – indicates even parity of the result

---

## Files

* `ALU.v` – Verilog RTL implementation of the ALU
* `ALU_tb.v` – Testbench used to simulate and verify the ALU
* `waveform.png` – Simulation waveform output

---

## Tools Used

* **Verilog HDL**
* **Xilinx Vivado Simulator**

---

## Author

Avneesh Singh

