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
     input                          clk
    ,input                          clk_mic
    ,input                          clk_WS
    ,input                          rst_n
    ,input                          rst_mic_n
    ,input             [4 - 1: 0]   mic_data_in
    ,input                          subsys_start
    ,output  reg                    subsys_done
    ,output  signed   [6 - 1: 0]    lag_diff_0
    ,output  signed   [6 - 1: 0]    lag_diff_1
    ,output  signed   [6 - 1: 0]    lag_diff_2
    ,output  signed   [6 - 1: 0]    lag_diff_3
    ,output  signed   [6 - 1: 0]    lag_diff_4
    ,output  signed   [6 - 1: 0]    lag_diff_5
);

//FSM of controlling xcorr/fifo I/O 
reg         [3 - 1: 0]          cr_state;
reg         [3 - 1: 0]          nx_state;
reg         [9 - 1: 0]          ram_wr_addr;
reg         [9 - 1: 0]          ram_rd_addr;

reg                             xcorr_start;
reg                             fifo_en_mask;
reg                             ram_rd_en;
wire                            xcorr_all_complete;
wire                            xcorr_calc_done;


// `define      SIM_ROM_DATA
`define      SIM_MIC_DATA

localparam      IDLE         = 3'b000;
localparam      FIFO_IN      = 3'b001;
localparam      CALC_EN      = 3'b010;
localparam      OUTPUT       = 3'b011;

localparam      LAG_NUM     = LAGNUM * 2;

always @(posedge clk or negedge rst_n) begin
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
        `ifdef SIM_ROM_DATA
                nx_state = CALC_EN;
        `elsif SIM_MIC_DATA
                nx_state = FIFO_IN;
        `endif
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
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ram_rd_en_r <= 1'b0;
    end else if (cr_calc_en && !fifo_en_mask) begin
        ram_rd_en_r <= 1'b1;
    end else begin
        ram_rd_en_r <= 1'b0;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ram_rd_en <= 1'b0;
    end else begin
        ram_rd_en <= ram_rd_en_r;
    end
end

//processing xcorr_start reg
always @(posedge clk or negedge rst_n) begin
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
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ram_rd_addr_r <= 9'b0;
    end else if (cr_calc_en && !fifo_en_mask) begin
        ram_rd_addr_r <= ram_rd_addr_r + 1'b1;
    end else begin
        ram_rd_addr_r <= 9'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ram_rd_addr <= 9'b0;
    end else begin
        ram_rd_addr <= ram_rd_addr_r;
    end
end

//processing complete number cnt
reg     [9 - 1: 0]  complete_cnt;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        complete_cnt <= 9'b0;
    end else if (cr_calc_en & xcorr_calc_done) begin
        complete_cnt <= complete_cnt + 1'b1;
    end else if(cr_fifo_in) begin
        complete_cnt <= 9'b0;
    end else begin
        complete_cnt <= complete_cnt;
    end
end

assign xcorr_all_complete = (complete_cnt > LAG_NUM) ? 1'b1 : 1'b0;

//processing subsys_done reg
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        subsys_done <= 1'b0;
    end else if (cr_output) begin
        subsys_done <= 1'b1;
    end else begin
        subsys_done <= 1'b0;
    end
end

//Measuring the number of the biggest xcorr_data
genvar m;
reg signed  [6 - 1: 0]          lag             [6 - 1: 0];
reg signed  [6 - 1: 0]          lag_diff        [6 - 1: 0];
reg signed  [32- 1: 0]          max_xcorr_data  [6 - 1: 0];
wire        [32- 1: 0]          abs_xcorr_data  [6 - 1: 0];
wire                            cr_xcorr_bigger [6 - 1: 0];
wire signed [32- 1: 0]          xcorr_data      [6 - 1: 0];
wire                            xcorr_done      [6 - 1: 0];

generate
    for (m = 0; m < 6; m = m + 1) begin: find_max_lag
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                lag[m] <= -LAGNUM;
                lag_diff[m] <= 6'b0;
                max_xcorr_data[m] <= 31'b0;
            end else if (xcorr_done[m]) begin
                lag[m] <= lag[m] + 1'b1;
                lag_diff[m] <= (cr_xcorr_bigger[m] ? lag[m] : lag_diff[m]);
                max_xcorr_data[m] <= (cr_xcorr_bigger[m] ? abs_xcorr_data[m] : max_xcorr_data[m]);
            end else if(cr_fifo_in) begin
                lag[m] <= -LAGNUM;
                lag_diff[m] <= 6'b0;
                max_xcorr_data[m] <= 31'b0;
            end else begin
                lag[m] <= lag[m];
                lag_diff[m] <= lag_diff[m];
                max_xcorr_data[m] <= max_xcorr_data[m];
            end
        end
        assign cr_xcorr_bigger[m] = (abs_xcorr_data[m] >= max_xcorr_data[m]) ? 1'b1 : 1'b0;
        assign abs_xcorr_data[m]  = (xcorr_data[m][31] == 1) ? (~xcorr_data[m] + 1'b1) : xcorr_data[m]; //abs
    end
endgenerate

assign lag_diff_0 = lag_diff[0];
assign lag_diff_1 = lag_diff[1];
assign lag_diff_2 = lag_diff[2];
assign lag_diff_3 = lag_diff[3];
assign lag_diff_4 = lag_diff[4];
assign lag_diff_5 = lag_diff[5];

// I2S_Drivers
genvar i;
wire signed [16- 1: 0]          mic_data [7 - 1: 0];
wire        [4 - 1: 0]          mic_data_en;

i2s_decoder#(
	 .DATAWIDTH         (24)
)
U_I2S_DECODER_0(
	 .clk_mic           (clk_mic            ) //i
	,.rst_mic_n         (rst_mic_n          ) //i
	,.WS                (clk_WS             ) //i
	,.DATA              (mic_data_in[0]     ) //i
	,.L_DATA            () //o[DATAWIDTH - 1: 0]
	,.R_DATA            (mic_data[0]        ) //o[DATAWIDTH - 1: 0]
    ,.L_Sel             () //o
    ,.R_Sel             () //o
	,.recv_over         (mic_data_en[0]     ) //o
);

generate
    for (i = 1; i <= 5; i = i + 2) begin: I2S_Decoder
        i2s_decoder#(
            .DATAWIDTH         (24)
        )
        U_I2S_DECODER(
            .clk_mic            (clk_mic            ) //i
            ,.rst_mic_n         (rst_mic_n          ) //i
            ,.WS                (clk_WS             ) //i
            ,.DATA              (mic_data_in[(i + 1)/2]) //i
            ,.L_DATA            (mic_data[i]        ) //o[DATAWIDTH - 1: 0]
            ,.R_DATA            (mic_data[i + 1]    ) //o[DATAWIDTH - 1: 0]
            ,.L_Sel             () //o
            ,.R_Sel             () //o
            ,.recv_over         (mic_data_en[(i + 1)/2]) //o
        );
    end
endgenerate


//Data RAM
wire signed [16- 1: 0]          mic_fifo_data [7 - 1: 0];

`ifdef SIM_ROM_DATA
ram0_512 U_RAM0_512(
.clka                   (clk_WS             ), //input clka
.reseta                 (!rst_mic_n         ), //input reseta
.cea                    (fifo_en_mask       ), //input cea
.ada                    (ram_wr_addr        ), //input [8:0] ada
.din                    (mic_data[0]        ), //input [15:0] din


.clkb                   (clk                ), //input clkb
.resetb                 (!rst_n             ), //input resetb
.ceb                    (ram_rd_en          ), //input ceb
.adb                    (ram_rd_addr        ),//input [8:0] adb
.dout                   (mic_fifo_data[0]   ), //output [15:0] dout

.oce                    (1'b1               )  //input oce
);

ram1_512 U_RAM1_512(
.clka                   (clk_WS             ), //input clka
.reseta                 (!rst_mic_n         ), //input reseta
.cea                    (fifo_en_mask       ), //input cea
.ada                    (ram_wr_addr        ), //input [8:0] ada
.din                    (mic_data[1]        ), //input [15:0] din


.clkb                   (clk                ), //input clkb
.resetb                 (!rst_n             ), //input resetb
.ceb                    (ram_rd_en          ), //input ceb
.adb                    (ram_rd_addr        ),//input [8:0] adb
.dout                   (mic_fifo_data[1]   ), //output [15:0] dout

.oce                    (1'b1               )  //input oce
);

ram2_512 U_RAM2_512(
.clka                   (clk_WS             ), //input clka
.reseta                 (!rst_mic_n         ), //input reseta
.cea                    (fifo_en_mask       ), //input cea
.ada                    (ram_wr_addr        ), //input [8:0] ada
.din                    (mic_data[2]        ), //input [15:0] din


.clkb                   (clk                ), //input clkb
.resetb                 (!rst_n             ), //input resetb
.ceb                    (ram_rd_en          ), //input ceb
.adb                    (ram_rd_addr        ),//input [8:0] adb
.dout                   (mic_fifo_data[2]   ), //output [15:0] dout

.oce                    (1'b1               )  //input oce
);

ram3_512 U_RAM3_512(
.clka                   (clk_WS             ), //input clka
.reseta                 (!rst_mic_n         ), //input reseta
.cea                    (fifo_en_mask       ), //input cea
.ada                    (ram_wr_addr        ), //input [8:0] ada
.din                    (mic_data[3]        ), //input [15:0] din


.clkb                   (clk                ), //input clkb
.resetb                 (!rst_n             ), //input resetb
.ceb                    (ram_rd_en          ), //input ceb
.adb                    (ram_rd_addr        ),//input [8:0] adb
.dout                   (mic_fifo_data[3]   ), //output [15:0] dout

.oce                    (1'b1               )  //input oce
);

ram4_512 U_RAM4_512(
.clka                   (clk_WS             ), //input clka
.reseta                 (!rst_mic_n         ), //input reseta
.cea                    (fifo_en_mask       ), //input cea
.ada                    (ram_wr_addr        ), //input [8:0] ada
.din                    (mic_data[4]        ), //input [15:0] din


.clkb                   (clk                ), //input clkb
.resetb                 (!rst_n             ), //input resetb
.ceb                    (ram_rd_en          ), //input ceb
.adb                    (ram_rd_addr        ),//input [8:0] adb
.dout                   (mic_fifo_data[4]   ), //output [15:0] dout

.oce                    (1'b1               )  //input oce
);

ram5_512 U_RAM5_512(
.clka                   (clk_WS             ), //input clka
.reseta                 (!rst_mic_n         ), //input reseta
.cea                    (fifo_en_mask       ), //input cea
.ada                    (ram_wr_addr        ), //input [8:0] ada
.din                    (mic_data[5]        ), //input [15:0] din


.clkb                   (clk                ), //input clkb
.resetb                 (!rst_n             ), //input resetb
.ceb                    (ram_rd_en          ), //input ceb
.adb                    (ram_rd_addr        ),//input [8:0] adb
.dout                   (mic_fifo_data[5]   ), //output [15:0] dout

.oce                    (1'b1               )  //input oce
);

ram6_512 U_RAM6_512(
.clka                   (clk_WS             ), //input clka
.reseta                 (!rst_mic_n         ), //input reseta
.cea                    (fifo_en_mask       ), //input cea
.ada                    (ram_wr_addr        ), //input [8:0] ada
.din                    (mic_data[6]        ), //input [15:0] din


.clkb                   (clk                ), //input clkb
.resetb                 (!rst_n             ), //input resetb
.ceb                    (ram_rd_en          ), //input ceb
.adb                    (ram_rd_addr        ),//input [8:0] adb
.dout                   (mic_fifo_data[6]   ), //output [15:0] dout

.oce                    (1'b1               )  //input oce
);
`elsif SIM_MIC_DATA

    genvar j;
    generate
        for (j = 0; j < 7; j = j + 1) begin: MIC_DATA_RAM
            ram_512 U_RAM_512(
            .clka                   (clk_WS             ), //input clka
            .reseta                 (!rst_mic_n         ), //input reseta
            .cea                    (fifo_en_mask       ), //input cea
            .ada                    (ram_wr_addr        ), //input [8:0] ada
            .din                    (mic_data[j]        ), //input [15:0] din


            .clkb                   (clk                ), //input clkb
            .resetb                 (!rst_n             ), //input resetb
            .ceb                    (ram_rd_en          ), //input ceb
            .adb                    (ram_rd_addr        ),//input [8:0] adb
            .dout                   (mic_fifo_data[j]   ), //output [15:0] dout

            .oce                    (1'b1               )  //input oce
        );
        end
    endgenerate

`endif


//XCORR CALC
genvar k;

generate
    for (k = 1; k < 7; k = k + 1) begin: XCORR_MODULE
        XCORR_NEW_Top U_XCORR_TOP(
            .clk                (clk          ), //input clk
            .rstn               (ram_rd_en          ), //input rstn
            .series_x           (mic_fifo_data[k]   ), //input [15:0] series_x
            .series_y           (mic_fifo_data[0]   ), //input [15:0] series_y
            // .start              (xcorr_start        ), //input start_n
            .result             (xcorr_data[k - 1]  ), //output [31:0] result
            .complete           (xcorr_done[k - 1]  ), //output complete
            .delay              () //output [9:0] delay
        );
    end
endgenerate

assign xcorr_calc_done = xcorr_done[0] & xcorr_done[1] & xcorr_done[2]
                        &xcorr_done[3] & xcorr_done[4] & xcorr_done[5];

endmodule