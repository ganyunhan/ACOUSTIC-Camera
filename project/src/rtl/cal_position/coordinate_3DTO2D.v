module coordinate_3DTO2D(
    input[15:0] x,
    input[15:0] y,
    input[15:0] z,
    input[1:0]quadrant,                                         //定义象限信息声源来自第quadrant-1象限
    input clk,
    output[15:0] x_2d,
    output[15:0] y_2d
);
integer i,j;

localparam height=2900; //height/156 or width/208
localparam weight=4000;
wire [7:0] rate;
reg [9:0] IntrinsicMatrix [0:2][0:2];
wire [15:0] temp_x;                     //store the coordinate without adding quadrant information
wire [15:0] temp_y;
assign rate=weight/208;
always @(posedge clk) begin
    IntrinsicMatrix[0][0]<=185;      //内参矩阵
    IntrinsicMatrix[0][1]<=0;
    IntrinsicMatrix[0][2]<=105;
    IntrinsicMatrix[1][0]<=0;
    IntrinsicMatrix[1][1]<=185;
    IntrinsicMatrix[1][2]<=77;
    IntrinsicMatrix[2][0]<=0;
    IntrinsicMatrix[2][1]<=0;
    IntrinsicMatrix[2][2]<=1;
   
end    
assign temp_x=(IntrinsicMatrix[0][0]*x+IntrinsicMatrix[0][1]*y+IntrinsicMatrix[0][2]*z)/z*rate;
assign temp_y=(IntrinsicMatrix[1][0]*x+IntrinsicMatrix[1][1]*y+IntrinsicMatrix[1][2]*z)/z*rate;
assign x_2d=(~quadrant[0]^quadrant[1])?temp_x:weight-temp_x;
assign y_2d=quadrant[1]?temp_y:height-temp_y;
endmodule
