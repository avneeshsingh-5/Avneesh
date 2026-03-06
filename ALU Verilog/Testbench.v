module ALU_tb;
  reg[3:0]A,B;
  reg[2:0]OP;
  wire[3:0]result;
  wire zero_flag,parity_flag,carry_flag,auxcarry_flag,sign_flag;
  ALU uut(.A(A),.B(B),.OP(OP),.result(result),.zero_flag(zero_flag),.parity_flag(parity_flag),.carry_flag(carry_flag),.auxcarry_flag(auxcarry_flag),.sign_flag(sign_flag));
  
  initial
    begin
      
      $monitor("Time : %0t | A = %b | B = %b | OP = %b | Result = %b",$time,A,B,OP,result);
      
      A=4'b1001;B=4'b0111;OP=3'b000;#10; //NOP
      A=4'b1001;B=4'b0111;OP=3'b001;#10; //ADD
      A=4'b0100;B=4'b0111;OP=3'b010;#10; //SUB
      A=4'b1001;B=4'b0110;OP=3'b011;#10; //AND
      A=4'b1001;B=4'b0111;OP=3'b100;#10; //OR 
      A=4'b1111;B=4'b0000;OP=3'b101;#10; //COMP A
      A=4'b0000;B=4'b0000;OP=3'b110;#10; //COMP B
      A=4'b1001;B=4'b0111;OP=3'b111;#10; //NOP
      
      $finish;
    end
endmodule
