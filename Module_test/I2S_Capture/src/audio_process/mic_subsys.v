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

module mic_subsys (
     input           PAD_CLK
    ,input           PAD_RST_N
    ,input           PAD_KEY1
    ,input           PAD_KEY2
    ,input           PAD_MIC0_DA
    ,input           PAD_MIC12_DA
    ,input           PAD_MIC34_DA
    ,input           PAD_MIC56_DA
    ,output          PAD_WS
    ,output          PAD_CLK_MIC
    ,output          PAD_TXD
);

wire [4 - 1: 0]         mic_data_in;
wire signed [24-1:0]    mic_data [0:6];

wire                    RdEn_i;
wire                    key2;
wire                    clk_60MHz;
wire        [16- 1: 0]  Fifo_data0;
wire        [16- 1: 0]  Fifo_data1;
wire        [16- 1: 0]  Fifo_data2;
wire        [16- 1: 0]  Fifo_data3;
wire        [16- 1: 0]  Fifo_data4;
wire        [16- 1: 0]  Fifo_data5;
wire        [16- 1: 0]  Fifo_data6;
reg         [7 - 1: 0]  Fifo_rd;
wire        [7 - 1: 0]  Fifo_empty;
wire        [16- 1: 0]  uart_data;

reg   [4 - 1: 0]            nx_state;
reg   [4 - 1: 0]            cr_state;

localparam IDLE         =   4'b0000;
localparam FIFO_RD_0    =   4'b0001;
localparam FIFO_RD_1    =   4'b0010;
localparam FIFO_RD_2    =   4'b0011;
localparam FIFO_RD_3    =   4'b0100;
localparam FIFO_RD_4    =   4'b0101;
localparam FIFO_RD_5    =   4'b0110;
localparam FIFO_RD_6    =   4'b0111;

i2s_decoder#(
	 .DATAWIDTH         (24)
)
u_i2s_decoder0(
	 .clk_mic           (o_mic_sclk) //i
	,.rst_mic_n         (i_rst_n) //i
	,.WS                (o_mic_ws) //i
	,.DATA              (mic_data_in[0]) //i
	,.L_DATA_O          () //o[DATAWIDTH - 1: 0]
	,.R_DATA_O          (mic_data[0]) //o[DATAWIDTH - 1: 0]
    ,.L_Sel             ()
	,.R_Sel             ()
	,.recv_over         () //o
);

i2s_decoder#(
	 .DATAWIDTH         (24)
)
u_i2s_decoder1(
	 .clk_mic           (o_mic_sclk) //i
	,.rst_mic_n         (i_rst_n) //i
	,.WS                (o_mic_ws) //i
	,.DATA              (mic_data_in[1]) //i
	,.L_DATA_O          (mic_data[1]) //o[DATAWIDTH - 1: 0]
	,.R_DATA_O          (mic_data[2]) //o[DATAWIDTH - 1: 0]
    ,.L_Sel             ()
	,.R_Sel             ()
	,.recv_over         () //o
);

i2s_decoder#(
	 .DATAWIDTH         (24)
)
u_i2s_decoder2(
	 .clk_mic           (o_mic_sclk) //i
	,.rst_mic_n         (i_rst_n) //i
	,.WS                (o_mic_ws) //i
	,.DATA              (mic_data_in[2]) //i
	,.L_DATA_O          (mic_data[3]) //o[DATAWIDTH - 1: 0]
	,.R_DATA_O          (mic_data[4]) //o[DATAWIDTH - 1: 0]
    ,.L_Sel             ()
	,.R_Sel             ()
	,.recv_over         () //o
);

i2s_decoder#(
	 .DATAWIDTH         (24)
)
u_i2s_decoder3(
	 .clk_mic           (o_mic_sclk) //i
	,.rst_mic_n         (i_rst_n) //i
	,.WS                (o_mic_ws) //i
	,.DATA              (mic_data_in[3]) //i
	,.L_DATA_O          (mic_data[5]) //o[DATAWIDTH - 1: 0]
	,.R_DATA_O          (mic_data[6]) //o[DATAWIDTH - 1: 0]
    ,.L_Sel             ()
	,.R_Sel             ()
	,.recv_over         () //o
);

//FIFO_HS_Top u_FIFO_0_Top(
//    .Data               (mic_data[0]), //input [15:0] Data
//    .WrClk              (o_mic_ws), //input WrClk
//    .RdClk              (clk_60MHz), //input RdClk
//    .WrEn               (!key1), //input WrEn
//    .RdEn               (RdEn_i), //input RdEn
//    .Wnum               (), //output [14:0] Wnum
//    .Rnum               (), //output [14:0] Rnum
//    .Almost_Empty       (), //output Almost_Empty
//    .Almost_Full        (), //output Almost_Full
//    .Q                  (Fifo_data0), //output [15:0] Q
//    .Empty              (Fifo_empty[0]), //output Empty
//    .Full               () //output Full
//);

FIFO_HS_Top u_FIFO_0_Top(
    .Data               (mic_data[0]), //input [15:0] Data
    .WrClk              (o_mic_ws), //input WrClk
    .RdClk              (clk_60MHz), //input RdClk
    .WrEn               (!key1), //input WrEn
    .RdEn               (RdEn_i&&Fifo_rd[0]), //input RdEn
    .Wnum               (), //output [14:0] Wnum
    .Rnum               (), //output [14:0] Rnum
    .Almost_Empty       (), //output Almost_Empty
    .Almost_Full        (), //output Almost_Full
    .Q                  (Fifo_data0), //output [15:0] Q
    .Empty              (Fifo_empty[0]), //output Empty
    .Full               () //output Full
);

FIFO_HS_Top u_FIFO_1_Top(
    .Data               (mic_data[1]), //input [15:0] Data
    .WrClk              (o_mic_ws), //input WrClk
    .RdClk              (clk_60MHz), //input RdClk
    .WrEn               (!key1), //input WrEn
    .RdEn               (RdEn_i&&Fifo_rd[1]), //input RdEn
    .Wnum               (), //output [14:0] Wnum
    .Rnum               (), //output [14:0] Rnum
    .Almost_Empty       (), //output Almost_Empty
    .Almost_Full        (), //output Almost_Full
    .Q                  (Fifo_data1), //output [15:0] Q
    .Empty              (Fifo_empty[1]), //output Empty
    .Full               () //output Full
);

FIFO_HS_Top u_FIFO_2_Top(
    .Data               (mic_data[2]), //input [15:0] Data
    .WrClk              (o_mic_ws), //input WrClk
    .RdClk              (clk_60MHz), //input RdClk
    .WrEn               (!key1), //input WrEn
    .RdEn               (RdEn_i&&Fifo_rd[2]), //input RdEn
    .Wnum               (), //output [14:0] Wnum
    .Rnum               (), //output [14:0] Rnum
    .Almost_Empty       (), //output Almost_Empty
    .Almost_Full        (), //output Almost_Full
    .Q                  (Fifo_data2), //output [15:0] Q
    .Empty              (Fifo_empty[2]), //output Empty
    .Full               () //output Full
);

FIFO_HS_Top u_FIFO_3_Top(
    .Data               (mic_data[3]), //input [15:0] Data
    .WrClk              (o_mic_ws), //input WrClk
    .RdClk              (clk_60MHz), //input RdClk
    .WrEn               (!key1), //input WrEn
    .RdEn               (RdEn_i&&Fifo_rd[3]), //input RdEn
    .Wnum               (), //output [14:0] Wnum
    .Rnum               (), //output [14:0] Rnum
    .Almost_Empty       (), //output Almost_Empty
    .Almost_Full        (), //output Almost_Full
    .Q                  (Fifo_data3), //output [15:0] Q
    .Empty              (Fifo_empty[3]), //output Empty
    .Full               () //output Full
);

FIFO_HS_Top u_FIFO_4_Top(
    .Data               (mic_data[4]), //input [15:0] Data
    .WrClk              (o_mic_ws), //input WrClk
    .RdClk              (clk_60MHz), //input RdClk
    .WrEn               (!key1), //input WrEn
    .RdEn               (RdEn_i&&Fifo_rd[4]), //input RdEn
    .Wnum               (), //output [14:0] Wnum
    .Rnum               (), //output [14:0] Rnum
    .Almost_Empty       (), //output Almost_Empty
    .Almost_Full        (), //output Almost_Full
    .Q                  (Fifo_data4), //output [15:0] Q
    .Empty              (Fifo_empty[4]), //output Empty
    .Full               () //output Full
);

FIFO_HS_Top u_FIFO_5_Top(
    .Data               (mic_data[5]), //input [15:0] Data
    .WrClk              (o_mic_ws), //input WrClk
    .RdClk              (clk_60MHz), //input RdClk
    .WrEn               (!key1), //input WrEn
    .RdEn               (RdEn_i&&Fifo_rd[5]), //input RdEn
    .Wnum               (), //output [14:0] Wnum
    .Rnum               (), //output [14:0] Rnum
    .Almost_Empty       (), //output Almost_Empty
    .Almost_Full        (), //output Almost_Full
    .Q                  (Fifo_data5), //output [15:0] Q
    .Empty              (Fifo_empty[5]), //output Empty
    .Full               () //output Full
);

FIFO_HS_Top u_FIFO_6_Top(
    .Data               (mic_data[6]), //input [15:0] Data
    .WrClk              (o_mic_ws), //input WrClk
    .RdClk              (clk_60MHz), //input RdClk
    .WrEn               (!key1), //input WrEn
    .RdEn               (RdEn_i&&Fifo_rd[6]), //input RdEn
    .Wnum               (), //output [14:0] Wnum
    .Rnum               (), //output [14:0] Rnum
    .Almost_Empty       (), //output Almost_Empty
    .Almost_Full        (), //output Almost_Full
    .Q                  (Fifo_data6), //output [15:0] Q
    .Empty              (Fifo_empty[6]), //output Empty
    .Full               () //output Full
);

assign uart_data = Fifo_rd[0] ? Fifo_data0 :
                   Fifo_rd[1] ? Fifo_data1 :
                   Fifo_rd[6] ? Fifo_data6 :
                   Fifo_rd[5] ? Fifo_data5 :
                   Fifo_rd[4] ? Fifo_data4 :
                   Fifo_rd[3] ? Fifo_data3 :
                   Fifo_rd[2] ? Fifo_data2 : 1'b0;


always @(posedge clk_60MHz or negedge i_rst_n) begin
    if(!i_rst_n)begin
        cr_state <= IDLE;
    end else begin
        cr_state <= nx_state;
    end
end

always @(*) begin
    case(cr_state)
        IDLE: begin
            nx_state = FIFO_RD_0;
        end
        FIFO_RD_0: begin
            if(Fifo_empty[0] && !key2) begin
                nx_state = FIFO_RD_1;
            end else begin
                nx_state = FIFO_RD_0;
            end
        end
        FIFO_RD_1: begin
            if(Fifo_empty[1]) begin
                nx_state = FIFO_RD_6;
            end else begin
                nx_state = FIFO_RD_1;
            end
        end
        FIFO_RD_2: begin
            if(Fifo_empty[2]) begin
                nx_state = IDLE;
            end else begin
                nx_state = FIFO_RD_2;
            end
        end
        FIFO_RD_3: begin
            if(Fifo_empty[3]) begin
                nx_state = FIFO_RD_2;
            end else begin
                nx_state = FIFO_RD_3;
            end
        end
        FIFO_RD_4: begin
            if(Fifo_empty[4]) begin
                nx_state = FIFO_RD_3;
            end else begin
                nx_state = FIFO_RD_4;
            end
        end
        FIFO_RD_5: begin
            if(Fifo_empty[5]) begin
                nx_state = FIFO_RD_4;
            end else begin
                nx_state = FIFO_RD_5;
            end
        end
        FIFO_RD_6: begin
            if(Fifo_empty[6]) begin
                nx_state = FIFO_RD_5;
            end else begin
                nx_state = FIFO_RD_6;
            end
        end
        default: begin
            nx_state = IDLE;
        end
    endcase
end

always @(posedge clk_60MHz or negedge i_rst_n )begin
    if (!i_rst_n) begin
        Fifo_rd <= 7'b0;
    end
    case(cr_state)
        IDLE: begin
            Fifo_rd <= 7'b0;
        end
        FIFO_RD_0: Fifo_rd <= 7'b0000001;
        FIFO_RD_1: Fifo_rd <= 7'b0000010;
        FIFO_RD_2: Fifo_rd <= 7'b0000100;
        FIFO_RD_3: Fifo_rd <= 7'b0001000;
        FIFO_RD_4: Fifo_rd <= 7'b0010000;
        FIFO_RD_5: Fifo_rd <= 7'b0100000;
        FIFO_RD_6: Fifo_rd <= 7'b1000000;
        default: Fifo_rd <= 7'b0000000;
    endcase
end

uart_top u_uart_top
(
	 .sys_clk		    (clk_60MHz)//i
	,.sys_rst_n		    (i_rst_n)//i
	,.data	            (uart_data)//i[16- 1: 0]
    ,.uart_ena          ((!key2)&(!Fifo_empty[2]))//i
	,.uart_ready	    (RdEn_i)//o
	,.uart_txd		    (o_mic_txd)//o	
);

// uart_top u_uart_top
// (
// 	 .sys_clk		    (clk_60MHz)//i
// 	,.sys_rst_n		    (i_rst_n)//i
// 	,.data	            (Fifo_data0)//i[16- 1: 0]
//     ,.uart_ena          ((!key2)&(!Fifo_empty[0]))//i
// 	,.uart_ready	    (RdEn_i)//o
// 	,.uart_txd		    (o_mic_txd)//o	
// );

clk_div#(
    .SCALER             (10)
)
u_clk_div_9
(
     .clk_in         (clk_60MHz)
    ,.rst_n          (i_rst_n)
    ,.clk_out        (o_mic_sclk)//6MHz
);

clk_div#(
   .SCALER           (64)
)
u_clk_div_64
(
    .clk_in         (!o_mic_sclk)
   ,.rst_n          (i_rst_n)
   ,.clk_out        (o_mic_ws)//93750Hz
);

gao_clk u_gao_clk(
    .clkout         (clk_60MHz), //output clkout
    .reset          (!i_rst_n), //input reset
    .clkin          (i_clk) //input clkin
);


assign key1             = PAD_KEY1;
assign key2             = PAD_KEY2;
assign i_clk            = PAD_CLK;
assign i_rst_n          = PAD_RST_N;
assign mic_data_in[0]   = PAD_MIC0_DA;
assign mic_data_in[1]   = PAD_MIC12_DA;
assign mic_data_in[2]   = PAD_MIC34_DA;
assign mic_data_in[3]   = PAD_MIC56_DA;
assign PAD_WS           = o_mic_ws;
assign PAD_CLK_MIC      = o_mic_sclk;
assign PAD_TXD          = o_mic_txd;
endmodule