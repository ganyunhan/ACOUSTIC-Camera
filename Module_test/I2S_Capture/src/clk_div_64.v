`timescale  1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 07.09.2022
// Designer : Hank.Gan
// Design Name: clk_div_64
// Description: A simple clock divider
// Dependencies: None
// Revision 1.0
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module clk_div_64(
    input clk_in,
    input rst_n,
    output reg clk_out
);

localparam   COUNT = 31;
 
reg  [6:0]  count;
 
always @(negedge clk_in or negedge rst_n)
begin
   if(!rst_n)
     count <= 16'b0;
   else if(count == COUNT)
     count <= 16'b0;
   else
     count <= count + 1'b1;
end

always @(negedge clk_in or negedge rst_n)
begin
    if(!rst_n)
      clk_out <= 1'b0;
    else if(count == COUNT)
      clk_out <= ~clk_out;
    else
      clk_out <= clk_out;
end
 
endmodule
 