`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 25.08.2022
// Designer : Hank.Gan
// Design Name: myxcorr
// Description: A DSP module used to calculate XCORR
// Dependencies: Semi dual-port Block RAM 
// Revision 1.0
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////
module myxcorr #(
     parameter       DATAWIDTH           = 24
    ,parameter       SEQUENCE_LENGTH     = 512
)
(
     input                              clk
    ,input                              clk_WS
    ,input                              rst_n
    ,input                              rst_mic_n
    ,input                              mic_data_valid
    ,input      [DATAWIDTH - 1: 0]      series_x
    ,input      [DATAWIDTH - 1: 0]      series_y
    
    ,output                             complete
    ,output reg [2*DATAWIDTH- 1: 0]     result
    ,output reg [12- 1: 0]              lag

);

localparam IDLE         =   3'b000;
localparam READMEM      =   3'b001;
localparam CALCULATE    =   3'b010;
localparam SHIFT        =   3'b011;

//store x and ydata into mem, untill the number of data meets the length
reg     [10- 1: 0]      valid_data_cnt;
wire    [10- 1: 0]      mem_x_addr_wr;
wire    [10- 1: 0]      mem_y_addr_wr;

always @(posedge clk_WS or negedge rst_mic_n) begin
    if (!rst_mic_n) begin
        valid_data_cnt <= 12'b0;
    end else begin
        if (mic_data_valid && valid_data_cnt < SEQUENCE_LENGTH) begin
            valid_data_cnt <= valid_data_cnt + 1'b1;
        end else begin
            valid_data_cnt <= valid_data_cnt;
        end
    end
end

assign mem_x_addr_wr = valid_data_cnt;
assign mem_y_addr_wr = valid_data_cnt;

// xcorr main FSM
reg     [ 3- 1: 0]          cr_state;
reg     [ 3- 1: 0]          nx_state;

reg     [12- 1: 0]          shift_ptr;
reg     [12- 1: 0]          calc_ptr;
wire    [DATAWIDTH - 1: 0]  mem_x_data_rd;
wire    [DATAWIDTH - 1: 0]  mem_y_data_rd;
reg     [10- 1: 0]          mem_x_addr_rd;
reg     [10- 1: 0]          mem_y_addr_rd;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cr_state <= IDLE;
    end else begin
        cr_state <= nx_state;
    end
end

always @(*) begin
    case (cr_state)
        IDLE : begin
            if (valid_data_cnt >= SEQUENCE_LENGTH) begin
                nx_state = READMEM;
            end else begin
                nx_state = IDLE;
            end
        end
        READMEM : begin

        end
    endcase

end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_ptr <= 12'b0;
        calc_ptr <= 12'b0;
    end else begin
        case (cr_state)
            READMEM : begin
                mem_x_addr_rd <= shift_ptr;
                mem_y_addr_rd <= SEQUENCE_LENGTH - 1'b1 - (calc_ptr - shift_ptr);
                shift_ptr <= shift_ptr + 1'b1;
            end
            CALCULATE : begin
                result <= mem_x_data_rd * mem_y_data_rd;
            end
        endcase
    end
end

mem_x U_MEM_X(
    .dout               (mem_x_data_rd  ), //o[DATAWIDTH - 1: 0]
    .clka               (clk_WS         ), //i
    .cea                (mic_data_valid ), //i
    .reseta             (rst_mic_n      ), //i
    .clkb               (clk            ), //i
    .ceb                (1'b1           ), //i
    .resetb             (rst_n          ), //i
    .oce                (               ), //i
    .ada                (mem_x_addr_wr  ), //i[10- 1: 0]
    .din                (series_x       ), //i[DATAWIDTH - 1: 0]
    .adb                (mem_x_addr_rd  )  //i[10- 1: 0]
);

mem_y U_MEM_Y(
    .dout               (mem_y_data_rd  ), //o[DATAWIDTH - 1: 0]
    .clka               (clk_WS         ), //i
    .cea                (mic_data_valid ), //i
    .reseta             (rst_mic_n      ), //i
    .clkb               (clk            ), //i
    .ceb                (1'b1           ), //i
    .resetb             (rst_n          ), //i
    .oce                (               ), //i
    .ada                (mem_y_addr_wr  ), //i[10- 1: 0]
    .din                (series_y       ), //i[DATAWIDTH - 1: 0]
    .adb                (mem_y_addr_rd  )  //i[10- 1: 0]
);

endmodule