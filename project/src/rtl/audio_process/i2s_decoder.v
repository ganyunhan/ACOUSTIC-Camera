`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 26.08.2022
// Designer : Hank.Gan
// Design Name: I2S_Decoder
// Description: I2S Audio Signal Decoder
// Dependencies: None
// Revision 1.0
// Additional Comments: clk_mic = 64*fs = 64*f(WS)
//////////////////////////////////////////////////////////////////////////////////
module i2s_decoder#(
	parameter		DATAWIDTH = 24
)
(
	 input 							        clk_mic
	,input 							        rst_mic_n
	,input 							        WS
	,input 							        DATA
	
	,output reg	signed [DATAWIDTH - 1: 0] 	L_DATA
	,output reg	signed [DATAWIDTH - 1: 0] 	R_DATA
	,output							        L_Sel
	,output							        R_Sel
	,output reg						        recv_over
);

localparam IDLE 		= 2'b00;
localparam GET_RIGHT 	= 2'b01;
localparam GET_LEFT 	= 2'b11;

reg [4:0] cnt;
reg [1:0] state,next_state;

reg WS_reg;
wire WS_en;
always @(negedge clk_mic or negedge rst_mic_n) begin
	if(!rst_mic_n) WS_reg <= 1'b0;
	else WS_reg <= WS;
end
assign WS_en = (~WS_reg)&(WS);  // WS posedge means sending right phase

always @(negedge clk_mic or negedge rst_mic_n) begin
	if(!rst_mic_n) begin
		state <= IDLE;
	end
	else begin
		state <= next_state;
	end
end


always @(*) begin
	case(state)
		IDLE:
			begin
				if(WS_en) begin
					next_state = GET_RIGHT;
				end
				else begin
					next_state = IDLE;
				end
			end
		GET_RIGHT:
			begin
				if(cnt == 'd32) begin
					next_state = GET_LEFT;
				end
				else begin
					next_state = GET_RIGHT;
				end
			end
		GET_LEFT:
			begin
				if(cnt == 'd32) begin
					next_state = IDLE;
				end
				else begin
					next_state = GET_LEFT;
				end
			end
		default: next_state = IDLE;
	endcase
end

always @(negedge clk_mic or negedge rst_mic_n) begin
	if(!rst_mic_n) begin
		cnt <= 'd0;
	end
	else if(WS_en || (state!=IDLE)) begin  
		if(cnt != 'd32) begin
			cnt <= cnt + 1'b1;
		end
		else begin
			cnt <= 'd0;
		end
	end
	else cnt <= 'd0;
end

// Clocks 2 through 25 transmit data
always @(posedge clk_mic or negedge rst_mic_n) begin
	if(!rst_mic_n) begin
		L_DATA <= 'd0;
	end
	else if(~WS && (cnt > 'd0) && (cnt < 'd25)) begin
		L_DATA <= {L_DATA[DATAWIDTH - 2: 0],DATA};  // shift
	end
	else begin
		L_DATA <= L_DATA;
	end
end

always @(posedge clk_mic or negedge rst_mic_n) begin
	if(!rst_mic_n) begin
		R_DATA <= 'd0;
	end
	else if(WS && (cnt > 'd0) && (cnt < 'd25)) begin
		R_DATA <= {R_DATA[DATAWIDTH - 2: 0],DATA};
	end
	else begin
		R_DATA <= R_DATA;
	end
end

assign cr_get_left	=	(state == GET_LEFT) ? 1'b1 : 1'b0;

//only get the left channel
always @(posedge clk_mic or negedge rst_mic_n) begin
	if (!rst_mic_n) begin
		recv_over <= 1'b0;
	end else if (cr_get_left && cnt == 'd26)begin
		recv_over <= 1'b1;
	end else begin
		recv_over <= 1'b0;
	end
end

assign L_Sel = 1'b0;
assign R_Sel = 1'b1;

endmodule

