module coordinate_3DTO2D(
     input                      clk
    ,input                      rst_n
    ,input signed [32- 1: 0]    x
    ,input signed [32- 1: 0]    y
    ,input signed [16- 1: 0]    z
    ,output       [32- 1: 0]    x_2d
    ,output       [32- 1: 0]    y_2d
);

localparam height = 4800; //height/156 or width/208
localparam weight = 274;
localparam rate = height / 'd208;

reg  [10- 1: 0] IntrinsicMatrix [ 0:3 - 1] [ 0:3 - 1];

initial begin
    IntrinsicMatrix[0][0] <= 437;      //内参矩阵
    IntrinsicMatrix[0][1] <= 0;
    IntrinsicMatrix[0][2] <= 242;
    IntrinsicMatrix[1][0] <= 0;
    IntrinsicMatrix[1][1] <= 330;
    IntrinsicMatrix[1][2] <= 145;
end

assign x_2d = (   IntrinsicMatrix[0][0] * x 
                + IntrinsicMatrix[0][1] * y
                + IntrinsicMatrix[0][2] * z
              ) * 10 / z * rate;

assign y_2d = (   IntrinsicMatrix[1][0] * x 
                + IntrinsicMatrix[1][1] * y
                + IntrinsicMatrix[1][2] * z
              ) * 10 / z * rate;

endmodule
