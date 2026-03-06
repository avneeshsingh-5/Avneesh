**FSM-Based Traffic Light Controller using Verilog**


***Overview***

This project implements a Traffic Light Controller using a Finite State Machine (FSM) in Verilog HDL.
The controller manages traffic signals for a main road, turning lane, and side road using sequential logic.

The design was simulated and verified using Vivado Simulator and EDA Playground.



***Features***

->Implemented using Moore Finite State Machine

->Controls 4 traffic signals:

    Main Road 1 (M1)
    
    Main Road 2 (M2)
    
    Main Turn Lane (MT)
    
    Side Road (S)

->Uses a counter-based timing mechanism

->Includes a Verilog testbench for simulation

->Verified using waveform analysis

->Traffic Light Encoding
    Binary	Light
    
      001	Green
      
      010	Yellow
      
      100	Red

      
      
***FSM States***

The controller cycles through 6 states:

State	M1	M2	MT	S	Description

S0	: Green	Green	Red	Red	Main road traffic

S1	: Green	Yellow	Red	Red	Transition

S2	: Green	Red	Green	Red	Turn lane active

S3	: Yellow	Red	Yellow	Red	Turn transition

S4	: Red	Red	Red	Green	Side road traffic

S5	: Red	Red	Red	Yellow	Side road transition

Then the FSM repeats the cycle.



***Files***

traffic_controller.v	: Verilog RTL design

traffic_controller_tb.v	: Testbench for simulation

waveform.png : Simulation waveform



***Tools Used***

->Verilog HDL

->Xilinx Vivado

->Vivado Simulator

->EDA Playgrounds



***Author***

Avneesh Singh
