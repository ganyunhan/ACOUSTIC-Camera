`timescale 1ns / 1ps
module tb();

localparam W = 16;

reg clk;
reg rst_n;
integer fid_wr;
reg xcorr_start = 1'b1;
reg start = 1'b1;
reg [9 - 1: 0] ad=0;


reg signed [W- 1: 0] memx [ 0:512- 1];
reg signed [W- 1: 0] memy [ 0:512- 1];

reg signed [W- 1: 0]  series_x;
reg signed [W- 1: 0]  series_y;
// reg                    complete;
// reg signed [32- 1: 0]  result;

initial begin
    // force U_TOP.U_MIC_SUBSYS.U_SIGN_EXTENSION_X.input_number = series_x;
    // force U_TOP.U_MIC_SUBSYS.U_SIGN_EXTENSION_Y.input_number = series_y;
    force U_TOP.U_MIC_SUBSYS.U_XCORR_Top.series_x = series_x;
    force U_TOP.U_MIC_SUBSYS.U_XCORR_Top.series_y = series_y;
    force U_TOP.U_MIC_SUBSYS.U_XCORR_Top.start = start;
end

initial begin
        clk = 0;
end

initial begin
        rst_n = 1;
        #10 rst_n = 0;
        #20 rst_n = 1;
        #60000 xcorr_start = 0;
end

//Throw data into xcorr
initial begin
    $readmemb("../XCORR/data/tb_x.dat",memx);
    $readmemb("../XCORR/data/tb_y.dat",memy);
end

always @(posedge U_TOP.U_CLOCK_MANAGE.clk_60MHz) begin
    if (start) begin
        ad <= 0;
    // end else if(ad >= 511) begin
    //     ad <= 511;
    end else begin
        ad <= ad + 1;
    end
end

always @(posedge U_TOP.U_CLOCK_MANAGE.clk_60MHz) begin
    if(start) begin
        series_x <= 0;
        series_y <= 0;
    end
    else if(ad <= 511) begin
        series_x <= memx[ad];
        series_y <= memy[ad];
    end else begin
        series_x <= 0;
        series_y <= 0;
    end
end

//Read result data from xcorr
initial begin
	fid_wr = $fopen("../XCORR/data/golden_result.dat", "w");
end

always @(posedge U_TOP.U_CLOCK_MANAGE.clk_60MHz) begin
	if (U_TOP.U_MIC_SUBSYS.U_XCORR_Top.complete)begin
		$fdisplay(fid_wr,"%d",$signed(U_TOP.U_MIC_SUBSYS.U_XCORR_Top.result));
	end
end

always #10 clk = ~clk;

top U_TOP(
     .PAD_CLK           (clk) //input              
    ,.PAD_RST_N         (rst_n) //input              
    // ,.PAD_XC_EN         (start) //input              
    ,.PAD_MIC0_DA       () //input              
    ,.PAD_MIC1_DA       () //input              
    ,.PAD_LR0           () //output             
    ,.PAD_LR1           () //output             
    ,.PAD_WS0           () //output             
    ,.PAD_WS1           () //output             
    ,.PAD_CLK_MIC0      () //output             
    ,.PAD_CLK_MIC1      () //output             
);

deUstb ut
(
    .in(xcorr_start),
    .out(start),
    .clk(U_TOP.U_CLOCK_MANAGE.clk_60MHz)
);

endmodule