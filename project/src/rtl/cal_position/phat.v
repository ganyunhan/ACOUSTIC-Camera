module phat_fft_abs (
     input                      clk
    ,input                      rst_n
    ,input signed [32- 1: 0]    xcorr_data
    ,input                      xcorr_done
    ,output signed [6 - 1: 0]   lag_diff
);


localparam      IDLE         = 4'b0000;
localparam      FFT_START    = 4'b0001;
localparam      FFT_CAL      = 4'b0010;
localparam      ABS_CAL      = 4'b0011;
localparam      IFFT_CAL     = 4'b0100;
localparam      OUTPUT       = 4'b0101;

wire                        abs_done;
wire                        fifo_full;
wire [7 - 1: 0]             xcorr_fifo_wnum;
wire [7 - 1: 0]             xcorr_fifo_rnum;
reg  [4 - 1: 0]             cr_state;
reg  [4 - 1: 0]             nx_state;
wire                        fft_opd;
wire                        fft_eoud;
wire [16- 1: 0]             abs_data;

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
            if (xcorr_fifo_wnum >= 'd33) begin
                nx_state = FFT_START;
            end else begin
                nx_state = IDLE;
            end
        end
        FFT_START: begin
            nx_state = FFT_CAL;
        end
        FFT_CAL: begin
            if (fft_eoud) begin
                nx_state = ABS_CAL;
            end else begin  
                nx_state = FFT_CAL;
            end
        end
        ABS_CAL: begin
            if (abs_done) begin
                nx_state = IFFT_CAL;
            end else begin
                nx_state = ABS_CAL;
            end
        end
        IFFT_CAL: begin
            nx_state = IDLE;
        end
        default: begin
            nx_state = IDLE;
        end
    endcase
end

assign cr_fft_cal       = (cr_state == FFT_CAL  ) ? 1'b1 : 1'b0;
assign cr_fft_start     = (cr_state == FFT_START) ? 1'b1 : 1'b0;
assign cr_abs_cal       = (cr_state == ABS_CAL  ) ? 1'b1 : 1'b0;
assign cr_ifft_cal      = (cr_state == IFFT_CAL ) ? 1'b1 : 1'b0;

assign nx_fft_cal       = (nx_state == FFT_CAL  ) ? 1'b1 : 1'b0;
assign nx_fft_start     = (nx_state == FFT_START) ? 1'b1 : 1'b0;
assign nx_abs_cal       = (nx_state == ABS_CAL  ) ? 1'b1 : 1'b0;
assign nx_ifft_cal      = (nx_state == IFFT_CAL ) ? 1'b1 : 1'b0;

//FFT_CAL : fft_start
reg                         fft_start;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fft_start <= 1'b0;
    end else if (cr_fft_start) begin
        fft_start <= 1'b1;
    end else begin
        fft_start <= 1'b0;
    end
end

//FFT_CAL : fifo_read
reg                     fifo_rd_en;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_rd_en <= 1'b0;
    end else if (nx_fft_start | nx_fft_cal) begin
        fifo_rd_en <= 1'b1;
    end else begin
        fifo_rd_en <= 1'b0;
    end
end

//FFT_CAL : fft data address
reg [6 - 1: 0]          fft_addr;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fft_addr <= 6'b0;
    end else if (fft_opd) begin
        fft_addr <= fft_addr + 1'b1;
    end else begin
        fft_addr <= 6'b0;
    end
end

wire signed [32- 1 :0]      xcorr_fifo_data;
wire signed [32- 1 :0]      fifo_fft_data;

assign fifo_fft_data = (xcorr_fifo_rnum == 'd0) ? 32'b0 : xcorr_fifo_data;

fifo_top U_XCORR_DATA_FIFO(
    .WrClk                  (clk            ), //input WrClk
    .WrEn                   (xcorr_done     ), //input WrEn
    .Data                   (xcorr_data     ), //input [31:0] Data

    .RdClk                  (clk            ), //input RdClk
    .RdEn                   (fifo_rd_en     ), //input RdEn
    .Q                      (xcorr_fifo_data), //output [31:0] Q

    .Reset                  (!rst_n         ), //input Reset
    .Wnum                   (xcorr_fifo_wnum), //output [6:0] Wnum
    .Rnum                   (xcorr_fifo_rnum), //output [6:0] Rnum
    .Empty                  (), //output Empty
    .Full                   (fifo_full      )  //output Full
);

wire signed [32- 1: 0] fft_re;
wire signed [32- 1: 0] fft_im;

FFT_Top U_FFT_TOP(
    .clk                    (clk            ), //input clk
    .rst                    (!rst_n         ), //input rst
    .start                  (fft_start      ), //input start
    .xn_re                  (fifo_fft_data  ), //input [31:0] xn_re
    .xn_im                  (32'b0          ), //input [31:0] xn_im

    .idx                    (               ), //output [5:0] idx
    .xk_re                  (fft_re         ), //output [31:0] xk_re
    .xk_im                  (fft_im         ), //output [31:0] xk_im
    .sod                    (               ), //output sod
    .ipd                    (               ), //output ipd
    .eod                    (               ), //output eod
    .busy                   (               ), //output busy
    .soud                   (               ), //output soud
    .opd                    (fft_opd        ), //output opd
    .eoud                   (fft_eoud       ) //output eoud
);

fft_abs_ram U_FFT_RE(
    
    .clka                   (clk            ), //input clka
    .reseta                 (!rst_n         ), //input reseta
    .cea                    (fft_opd        ), //input cea
    .ada                    (fft_addr       ), //input [5:0] ada
    .din                    (fft_re         ), //input [31:0] din
    
    .clkb                   (clk), //input clkb
    .resetb                 (!rst_n), //input resetb
    .ceb                    (ceb_i), //input ceb
    .adb                    (adb_i), //input [5:0] adb
    .dout                   (abs_re), //output [31:0] dout
    
    .oce                    (oce_i)  //input oce   
);

fft_abs_ram U_FFT_IM(
    
    .clka                   (clk            ), //input clka
    .reseta                 (!rst_n         ), //input reseta
    .cea                    (fft_opd        ), //input cea
    .ada                    (fft_addr       ), //input [5:0] ada
    .din                    (fft_im         ), //input [31:0] din
    
    .clkb                   (clk), //input clkb
    .resetb                 (!rst_n), //input resetb
    .ceb                    (ceb_i), //input ceb
    .adb                    (adb_i), //input [5:0] adb
    .dout                   (abs_im), //output [31:0] dout
    
    .oce                    (oce_i)  //input oce   
);

fft_abs_ram U_ABS_RAM(
    
    .clka                   (clk            ), //input clka
    .reseta                 (!rst_n         ), //input reseta
    .cea                    (fft_opd        ), //input cea
    .ada                    (fft_addr       ), //input [5:0] ada
    .din                    (abs_data       ), //input [31:0] din
    
    .clkb                   (clk), //input clkb
    .resetb                 (!rst_n), //input resetb
    .ceb                    (ceb_i), //input ceb
    .adb                    (adb_i), //input [5:0] adb
    .dout                   (dout_o), //output [31:0] dout
    
    .oce                    (oce_i)  //input oce   
);
 
sqrt U_SQRT(
    .in_data                (), // input wire [31:0] 
    .clk                    (clk), // input             
    .out_data               (abs_data), // output reg [15:0] 
    .sqrt_end               ()  // output reg        
);

endmodule //phat