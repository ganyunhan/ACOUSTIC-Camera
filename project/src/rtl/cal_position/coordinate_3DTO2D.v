module coordinate_3DTO2D(
    input[15:0] x,
    input[15:0] y,
    input[15:0] z,
    input clk,
    output[15:0] x_2d,
    output[15:0] y_2d
);
integer i,j;

localparam rate=7'd20; //height/156 or width/208
reg [9:0] IntrinsicMatrix [0:2][0:2];
always @(posedge clk) begin                     //内参矩阵
    IntrinsicMatrix[0][0]<=185;
    IntrinsicMatrix[0][1]<=0;
    IntrinsicMatrix[0][2]<=105;
    IntrinsicMatrix[1][0]<=0;
    IntrinsicMatrix[1][1]<=185;
    IntrinsicMatrix[1][2]<=77;
    IntrinsicMatrix[2][0]<=0;
    IntrinsicMatrix[2][1]<=0;
    IntrinsicMatrix[2][2]<=1;
end    
assign x_2d=(IntrinsicMatrix[0][0]*x+IntrinsicMatrix[0][1]*y+IntrinsicMatrix[0][2]*z)/z*rate;
assign y_2d=(IntrinsicMatrix[1][0]*x+IntrinsicMatrix[1][1]*y+IntrinsicMatrix[1][2]*z)/z*rate;

endmodule