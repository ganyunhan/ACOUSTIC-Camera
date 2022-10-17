//parameter N means the actual width of dividend
//using 29/5=5...4
module    divider_top#(
    parameter N=32,
    parameter M=3,
    parameter N_ACT = M+N-1
)
(
    input                     clk,
    input                     rstn,

    input                     data_rdy ,  //数据使能
    input signed [N-1:0]      dividend,   //被除数
    input signed [M-1:0]      divisor,    //除数

    output                    res_rdy ,
    output signed [N_ACT-M:0] merchant ,  //商位宽：N
    output signed [M-1:0]     remainder  //最终余数
); 

    wire [N_ACT-M-1:0]   dividend_t [N_ACT-M:0] ;
    wire [M-1:0]         divisor_t [N_ACT-M:0] ;
    wire [M-1:0]         remainder_t [N_ACT-M:0];
    wire [N_ACT-M:0]     rdy_t ;
    wire [N_ACT-M:0]     merchant_t [N_ACT-M:0] ;

     //判断是否为负数，两者同号取正，异号取负
    wire [N-1:0] dividend_abs;
    wire [N-1:0] divisor_abs;

    assign dividend_abs = (dividend[N-1] == 1) ? (~dividend + 1'b1) : dividend;
    assign divisor_abs = (divisor[N-1] == 1) ? (~divisor + 1'b1) : divisor;

    wire sign = (dividend[N-1] == 1) ^ (divisor[N-1] == 1);

    //初始化首个运算单元
    divider_cell      #(.N(N_ACT), .M(M))
       u_divider_step0
    ( .clk              (clk),
      .rstn             (rstn),
      .en               (data_rdy),
      //用被除数最高位 1bit 数据做第一次单步运算的被除数，高位补0
      .dividend         ({{(M){1'b0}}, dividend_abs[N-1]}),
      .divisor          (divisor_abs),                  
      .merchant_ci      ({(N_ACT-M+1){1'b0}}),   //商初始为0
      .dividend_ci      (dividend_abs[N_ACT-M-1:0]), //原始被除数
      //output
      .dividend_kp      (dividend_t[N_ACT-M]),   //原始被除数信息传递
      .divisor_kp       (divisor_t[N_ACT-M]),    //原始除数信息传递
      .rdy              (rdy_t[N_ACT-M]),
      .merchant         (merchant_t[N_ACT-M]),   //第一次商结果
      .remainder        (remainder_t[N_ACT-M])   //第一次余数
      );

    genvar               i ;
    generate
        for(i=1; i<=N_ACT-M; i=i+1) begin: sqrt_stepx
            divider_cell      #(.N(N_ACT), .M(M))
              u_divider_step
              (.clk              (clk),
               .rstn             (rstn),
               .en               (rdy_t[N_ACT-M-i+1]),
               .dividend         ({remainder_t[N_ACT-M-i+1], dividend_t[N_ACT-M-i+1][N_ACT-M-i]}),   //余数与原始被除数单bit数据拼接
               .divisor          (divisor_t[N_ACT-M-i+1]),
               .merchant_ci      (merchant_t[N_ACT-M-i+1]),
               .dividend_ci      (dividend_t[N_ACT-M-i+1]),
               //output
               .divisor_kp       (divisor_t[N_ACT-M-i]),
               .dividend_kp      (dividend_t[N_ACT-M-i]),
               .rdy              (rdy_t[N_ACT-M-i]),
               .merchant         (merchant_t[N_ACT-M-i]),
               .remainder        (remainder_t[N_ACT-M-i])
              );
        end // block: sqrt_stepx
    endgenerate

    assign res_rdy       = rdy_t[0];
    assign merchant      = sign ? (-merchant_t[0]) : merchant_t[0];  //最后一次商结果作为最终的商
    assign remainder     = remainder_t[0]; //最后一次余数作为最终的余数

endmodule