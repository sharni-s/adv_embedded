`timescale 1ns/1ns

module tb_multiplexer;
 // Inputs
 reg sbit0, sbit1;
 reg [3:0] I1, I2, I3, I4;
 // Outputs
  wire [3:0] out;
  
  
 multiplexer tb (
   .I1(I1),
   .I2(I2),
   .I3(I3),
   .I4(I4),
   .sbit0(sbit0), 
   .sbit1(sbit1), 
   .out(out)
 );
  
 initial begin
   $dumpfile("dump.vcd");
   $dumpvars(1, tb_multiplexer);
  // Initialize Inputs
   I1 = 4'b1011;
   I2 = 4'b1100;
   I3 = 4'b1101;
   I4 = 4'b1110;
   
//    sbit1 = 0;
   sbit0 = 0;
   sbit1 = 0;
   #10
   $display("selection_bits = %d%d, output = %d", sbit1,  sbit0, out);
   sbit0 = 1;
   sbit1 = 0;
   #10
   $display("selection_bits = %d%d, output = %d", sbit1, sbit0, out);
   sbit0 = 0;
   sbit1 = 1;
   #10
   $display("selection_bits = %d%d, output = %d", sbit1, sbit0, out);
   sbit0 = 1;
   sbit1 = 1;
   #10
   $display("selection_bits = %d%d, output = %d", sbit1, sbit0, out);
   
   
//    #100
//    sbit0 = 1;
//    sbit1 = 0;
//    $display("selection_bits = %d%d, output = %d", sbit1, sbit0, out);
   
//    #100
//    sbit0 = 1;
//    sbit1 = 1;
//    $display("selection_bits = %d%d, output = %d", sbit1, sbit0, out);
 end
      
endmodule