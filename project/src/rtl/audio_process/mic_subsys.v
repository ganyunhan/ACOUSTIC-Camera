`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 26.08.2022
// Last Modified : Hank.Gan 26.08.2022
// Designer : Hank.Gan
// Design Name: mic_subsys
// Description: Microphone Array processing sub-system
// Dependencies: i2s_decoder/
// Revision 1.0
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////
module mic_subsys#(
    parameter       LAGNUM = 16
)
(
     input                      clk_60MHz
    ,input                      clk_mic
    ,input                      clk_WS
    ,input                      rst_n
    ,input                      rst_mic_n
    ,input                      mic0_data_in
    ,input                      mic1_data_in
    ,input                      subsys_start
    ,output reg                 subsys_done
    ,output reg signed [6 - 1: 0]  lag_diff
);

wire                            mic0_data_en;
wire                            mic1_data_en;
wire signed [16- 1: 0]          mic0_data;
wire signed [16- 1: 0]          mic1_data;
wire signed [16- 1: 0]          mic0_fifo_data;
wire signed [16- 1: 0]          mic1_fifo_data;
wire        [32- 1: 0]          abs_xcorr_data;
wire signed [32- 1: 0]          xcorr_data;
wire                            xcorr_done;

//FSM of controlling xcorr/fifo I/O 
reg         [3 - 1: 0]          cr_state;
reg         [3 - 1: 0]          nx_state;
reg         [9 - 1: 0]          ram_wr_addr;
reg         [9 - 1: 0]          ram_rd_addr;

reg                             xcorr_start;
reg                             fifo_en_mask;
reg                             ram_rd_en;
wire                            xcorr_all_complete;

localparam      IDLE         = 3'b000;
localparam      FIFO_IN      = 3'b001;
localparam      CALC_EN      = 3'b010;
localparam      OUTPUT       = 3'b011;

localparam      LAG_NUM     = LAGNUM * 2;

always @(posedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        cr_state <= IDLE;
    end else begin
        cr_state <= nx_state;
    end
end

always @(*) begin
	case (cr_state)
		IDLE: begin 
            if (subsys_start) begin
                nx_state = CALC_EN;
            end else begin
                nx_state = IDLE;
            end
        end
        FIFO_IN: begin
            if (ram_wr_addr >= 'd511) begin
                nx_state = CALC_EN;
            end else begin  
                nx_state = FIFO_IN;
            end
        end
        CALC_EN: begin
            if (xcorr_all_complete) begin
                nx_state = OUTPUT;
            end else begin
                nx_state = CALC_EN;
            end
        end
        OUTPUT: begin
            nx_state = IDLE;
        end
        default: begin
            nx_state = IDLE;
        end
    endcase
end

assign cr_fifo_in       = (cr_state == FIFO_IN) ? 1'b1 : 1'b0;
assign cr_calc_en       = (cr_state == CALC_EN) ? 1'b1 : 1'b0;
assign cr_output        = (cr_state == OUTPUT ) ? 1'b1 : 1'b0;

assign nx_fifo_in       = (nx_state == FIFO_IN) ? 1'b1 : 1'b0;
assign nx_calc_en       = (nx_state == CALC_EN) ? 1'b1 : 1'b0;
assign nx_output        = (nx_state == OUTPUT ) ? 1'b1 : 1'b0;

//processing fifo_en_mask reg
always @(negedge clk_WS or negedge rst_n) begin
    if (!rst_n) begin
        fifo_en_mask <= 1'b0;
    end else if (cr_fifo_in) begin
        fifo_en_mask <= 1'b1;
    end else begin
        fifo_en_mask <= 1'b0;
    end
end

//processing xcorr_rst_n reg
reg  xcorr_rst;
wire xcorr_rst_n;
always @(negedge clk_WS or negedge rst_n) begin
    if (!rst_n) begin
        xcorr_rst <= 1'b0;
    end else if (nx_output | nx_calc_en) begin
        xcorr_rst <= 1'b1;
    end else begin
        xcorr_rst <= 1'b0;
    end
end

assign xcorr_rst_n = rst_n & rst_mic_n & xcorr_rst;

//processing ram_wr_addr reg, delay for 1 cycle
reg [9 - 1: 0] ram_wr_addr_r;
always @(negedge clk_WS or negedge rst_n) begin
    if (!rst_n) begin
        ram_wr_addr_r <= 9'b0;
    end else if (cr_fifo_in) begin
        ram_wr_addr_r <= ram_wr_addr_r + 1'b1;
    end else begin
        ram_wr_addr_r <= 9'b0;
    end
end

always @(negedge clk_WS or negedge rst_n) begin
    if (!rst_n) begin
        ram_wr_addr <= 9'b0;
    end else begin
        ram_wr_addr <= ram_wr_addr_r;
    end
end

//processing ram_rd_en reg, delay 1 cycle
reg ram_rd_en_r;
always @(negedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        ram_rd_en_r <= 1'b0;
    end else if (cr_calc_en && !fifo_en_mask) begin
        ram_rd_en_r <= 1'b1;
    end else begin
        ram_rd_en_r <= 1'b0;
    end
end

always @(negedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        ram_rd_en <= 1'b0;
    end else begin
        ram_rd_en <= ram_rd_en_r;
    end
end

//processing xcorr_start reg
always @(posedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        xcorr_start <= 1'b1;
    end else if (cr_calc_en && !fifo_en_mask) begin
        xcorr_start <= 1'b0;
    end else begin
        xcorr_start <= 1'b1;
    end
end

//processing ram_rd_addr reg, delay 1 cycle
reg [9 - 1: 0] ram_rd_addr_r;
always @(posedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        ram_rd_addr_r <= 9'b0;
    end else if (cr_calc_en && !fifo_en_mask) begin
        ram_rd_addr_r <= ram_rd_addr_r + 1'b1;
    end else begin
        ram_rd_addr_r <= 9'b0;
    end
end

always @(posedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        ram_rd_addr <= 9'b0;
    end else begin
        ram_rd_addr <= ram_rd_addr_r;
    end
end

//processing complete number cnt
reg     [9 - 1: 0]  complete_cnt;
always @(posedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        complete_cnt <= 9'b0;
    end else if (cr_calc_en & xcorr_done) begin
        complete_cnt <= complete_cnt + 1'b1;
    end else if(cr_fifo_in) begin
        complete_cnt <= 9'b0;
    end else begin
        complete_cnt <= complete_cnt;
    end
end

assign xcorr_all_complete = (complete_cnt > LAG_NUM) ? 1'b1 : 1'b0;

//processing subsys_done reg
always @(posedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        subsys_done <= 1'b0;
    end else if (cr_output) begin
        subsys_done <= 1'b1;
    end else begin
        subsys_done <= 1'b0;
    end
end

//Measuring the number of the biggest xcorr_data
reg signed [6 - 1: 0]   lag;
reg signed [32- 1: 0]   max_xcorr_data;

assign cr_xcorr_bigger = (abs_xcorr_data >= max_xcorr_data) ? 1'b1 : 1'b0;

always @(posedge clk_60MHz or negedge rst_n) begin
    if (!rst_n) begin
        lag <= -LAGNUM;
        lag_diff <= 6'b0;
        max_xcorr_data <= 31'b0;
    end else if (xcorr_done) begin
        lag <= lag + 1'b1;
        lag_diff <= (cr_xcorr_bigger ? lag : lag_diff);
        max_xcorr_data <= (cr_xcorr_bigger ? abs_xcorr_data : max_xcorr_data);
    end else if(cr_fifo_in) begin
        lag <= -LAGNUM;
        lag_diff <= 6'b0;
        max_xcorr_data <= 31'b0;
    end else begin
        lag <= lag;
        lag_diff <= lag_diff;
        max_xcorr_data <= max_xcorr_data;
    end
end

assign fifo_mic0_wr_en  = fifo_en_mask;
assign fifo_mic1_wr_en  = fifo_en_mask;
assign abs_xcorr_data   = (xcorr_data[31] == 1) ? (~xcorr_data + 1'b1) : xcorr_data; //abs

//abs U_XCORR_ABS(
//	 .datai              (xcorr_data        ) //i[32- 1: 0]
//    ,.datao              (abs_xcorr_data    ) //o[32- 1: 0]
//);

i2s_decoder#(
	 .DATAWIDTH         (24)
)
U_I2S_DECODER_0(
	 .clk_mic           (clk_mic            ) //i
	,.rst_mic_n         (rst_mic_n          ) //i
	,.WS                (clk_WS             ) //i
	,.DATA              (mic0_data_in       ) //i
	,.L_DATA            (mic0_data          ) //o[DATAWIDTH - 1: 0]
	,.R_DATA            () //o[DATAWIDTH - 1: 0]
    ,.L_Sel             () //o
    ,.R_Sel             () //o
	,.recv_over         (mic0_data_en       ) //o
);

i2s_decoder#(
	 .DATAWIDTH         (24)
)
U_I2S_DECODER_1(
	 .clk_mic           (clk_mic            ) //i
	,.rst_mic_n         (rst_mic_n          ) //i
	,.WS                (clk_WS             ) //i
	,.DATA              (mic1_data_in       ) //i
	,.L_DATA            (mic1_data          ) //o[DATAWIDTH - 1: 0]
	,.R_DATA            () //o[DATAWIDTH - 1: 0]
    ,.L_Sel             () //o
    ,.R_Sel             () //o
	,.recv_over         (mic1_data_en       ) //o
);

ram0_512 U_RAM0_512(
    .clka               (clk_WS             ), //input clka
    .reseta             (!rst_mic_n         ), //input reseta
    .cea                (fifo_mic0_wr_en    ), //input cea
    .ada                (ram_wr_addr        ), //input [8:0] ada
    .din                (mic0_data          ), //input [15:0] din
    

    .clkb               (clk_60MHz          ), //input clkb
    .resetb             (!rst_n             ), //input resetb
    .ceb                (ram_rd_en          ), //input ceb
    .adb                (ram_rd_addr        ),//input [8:0] adb
    .dout               (mic0_fifo_data     ), //output [15:0] dout

    .oce                (1'b1               )  //input oce
);

ram1_512 U_RAM1_512(
    .clka               (clk_WS             ), //input clka
    .reseta             (!rst_mic_n         ), //input reseta
    .cea                (fifo_mic1_wr_en    ), //input cea
    .ada                (ram_wr_addr        ), //input [8:0] ada
    .din                (mic1_data          ), //input [15:0] din
    

    .clkb               (clk_60MHz          ), //input clkb
    .resetb             (!rst_n             ), //input resetb
    .ceb                (ram_rd_en          ), //input ceb
    .adb                (ram_rd_addr        ),//input [8:0] adb
    .dout               (mic1_fifo_data     ), //output [15:0] dout

    .oce                (1'b1               )  //input oce
);


XCORR_NEW_Top U_XCORR_Top(
    .clk                (clk_60MHz          ), //input clk
    .rstn               (ram_rd_en          ), //input rstn
    .series_x           (mic1_fifo_data     ), //input [15:0] series_x
    .series_y           (mic0_fifo_data     ), //input [15:0] series_y
    // .start              (xcorr_start        ), //input start_n
    .result             (xcorr_data         ), //output [31:0] result
    .complete           (xcorr_done         ), //output complete
    .delay              () //output [9:0] delay
);

endmodule