`timescale 1ns / 1ps
module tb();

localparam W = 16;

reg clk;
reg rst_n;

wire mic_ws;
wire mic_clk;
reg  mic0_data = 0;
reg  mic12_data = 0;
reg  mic34_data = 0;
reg  mic56_data = 0;
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
    if (U_TOP.u_FIFO_0_Top.Full && key1 == 0) begin
        key2 = 0;
        key1 = 1;
    end
end

always @(posedge mic_clk or negedge mic_ws) begin
        if(mic_ws) begin
                mic0_data <= {$random}%2;
        end else begin
                mic0_data <= 0;
        end
end

always @(posedge mic_clk or negedge mic_ws) begin
        if(!mic_ws) begin
                mic12_data <= {$random}%2;
        end else if (mic_ws) begin
                mic12_data <= {$random}%2;
        end else begin
                mic12_data <= 0;
        end
end

always @(posedge mic_clk or negedge mic_ws) begin
        if(!mic_ws) begin
                mic34_data <= {$random}%2;
        end else if (mic_ws) begin
                mic34_data <= {$random}%2;
        end else begin
                mic34_data <= 0;
        end
end

always @(posedge mic_clk or negedge mic_ws) begin
        if(!mic_ws) begin
                mic56_data <= {$random}%2;
        end else if (mic_ws) begin
                mic56_data <= {$random}%2;
        end else begin
                mic56_data <= 0;
        end
end

always #10 clk = ~clk;

mic_subsys U_TOP(
     .PAD_CLK           (clk) //input              
    ,.PAD_RST_N         (rst_n) //input                           
    ,.PAD_MIC0_DA       (mic0_data) //input              
    ,.PAD_MIC12_DA      (mic12_data) //input              
    ,.PAD_MIC34_DA      (mic34_data) //output             
    ,.PAD_MIC56_DA      (mic56_data) //output             
    ,.PAD_WS            (mic_ws) //output             
    ,.PAD_CLK_MIC       (mic_clk) //output               
    ,.PAD_TXD           ()
    ,.PAD_KEY1          (key1) //input
    ,.PAD_KEY2          (key2) //input  
);

endmodule