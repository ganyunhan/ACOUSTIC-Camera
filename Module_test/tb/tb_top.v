`timescale 1ns / 1ps
module tb();

localparam W = 16;

reg clk;
reg rst_n;
integer fid_result,fid_xdata,fid_ydata;
reg xcorr_start = 1'b1;
wire start;

wire mic0_ws;
wire mic1_ws;
wire mic0_clk;
wire mic1_clk;
reg  mic0_data = 0;
reg  mic1_data = 0;

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

// always @(U_TOP.U_MIC_SUBSYS.subsys_done) begin
//         xcorr_start = 0;
//         #100000 xcorr_start = 1;
// end

always @(posedge mic0_clk or negedge mic0_ws) begin
        if(!mic0_ws & !xcorr_start) begin
                mic0_data <= {$random}%2;
        end else begin
                mic0_data <= 0;
        end
end

always @(posedge mic1_clk or negedge mic1_ws) begin
        if(!mic1_ws & !xcorr_start) begin
                mic1_data <= mic0_data;
        end else begin
                mic1_data <= 0;
        end
end

//Read x data from fifo
initial begin
	fid_xdata = $fopen("../XCORR/data/x_data.dat", "w");
end
reg [10- 1: 0] cnt_x = 0;
always @(posedge U_TOP.U_MIC_SUBSYS.U_RAM0_512.clkb) begin
	if (U_TOP.U_MIC_SUBSYS.U_RAM0_512.ceb && cnt_x <= 512)begin
                cnt_x <= cnt_x + 1'b1;
		$fdisplay(fid_xdata,"%d",$signed(U_TOP.U_MIC_SUBSYS.U_RAM0_512.dout));
	end
end

//Read y data from fifo
initial begin
	fid_ydata = $fopen("../XCORR/data/y_data.dat", "w");
end

always @(posedge U_TOP.U_MIC_SUBSYS.U_RAM1_512.clkb) begin
	if (U_TOP.U_MIC_SUBSYS.U_RAM1_512.ceb && cnt_x <= 512)begin
		$fdisplay(fid_ydata,"%d",$signed(U_TOP.U_MIC_SUBSYS.U_RAM1_512.dout));
	end
end

//Read result data from xcorr
initial begin
	fid_result = $fopen("../XCORR/data/golden_result.dat", "w");
end

always @(posedge U_TOP.U_CLOCK_MANAGE.clk_60MHz) begin
	if (U_TOP.U_MIC_SUBSYS.U_XCORR_Top.complete)begin
		$fdisplay(fid_result,"%d",$signed(U_TOP.U_MIC_SUBSYS.U_XCORR_Top.result));
	end
end

always #10 clk = ~clk;

top U_TOP(
     .PAD_CLK           (clk) //input              
    ,.PAD_RST_N         (rst_n) //input              
    ,.PAD_XC_EN         (xcorr_start) //input              
    ,.PAD_MIC0_DA       (mic0_data) //input              
    ,.PAD_MIC1_DA       (mic1_data) //input              
    ,.PAD_LR0           () //output             
    ,.PAD_LR1           () //output             
    ,.PAD_WS0           (mic0_ws) //output             
    ,.PAD_WS1           (mic1_ws) //output             
    ,.PAD_CLK_MIC0      (mic0_clk) //output             
    ,.PAD_CLK_MIC1      (mic1_clk) //output             
);

endmodule