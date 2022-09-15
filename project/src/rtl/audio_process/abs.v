module abs(
	 input [32- 1: 0]           datai,
	output [32- 1: 0]           datao
);

assign  datao = (datai[31] == 1) ? (~datai + 1'b1) : datai;

endmodule

