//////////////////////////////////////////////////////////////////////////////////
// Create Date: 03.09.2022
// Designer : Hank.Gan
// Design Name: UART_TOP
// Description: UART_send_three bytes (including )
// Dependencies: uart_tx
// Revision 1.0
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////
module uart_top(
     input              sys_clk
    ,input              sys_rst_n
    ,input [16 - 1: 0]  data
    ,input              uart_ena
    ,output  reg        uart_ready
    ,output             uart_txd
);

reg [3 - 1: 0]  cr_state;
reg [3 - 1: 0]  nx_state;
reg [8 - 1: 0]  uart_tx_data;
reg             uart_tx_en;
reg [8 - 1: 0]  ascii_out [5 - 1: 0];
wire            uart_tx_done;
wire            all_send_done;

reg [8 - 1: 0]  hex_table [10- 1: 0];
reg [3 - 1: 0]  send_num;

localparam      NEW_LINE     = 8'h0D;

// FSM define
localparam      IDLE         = 3'b000;
localparam      GET_BYTE     = 3'b001;
localparam      SEND_BYTE    = 3'b010;
localparam      SEND_DONE    = 3'b011;
localparam      NL_BYTE      = 3'b100;
localparam      NL_DONE      = 3'b101;

localparam      BYTE_NUM     = 4;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cr_state <= IDLE;
    end else begin
        cr_state <= nx_state;
    end
end

always @(*) begin
	case (cr_state)
		IDLE: begin 
            if (uart_ena) begin
                nx_state = GET_BYTE;
            end else begin
                nx_state = IDLE;
            end
        end
        GET_BYTE: begin
            nx_state = SEND_BYTE;
        end
		SEND_BYTE: begin 
            if (uart_tx_done) begin
                nx_state = SEND_DONE;
            end else begin
                nx_state = SEND_BYTE;
            end
        end
		SEND_DONE: begin
            if (all_send_done) begin
                nx_state = NL_BYTE;
            end else begin
                nx_state = SEND_BYTE;
            end
        end
		NL_BYTE: begin
            if (uart_tx_done) begin
                nx_state = NL_DONE;
            end else begin
                nx_state = NL_BYTE;
            end
        end
		NL_DONE: begin
            nx_state = IDLE;
        end
		default: nx_state = IDLE;
	endcase
end

assign  cr_send_byte    = (cr_state == SEND_BYTE) ? 1'b1 : 1'b0;
assign  cr_send_done    = (cr_state == SEND_DONE) ? 1'b1 : 1'b0;
assign  cr_nl_byte      = (cr_state == NL_BYTE) ? 1'b1 : 1'b0;
assign  cr_nl_done      = (cr_state == NL_DONE) ? 1'b1 : 1'b0;
assign  cr_idle         = (cr_state == IDLE) ? 1'b1 : 1'b0;

assign  cr_get_byte     = (cr_state == GET_BYTE) ? 1'b1 : 1'b0;

//processing data reg
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        uart_tx_data <= 8'b0;
    end else if (cr_send_byte) begin
        uart_tx_data <= ascii_out[4 - send_num]; //MSB_first
    end else if (cr_nl_byte) begin
        uart_tx_data <= NEW_LINE;       //send new line
    end else begin
        uart_tx_data <= 8'b0;
    end
end

//processing enable reg
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        uart_tx_en <= 1'b0;
    end else if (cr_send_byte) begin
        uart_tx_en <= 1'b1;
    end else if (cr_nl_byte) begin
        uart_tx_en <= 1'b1; 
    end else begin
        uart_tx_en <= 1'b0;
    end
end

//processing done reg
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        uart_ready <= 1'b0;
    end else if (cr_get_byte) begin
        uart_ready <= 1'b1;
    end else begin
        uart_ready <= 1'b0;
    end
end

//processing send_num
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        send_num <= 3'b0;
    end else if (cr_send_done) begin
        send_num <= send_num + 1'b1;
    end else if (cr_nl_byte) begin
        send_num <= 1'b0;
    end else begin
        send_num <= send_num;
    end
end

assign all_send_done = (send_num > BYTE_NUM - 1)? 1'b1 : 1'b0;

always @(posedge sys_clk) begin
    hex_table[0] <= 8'h30;
    hex_table[1] <= 8'h31;
    hex_table[2] <= 8'h32;
    hex_table[3] <= 8'h33;
    hex_table[4] <= 8'h34;
    hex_table[5] <= 8'h35;
    hex_table[6] <= 8'h36;
    hex_table[7] <= 8'h37;
    hex_table[8] <= 8'h38;
    hex_table[9] <= 8'h39;
end

always @(*) begin
    ascii_out[4] = hex_table[data / 'd10000];
    ascii_out[3] = hex_table[(data / 'd1000)%'d10];
    ascii_out[2] = hex_table[(data / 'd100)%'d10];
    ascii_out[1] = hex_table[(data / 'd10)%'d10];
    ascii_out[0] = hex_table[data % 'd10];
end

uart_tx u_uart_tx
(
	 .sys_clk		    (sys_clk)		
	,.sys_rst_n		    (sys_rst_n)		
	,.uart_tx_data	    (uart_tx_data)			
	,.uart_tx_en		(uart_tx_en)			
	,.uart_tx_done	    (uart_tx_done)
	,.uart_txd		    (uart_txd)			
);

endmodule