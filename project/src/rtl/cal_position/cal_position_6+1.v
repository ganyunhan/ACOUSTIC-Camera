module cal_position(
     input                          clk    //for sqrt
    ,input                          rst_n
    ,input                          ena         //start caculate
    ,input  signed [32- 1: 0]       lag_diff [0 : 6 - 1]
    ,output signed [32- 1: 0]       x_position
    ,output signed [32- 1: 0]       y_position//mm
    ,output [16- 1: 0]              z_position
    ,output wire                    cal_end//caculate end

);

localparam signed   L           = 16'd200;   // distance between microphones (0.1mm)
localparam          vel         = 340;       //  velicity of sound (0.1mm/0.1ms)
localparam          frequency   = 93750;
localparam          COEF1       = 8 * 1732 * L / 1000;
localparam          COEF2       = 16 * L;

reg signed  [32- 1: 0]  R;

reg signed  [32- 1: 0]  x_position_temp;       //distance between target and microphones
reg signed  [32- 1: 0]  y_position_temp;       //distance between target and microphones

reg signed  [32- 1: 0]  dist [0 : 6 - 1];      //d12,d13,d14
wire        [32- 1: 0]  z_position2;           //z*z

localparam      IDLE            = 3'b0000;
localparam      CALC_DIST       = 3'b0001;
localparam      DIV_DIST        = 3'b0010;
localparam      CALC_R          = 3'b0011;
localparam      CALC_R_DIV      = 3'b0100;
localparam      CALC_POS_X      = 3'b0101;
localparam      CALC_DIV_X      = 3'b0110;
localparam      CALC_POS_Y      = 3'b0111;
localparam      CALC_DIV_Y      = 3'b1000;

localparam      DIST_NUM        = 6;

reg   [4 - 1: 0]            cr_state;
reg   [4 - 1: 0]            nx_state;

reg   [3 - 1: 0]            dist_num;

reg                         data_rdy;  
reg   signed [32- 1: 0]     dividend;
reg   signed [32- 1: 0]     divisor ; 
wire                        res_rdy ;
wire  signed [32- 1: 0]     merchant; 

wire                        dist_done;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cr_state <= IDLE;
    end else begin
        cr_state <= nx_state;
    end
end

always @(*) begin
	case (cr_state)
		IDLE: begin 
            nx_state = CALC_DIST;
        end
        CALC_DIST: begin
            nx_state = DIV_DIST;
        end
        DIV_DIST: begin
            if (res_rdy) begin
                if (dist_done) begin
                    nx_state = CALC_R;
                end else begin
                    nx_state = CALC_DIST;
                end
                nx_state = DIV_DIST;
            end else begin
                nx_state = DIV_DIST;
            end
        end
        CALC_R: begin
            if (ena & !cal_end) begin
                nx_state = CALC_R_DIV;
            end else begin  
                nx_state = CALC_R;
            end
        end
        CALC_R_DIV: begin
            if (res_rdy) begin
                nx_state = CALC_POS_X;
            end else begin  
                nx_state = CALC_R_DIV;
            end
        end
        CALC_POS_X: begin
            if (ena & !cal_end) begin
                nx_state = CALC_DIV_X;
            end else begin
                nx_state = CALC_POS_X;
            end
        end
        CALC_DIV_X: begin
            if (res_rdy) begin
                nx_state = CALC_POS_Y;
            end else begin  
                nx_state = CALC_DIV_X;
            end
        end
        CALC_POS_Y: begin
            if (ena & !cal_end) begin
                nx_state = IDLE;
            end else begin
                nx_state = CALC_POS_Y;
            end
        end
        CALC_DIV_Y: begin
            if (res_rdy) begin
                nx_state = IDLE;
            end else begin  
                nx_state = CALC_DIV_Y;
            end
        end
        default: begin
            nx_state = IDLE;
        end
    endcase
end

assign  cr_calc_dist = (cr_state == CALC_DIST  ) ? 1'b1 : 1'b0;
assign  cr_div_dist  = (cr_state == DIV_DIST   ) ? 1'b1 : 1'b0;
assign  cr_calc_r    = (cr_state == CALC_R     ) ? 1'b1 : 1'b0;
assign  cr_div_r     = (cr_state == CALC_R_DIV ) ? 1'b1 : 1'b0;
assign  cr_calc_x    = (cr_state == CALC_POS_X ) ? 1'b1 : 1'b0;
assign  cr_div_x     = (cr_state == CALC_DIV_X ) ? 1'b1 : 1'b0;
assign  cr_calc_y    = (cr_state == CALC_POS_Y ) ? 1'b1 : 1'b0;
assign  cr_div_y     = (cr_state == CALC_DIV_Y ) ? 1'b1 : 1'b0;

assign  nx_calc_dist = (nx_state == CALC_DIST  ) ? 1'b1 : 1'b0;
assign  nx_div_dist  = (nx_state == DIV_DIST   ) ? 1'b1 : 1'b0;
assign  nx_calc_r    = (nx_state == CALC_R     ) ? 1'b1 : 1'b0;
assign  nx_div_r     = (nx_state == CALC_R_DIV ) ? 1'b1 : 1'b0;
assign  nx_calc_x    = (nx_state == CALC_POS_X ) ? 1'b1 : 1'b0;
assign  nx_div_x     = (nx_state == CALC_DIV_X ) ? 1'b1 : 1'b0;
assign  nx_calc_y    = (nx_state == CALC_POS_Y ) ? 1'b1 : 1'b0;
assign  nx_div_y     = (nx_state == CALC_DIV_Y ) ? 1'b1 : 1'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dist_num <= 3'b0;
    end else if (cr_div_dist) begin
        dist_num <= dist_num + 1'b1;
    end else if (cr_calc_r)begin
        dist_num <= 3'b0;
    end else begin
        dist_num <= dist_num;
    end
end

assign dist_done = (dist_num > DIST_NUM) ? 1'b1 : 1'b0;

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dist[0] <= 32'b0; dist[1] <= 32'b0; dist[2] <= 32'b0; dist[3] <= 32'b0; dist[4] <= 32'b0; dist[5] <= 32'b0;
        R <= 32'b0;
        dividend <= 32'b0;
        divisor <=32'b0;
        data_rdy <= 1'b0;
    end else if (nx_calc_dist) begin
        dividend <= lag_diff[dist_num] * 10000;
        divisor <= frequency;
        data_rdy <= 1'b1;
    end else if (cr_calc_dist) begin
        data_rdy <= 1'b0;
    end else if (nx_div_dist) begin
        dist[dist_num] <= cr_calc_dist;
    end else if (nx_calc_r) begin
        dividend <= dist[5] *dist[5] - dist[3] *dist[3] + dist[2] *dist[2] - dist[0] *dist[0];
        divisor <= 2 * (dist[0] - dist[4] + dist[3] - dist[5]);
        data_rdy <= 1'b1;
    end else if (cr_calc_r) begin
        data_rdy <= 1'b0;
    end else if (cr_div_r) begin
        R <= merchant;
    end else if (nx_calc_x) begin
        dividend <= 2 * R * (dist[4] - dist[0] + dist[3] - dist[5]) + dist[4] * dist[4] -dist[0] * dist[0] + dist[3] * dist[3] - dist[5] * dist[5];
        divisor <= COEF1;
        data_rdy <= 1'b1;
    end else if (cr_calc_r) begin
        data_rdy <= 1'b0;
    end else if (cr_div_r) begin
        x_position_temp <= merchant;
    end else if (nx_calc_y) begin
        dividend <= 2 * R * (dist[4] - dist[1] + dist[5] - dist[0] + dist[3] - dist[4]) + dist[4] * dist[4] - dist[1] * dist[1] + dist[5] * dist[5] - dist[0] * dist[0] + dist[3] * dist[3] - dist[4] * dist[4];
        divisor <= 2 * COEF2;
        data_rdy <= 1'b1;
    end else if (cr_calc_r) begin
        data_rdy <= 1'b0;
    end else if (cr_div_r) begin
        y_position_temp <= merchant;
    end else begin
        R <= R;
        dividend <= dividend;
        divisor <= divisor;
        data_rdy <= data_rdy;
        x_position_temp <= x_position_temp;
        y_position_temp <= y_position_temp;
    end
end

assign x_position = x_position_temp / 10;
assign y_position = y_position_temp / 10;
assign z_position2 = (R / 10) * (R / 10) - x_position * x_position - y_position * y_position;

divider_top#(           
     .N                 (32)
    ,.M                 (32)
)
U_DIVIDER
    (
    .clk              (clk          ),
    .rstn             (rst_n         ),
    .data_rdy         (data_rdy     ),
    .dividend         (dividend     ),
    .divisor          (divisor      ),
    .res_rdy          (res_rdy      ),
    .merchant         (merchant     ),
    .remainder        (             )
);

sqrt#(
    .TIMES               (31            )
)
mysqrt(
     .clk                (clk           ) //input               
    ,.rst_n              (rst_n         ) //input               
    ,.in_data            (z_position2   ) //input wire [31:0]   
    ,.out_data           (z_position    ) //output reg [15:0]   
    ,.sqrt_end           (cal_end       ) //output reg          
);
endmodule
