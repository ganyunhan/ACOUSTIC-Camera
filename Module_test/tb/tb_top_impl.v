`timescale 1ns / 1ps
module tb();

localparam W = 16;

reg clk;
reg rst_n;
integer fid_result,fid_xdata,fid_ydata;
reg xcorr_start = 1'b1;
wire start;

wire mic_ws;
wire mic_clk;
reg  mic0_data = 0;
reg  mic12_data = 0;
GSR GSR (.GSRI(1'b1)) ; 
initial begin
	clk = 0;
end

initial begin
	rst_n = 1;
	#10 rst_n = 0;
	#20 rst_n = 1;
	#100000 xcorr_start = 0;
	// force U_TOP.U_MIC_SUBSYS.nx_state = 3'b010;
end

// always @(*) begin
// 	if (U_TOP.U_CAL_POSITION.done) begin
// 			#10000
// 			$finish;  
// 	end
// end

always @(posedge mic_clk or negedge mic_ws) begin
	if(mic_ws & !xcorr_start) begin
		mic0_data <= {$random}%2;
	end else begin
		mic0_data <= 0;
	end
end

always @(posedge mic_clk or negedge mic_ws) begin
	if(!mic_ws & !xcorr_start) begin
		mic12_data <= {$random}%2;
	end else if(mic_ws & !xcorr_start) begin
		mic12_data <= {$random}%2;
	end else begin
		mic12_data <= 0;
	end
end

always #10 clk = ~clk;

top U_TOP(
     .PAD_CLK           (clk)         
    ,.PAD_RST_N         (rst_n)         
    ,.PAD_XC_EN         (xcorr_start)         
    ,.PAD_MIC0_DA       (mic0_data)         
    ,.PAD_MIC12_DA      (mic12_data)         
    ,.PAD_MIC34_DA      (mic12_data)         
    ,.PAD_MIC56_DA      (mic12_data)         
    ,.PAD_WS            (mic_ws) 
    ,.PAD_CLK_MIC       (mic_clk)         
);

endmodule