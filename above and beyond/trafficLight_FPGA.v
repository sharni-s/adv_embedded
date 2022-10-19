`timescale 1ns/1ns

module traffic(output reg [7:0] LED, // LED[2:0] - Highway Light, LED[7:4] - Farm Light
input farmButton, // Walkers button on farm traffic light
input wire clk);

parameter state1 = 2'b00, // Highway green, Farm road red
   state2 = 2'b01, // Highway yellow, Farm road red
   state3 = 2'b10, // Highway red, Farm road green
   state4 = 2'b11; // Highway red, Farm road yellow

// Traffic Light Values are as below,
// 3'b001 -> GREEN
// 3'b010 -> YELLOW
// 3'b100 -> RED

reg[27:0] counter = 0,
   counterDelay = 0;

reg greenLongDelay = 0, 
   transShortDelay1 = 0,
   transShortDelay2 = 0,
   counterRed=0,counterYellow1=0,counterYellow2=0;

wire timerInProgress; // clock enable signal for 1s
reg[1:0] currState, nextState;

initial begin
    currState=state1;
    nextState=state1;
end

// next state
always @(posedge clk)
begin
 currState = nextState; 
end

// Finite State Machine of the Traffic Light System
always @(*)
begin
case(currState)
state1: begin // Highway green, Farm road red
 counterRed=0;
 counterYellow1=0;
 counterYellow2=0;
 LED[2:0] <= 3'b111;
 LED[7:4] <= 3'b000;
 if(farmButton==0) 
   nextState = state2; 
 else 
   nextState = state1;
end
state2: begin // Highway yellow, Farm road red
  LED[2:0] <= 3'b010;
  LED[7:4] <= 3'b000;
  counterRed = 0;
  counterYellow1 = 1;
  counterYellow2 = 0;
  if(transShortDelay1) 
    nextState = state3;
  else nextState = state2;
end
state3: begin// Highway red, Farm road green
 LED[2:0] <= 3'b000;
 LED[7:4] <= 3'b111;
 counterRed = 1;
 counterYellow1 = 0;
 counterYellow2 = 0;
 if(greenLongDelay) 
   nextState = state4;
 else 
   nextState = state3;
end
state4:begin // Highway red, Farm road yellow
 LED[2:0] <= 3'b000;
 LED[7:4] <= 3'b010;
 counterRed = 0;
 counterYellow1 = 0;
 counterYellow2 = 1;
 if(transShortDelay2) 
   nextState = state1;
 else 
   nextState = state4;
end
default: nextState = state1;
endcase
end

// For transition time
always @(posedge clk)
begin
if(timerInProgress==1) begin
 if(counterRed || counterYellow1 || counterYellow2)
  counterDelay <=counterDelay + 1;
  if((counterDelay == 9) && counterRed) 
  begin
   greenLongDelay = 1;
   transShortDelay1 = 0;
   transShortDelay2 = 0;
   counterDelay <= 0;
  end
  else if((counterDelay == 2) && counterYellow1) 
  begin
   greenLongDelay = 0;
   transShortDelay1 = 1;
   transShortDelay2 = 0;
   counterDelay <= 0;
  end
  else if((counterDelay == 2) && counterYellow2) 
  begin
   greenLongDelay = 0;
   transShortDelay1 = 0;
   transShortDelay2 = 1;
   counterDelay <= 0;
  end
  else
  begin
   greenLongDelay = 0;
   transShortDelay1 = 0;
   transShortDelay2 = 0;
  end 
 end
end

// Counter for counting through the transition and green light times
always @(posedge clk)
begin
 counter <= counter + 1;
 if(counter == 50000000)
   counter <= 0;
end

 assign timerInProgress = (counter == 50000000) ? 1: 0; // 50,000,000 for 50MHz running on FPGA
endmodule

// Reference - https://www.fpga4student.com/2016/11/verilog-code-for-traffic-light-system.html
