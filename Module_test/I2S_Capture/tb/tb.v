`timescale 1ns / 1ps
module tb();

localparam W = 16;

reg clk;
reg rst_n;

wire mic0_ws;
wire mic1_ws;
wire mic0_clk;
wire mic1_clk;
reg  mic0_data = 0;
reg  mic1_data = 0;
reg  key1 = 1;
reg  key2 = 1;

initial begin
        clk = 0;
end

initial begin
        rst_n = 1;
        #10 rst_n = 0;
        #20 rst_n = 1;
        #150000 key1 = 0;
end

always @(*) begin
    if (U_TOP.u_FIFO_L_Top.Full && key1 == 0) begin
        key2 = 0;
        key1 = 1;
    end
end

always @(posedge mic0_clk or negedge mic0_ws) begin
        if(!mic0_ws) begin
                mic0_data <= {$random}%2;
        end else begin
                mic0_data <= 0;
        end
end

always @(posedge mic1_clk or negedge mic1_ws) begin
        if(!mic1_ws) begin
                mic1_data <= mic0_data;
        end else begin
                mic1_data <= 0;
        end
end

always #10 clk = ~clk;

mic_subsys U_TOP(
     .PAD_CLK           (clk) //input              
    ,.PAD_RST_N         (rst_n) //input                           
    ,.PAD_MIC0_DA       (mic0_data) //input              
    ,.PAD_MIC1_DA       (mic1_data) //input              
    ,.PAD_LR0           () //output             
    ,.PAD_LR1           () //output             
    ,.PAD_WS0           (mic0_ws) //output             
    ,.PAD_WS1           (mic1_ws) //output             
    ,.PAD_CLK_MIC0      (mic0_clk) //output             
    ,.PAD_CLK_MIC1      (mic1_clk) //output   
    ,.PAD_TXD           ()
    ,.PAD_KEY1          (key1) //input
    ,.PAD_KEY2          (key2) //input  
);

endmodule