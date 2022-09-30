
`timescale 10ns/10ns

module test_coordinate;
reg clock;
reg  [15:0] x;
reg  [15:0] y;
reg  [15:0] z;
wire  [15:0] x_2d;
wire  [15:0] y_2d;
reg [1:0] quadrant;
initial begin
        $display("start a clock pulse");    // 打印开始标记
        $dumpfile("test_coordinate.vcd");              // 指定记录模拟波形的文件
        $dumpvars(0, test_coordinate);          // 指定记录的模块层级
        clock <= 1;
        x<=40;
        y<=20;
        z<=160;
        quadrant<=2'b0;                         // 初始clock信号为1
        #6000 $finish;                  // 6000个单位时间后结束模拟

    end
    always begin
        #40 clock =~clock;
    end
    always begin
        #1000 x<=0;y<=0;
    end
    always begin
        #10 quadrant<=quadrant+1;
    end
    coordinate_3DTO2D trans(x,y,z,quadrant,clock,x_2d,y_2d);
endmodule
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
assign temp_x=(IntrinsicMatrix[0][0]*x+IntrinsicMatrix[0][1]*y+IntrinsicMatrix[0][2]*z)/z*rate;
assign temp_y=(IntrinsicMatrix[1][0]*x+IntrinsicMatrix[1][1]*y+IntrinsicMatrix[1][2]*z)/z*rate;
assign x_2d=(~quadrant[0]^quadrant[1])?temp_x:weight-temp_x;
assign y_2d=quadrant[1]?temp_y:height-temp_y;
endmodule
