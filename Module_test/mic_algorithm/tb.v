`timescale  1ns / 1ps  

module tb;

// cal_position Parameters
parameter PERIOD  = 10;


// cal_position Inputs
reg signed [31:0]  lag_diff1 =  0 ;
reg signed [31:0]  lag_diff2 =  5 ;
reg signed [31:0]  lag_diff3 = -6 ;
reg signed [31:0]  lag_diff4 = -12;
reg signed [31:0]  lag_diff5 = -1 ;
reg signed [31:0]  lag_diff6 = -5 ;
reg   ena = 0 ;
reg   clk = 0 ;
reg   rst_n  ;
// cal_position Outputs
wire signed [31:0]  x_position;
wire signed [31:0]  y_position;
wire signed [15:0]  z_position;
wire  cal_end;

wire signed [32-1 :0] lag_diff [0 : 6 - 1];
assign lag_diff[0] = lag_diff1;
assign lag_diff[1] = lag_diff2;
assign lag_diff[2] = lag_diff3;
assign lag_diff[3] = lag_diff4;
assign lag_diff[4] = lag_diff5;
assign lag_diff[5] = lag_diff6;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    rst_n = 0;
    #20 rst_n = 1;
    #80 ena = 1;
    #20 ena = 0;
end

always @(*) begin
    if (cal_end) begin
        ena = 0;
        #1000
        $finish;
    end
end

cal_position u_cal_position(
     .clk                   (clk) //input                   
    ,.rst_n                 (rst_n) //input                   
    ,.ena                   (ena) //input                   
    ,.lag_diff              (lag_diff) //input  signed [32- 1: 0]
    ,.x_position            (x_position) //output signed [32- 1: 0]
    ,.y_position            (y_position) //output signed [32- 1: 0]
    ,.z_position            (z_position) //output [16- 1: 0]       
    ,.done                  (cal_end) //output wire             

);

endmodule
