
`timescale 10ns/10ns

module test_coordinate;
reg clock;
reg signed [31:0] x;
reg signed [31:0] y;
reg signed [15:0] z;
wire signed [31:0] x_2d;
wire signed [31:0] y_2d;
initial begin
        $display("start a clock pulse");    // 打印开始标记
        $dumpfile("test_coordinate.vcd");              // 指定记录模拟波形的文件
        $dumpvars(0, test_coordinate);          // 指定记录的模块层级
        clock <= 1;
        x <= -42;
        y <= -52;
        z <= 131;
        #6000 $finish;                  // 6000个单位时间后结束模拟

    end
    always begin
        #40 clock = ~clock;
    end
    always begin
        #1000 x <= 0;y <= 0;
    end

    coordinate_3DTO2D trans(x,y,z,clock,x_2d,y_2d);
endmodule
module coordinate_3DTO2D(
    input signed [31:0] x,
    input signed [31:0] y,
    input signed [15:0] z,
    input clk,
    output[31:0] x_2d,
    output[31:0] y_2d
);
localparam height=4800; //height/156 or width/208
localparam weight=274;
wire [7:0] rate;
reg [9:0] IntrinsicMatrix [0:2][0:2];
//wire [15:0] temp_x;                     //store the coordinate without adding quadrant information
//wire [15:0] temp_y;
assign rate=height/208;
always @(posedge clk) begin
    IntrinsicMatrix[0][0]<=437;      //内参矩阵
    IntrinsicMatrix[0][1]<=0;
    IntrinsicMatrix[0][2]<=242;
    IntrinsicMatrix[1][0]<=0;
    IntrinsicMatrix[1][1]<=330;
    IntrinsicMatrix[1][2]<=145;
    IntrinsicMatrix[2][0]<=0;
    IntrinsicMatrix[2][1]<=0;
    IntrinsicMatrix[2][2]<=1;   
end    
assign x_2d=(IntrinsicMatrix[0][0]*x+IntrinsicMatrix[0][1]*y+IntrinsicMatrix[0][2]*z)/(z*10)*rate;
assign y_2d=(IntrinsicMatrix[1][0]*x+IntrinsicMatrix[1][1]*y+IntrinsicMatrix[1][2]*z)/(z*10)*rate;
//assign x_2d=(~quadrant[0]^quadrant[1])?temp_x:weight-temp_x;
//assign y_2d=quadrant[1]?temp_y:height-temp_y;
endmodule
