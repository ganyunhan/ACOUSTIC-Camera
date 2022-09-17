module abs(
	 input [33- 1: 0]           datai,
	output [33- 1: 0]           datao
);

assign  datao = (datai[32] == 1) ? (~datai + 1'b1) : datai;

endmodule

