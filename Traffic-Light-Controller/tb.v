`timescale 1ns / 1ps
module traffic_controller_tb;
  reg clk,rst;
  wire [2:0]M1,M2,MT,S;
  traffic_controller uut(.clk(clk),.rst(rst),.M1(M1),.M2(M2),.MT(MT),.S(S));
  initial clk=1'b0;
  always #50000 clk = ~clk;
  initial
    begin
      rst=0;
      #100000000;
      rst=1;
      #100000000;
      rst=0;
      #100000000;
      $finish;
    end
endmodule