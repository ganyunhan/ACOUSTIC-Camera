`timescale  1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 26.08.2022
// Designer : Hank.Gan
// Design Name: clk_div
// Description: A simple clock divider
// Dependencies: None
// Revision 1.0
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module clk_div#(
    parameter       SCALER = 10
)
(
    input clk_in,
    input rst_n,
    output reg clk_out
);

localparam   COUNT = SCALER/2 - 1;
 
reg  [15:0]  count;
 
always @(posedge clk_in or negedge rst_n)
begin
   if(!rst_n)
     count <= 16'b0;
   else if(count == COUNT)
     count <= 16'b0;
   else
     count <= count + 1'b1;
end

always @(posedge clk_in or negedge rst_n)
begin
    if(!rst_n)
      clk_out <= 1'b0;
    else if(count == COUNT)
      clk_out <= ~clk_out;
    else
      clk_out <= clk_out;
end
 
endmodule
 