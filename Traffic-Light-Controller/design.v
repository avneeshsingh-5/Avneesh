`timescale 1ns / 1ps
module traffic_controller(clk,rst,M1,M2,MT,S);
  input wire clk,rst;
  output reg [2:0] M1,M2,MT,S;
  
  reg [3:0] count;
  reg [2:0] ps;
  
  always @(posedge clk or posedge rst)
  begin
      if(rst==1)
      begin
          ps <= 3'b000;
          count <= 4'b0000;
      end
      else
      case(ps)
      
      3'b000:
          if(count < 4'b0111)
          begin
              ps <= 3'b000;
              count <= count + 1;
          end
          else
          begin
              ps <= 3'b001;
              count <= 4'b0000;
          end
          
      3'b001:
          if(count < 4'b0010)
          begin
              ps <= 3'b001;
              count <= count + 1;
          end
          else
          begin
              ps <= 3'b010;
              count <= 4'b0000;
          end
          
      3'b010:
          if(count < 4'b0101)
          begin
              ps <= 3'b010;
              count <= count + 1;
          end
          else
          begin
              ps <= 3'b011;
              count <= 4'b0000;
          end
          
      3'b011:
          if(count < 4'b0010)
          begin
              ps <= 3'b011;
              count <= count + 1;
          end
          else
          begin
              ps <= 3'b100;
              count <= 4'b0000;
          end
          
      3'b100:
          if(count < 4'b0011)
          begin
              ps <= 3'b100;
              count <= count + 1;
          end
          else
          begin
              ps <= 3'b101;
              count <= 4'b0000;
          end
          
      3'b101:
          if(count < 4'b0010)
          begin
              ps <= 3'b101;
              count <= count + 1;
          end
          else
          begin
              ps <= 3'b000;
              count <= 4'b0000;
          end
          
      default:
          ps <= 3'b000;
      endcase
  end
  
  always @(ps)
  begin
      case(ps)
      
      3'b000:
      begin
          M1 <= 3'b001;
          M2 <= 3'b001;
          MT <= 3'b100;
          S  <= 3'b100;
      end
        
      3'b001:
      begin
          M1 <= 3'b001;
          M2 <= 3'b010;
          MT <= 3'b100;
          S  <= 3'b100;
      end
        
      3'b010:
      begin
          M1 <= 3'b001;
          M2 <= 3'b100;
          MT <= 3'b001;
          S  <= 3'b100;
      end
        
      3'b011:
      begin
          M1 <= 3'b010;
          M2 <= 3'b100;
          MT <= 3'b010;
          S  <= 3'b100;
      end
        
      3'b100:
      begin
          M1 <= 3'b100;
          M2 <= 3'b100;
          MT <= 3'b100;
          S  <= 3'b001;
      end
        
      3'b101:
      begin
          M1 <= 3'b100;
          M2 <= 3'b100;
          MT <= 3'b100;
          S  <= 3'b010;
      end
            
      default:
      begin
          M1 <= 3'b000;
          M2 <= 3'b000;
          MT <= 3'b000;
          S  <= 3'b000;
      end
      
      endcase
  end
  
endmodule  