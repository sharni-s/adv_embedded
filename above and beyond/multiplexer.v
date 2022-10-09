`timescale 1ns/1ns
module multiplexer(I1, I2, I3, I4, sbit0, sbit1, out);
  
  output reg [3:0] out;
  input [3:0] I1, I2, I3, I4;
  input sbit0, sbit1;
 
  
  
  always @ (sbit0 or sbit1) 
  begin
    if(sbit0 == 0 && sbit1 == 0)
      out <= I1;
    else if(sbit0 == 1 && sbit1 == 0)
      out <= I2;
    else if(sbit0 == 0 && sbit1 == 1)
      out <= I3;
    else if(sbit0 == 1 && sbit1 == 1)
      out <= I4;
  end

endmodule
