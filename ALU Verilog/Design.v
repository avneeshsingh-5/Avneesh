module ALU(A,B,OP,result,zero_flag,parity_flag,carry_flag,auxcarry_flag,sign_flag);
  input wire[3:0] A,B;
  input wire[2:0] OP;
  output reg[3:0] result;
  
  output reg zero_flag,parity_flag,carry_flag,auxcarry_flag,sign_flag;
  
  always@(*)
    begin
      {zero_flag,parity_flag,carry_flag,auxcarry_flag,sign_flag}=5'b00000;
    
      case(OP)
        3'b000:result=0;
        3'b001:begin
          {carry_flag, result} = A + B;
          auxcarry_flag = (A[3]&B[3])|((A[3]|B[3])&(~result[3]));
        end
        3'b010:begin
          result=A-B;
          carry_flag=(A<B);
        end
        3'b011:result=A&B;
        3'b100:result=A|B;
        3'b101:result=~A;
        3'b110:result=~B;
        3'b111:result=0;
        default:result=0;
    
      endcase
      parity_flag=~^result;
      sign_flag=result[3]; //nums are signed (-8 to +7), for unsigned nums remove sign_flag
      zero_flag=(result==0);
    end
endmodule
      
      
