module cal_position(
     input                                  clk    //for sqrt
    ,input                                  clk_pix
    ,input                                  rst_n
    ,input                                  ena         //start caculate
    ,input  signed          [6 - 1: 0]      lag_diff_in_0
    ,input  signed          [6 - 1: 0]      lag_diff_in_1
    ,input  signed          [6 - 1: 0]      lag_diff_in_2
    ,input  signed          [6 - 1: 0]      lag_diff_in_3
    ,input  signed          [6 - 1: 0]      lag_diff_in_4
    ,input  signed          [6 - 1: 0]      lag_diff_in_5
    ,output reg signed      [26- 1: 0]      x_2d
    ,output reg signed      [26- 1: 0]      y_2d
    ,output reg                             done//caculate end
)/* synthesis syn_dspstyle = "logic" */;

localparam signed   L           = 16'd200;   // distance between microphones (0.1mm)
localparam          vel         = 340;       //  velicity of sound (0.1mm/0.1ms)
localparam          frequency   = 93750;
localparam          COEF1       = 8 * 1732 * L / 100;
localparam          COEF2       = 160 * L;

reg signed  [26- 1: 0]  R;

reg signed  [26- 1: 0]  y_position_temp;
reg signed  [26- 1: 0]  x_position_temp;

reg signed  [26- 1: 0]  distance[6 - 1: 0]/* synthesis syn_ramstyle = "block_ram" */;
reg         [10- 1: 0]  IntrinsicMatrix [0 : 2 - 1] [0: 3 - 1]/* synthesis syn_ramstyle = "block_ram" */;

wire        [16- 1: 0]  z_position;
reg signed  [26- 1: 0]  z_position2;           //z*z
wire                    cal_end;
reg         [26- 1: 0]  lag_diff [0 : 6 - 1]/* synthesis syn_ramstyle = "block_ram" */;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lag_diff[0] <= 26'b0;
        lag_diff[1] <= 26'b0;
        lag_diff[2] <= 26'b0;
        lag_diff[3] <= 26'b0;
        lag_diff[4] <= 26'b0;
        lag_diff[5] <= 26'b0;
    end else if(ena)begin
        lag_diff[0] <= {{20{lag_diff_in_0[5]}} , {lag_diff_in_0}};
        lag_diff[1] <= {{20{lag_diff_in_1[5]}} , {lag_diff_in_1}};
        lag_diff[2] <= {{20{lag_diff_in_2[5]}} , {lag_diff_in_2}};
        lag_diff[3] <= {{20{lag_diff_in_3[5]}} , {lag_diff_in_3}};
        lag_diff[4] <= {{20{lag_diff_in_4[5]}} , {lag_diff_in_4}};
        lag_diff[5] <= {{20{lag_diff_in_5[5]}} , {lag_diff_in_5}};
    end else begin
        lag_diff[0] <= lag_diff[0];
        lag_diff[1] <= lag_diff[1];
        lag_diff[2] <= lag_diff[2];
        lag_diff[3] <= lag_diff[3];
        lag_diff[4] <= lag_diff[4];
        lag_diff[5] <= lag_diff[5];
    end
end     

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        IntrinsicMatrix[0][0]       <= 10'b0;      //内参矩阵
        IntrinsicMatrix[0][1]       <= 10'b0;
        IntrinsicMatrix[0][2]       <= 10'b0;
        IntrinsicMatrix[1][0]       <= 10'b0;
        IntrinsicMatrix[1][1]       <= 10'b0;
        IntrinsicMatrix[1][2]       <= 10'b0;
    end else begin
        IntrinsicMatrix[0][0]       <= 437;      //内参矩阵
        IntrinsicMatrix[0][1]       <= 0;
        IntrinsicMatrix[0][2]       <= 242;
        IntrinsicMatrix[1][0]       <= 0;
        IntrinsicMatrix[1][1]       <= 330;
        IntrinsicMatrix[1][2]       <= 145;
    end  
end

localparam      IDLE            = 5'b00000;
localparam      CALC_DIST       = 5'b00001;
localparam      DIV_DIST        = 5'b00010;

localparam      CALC_R          = 5'b00011;
localparam      CALC_R_DIV      = 5'b00100;
localparam      CALC_POS_X      = 5'b00101;
localparam      CALC_DIV_X      = 5'b00110;
localparam      CALC_POS_Y      = 5'b00111;
localparam      CALC_DIV_Y      = 5'b01000;
localparam      CNT_ADD         = 5'b01001;
localparam      CALC_SQRT       = 5'b01010;
localparam      END_SQRT        = 5'b01011;
localparam      PAUSE_X         = 5'b01100; //pause for waiting R

localparam      PAUSE_Z         = 5'b01101; //pause for waiting Z
localparam      CALC_X_2D       = 5'b01110;
localparam      DIV_X_2D        = 5'b01111;
localparam      CALC_Y_2D       = 5'b10000;
localparam      DIV_Y_2D        = 5'b10001;
localparam      DONE            = 5'b10010;
localparam      PAUSE_LAG       = 5'b10011;

localparam      DIST_NUM        = 6;

reg   [5 - 1: 0]            cr_state;
reg   [5 - 1: 0]            nx_state;

reg   [3 - 1: 0]            dist_num;

reg                         ena_sqrt;
reg                         data_rdy;  
reg   signed [26- 1: 0]     dividend;
reg   signed [26- 1: 0]     divisor ; 
wire                        res_rdy ;
wire  signed [26- 1: 0]     merchant; 

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
            if (ena) begin
                nx_state = PAUSE_LAG;
            end else begin
                nx_state = IDLE;
            end
        end
        PAUSE_LAG: begin
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
                    nx_state = CNT_ADD;
                end
            end else begin
                nx_state = DIV_DIST;
            end
        end
        CNT_ADD: begin
            nx_state = CALC_DIST;
        end
        CALC_R: begin
            if (!cal_end) begin
                nx_state = CALC_R_DIV;
            end else begin  
                nx_state = CALC_R;
            end
        end
        CALC_R_DIV: begin
            if (res_rdy) begin
                nx_state = PAUSE_X;
            end else begin  
                nx_state = CALC_R_DIV;
            end
        end
        PAUSE_X: begin
            nx_state = CALC_POS_X;
        end
        CALC_POS_X: begin
            if (!cal_end) begin
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
            if (!cal_end) begin
                nx_state = CALC_DIV_Y;
            end else begin
                nx_state = CALC_POS_Y;
            end
        end
        CALC_DIV_Y: begin
            if (res_rdy) begin
                nx_state = CALC_SQRT;
            end else begin  
                nx_state = CALC_DIV_Y;
            end
        end
        CALC_SQRT: begin
            if (cal_end) begin
                nx_state = END_SQRT;
            end else begin
                nx_state = CALC_SQRT;
            end
        end
        END_SQRT: begin
            nx_state = PAUSE_Z;
        end
        PAUSE_Z: begin
            nx_state = CALC_X_2D;
        end
        CALC_X_2D: begin
            nx_state = DIV_X_2D;
        end
        DIV_X_2D: begin
            if (res_rdy) begin
                nx_state = CALC_Y_2D;
            end else begin  
                nx_state = DIV_X_2D;
            end
        end
        CALC_Y_2D: begin
            nx_state = DIV_Y_2D;
        end
        DIV_Y_2D: begin
            if (res_rdy) begin
                nx_state = DONE;
            end else begin  
                nx_state = DIV_Y_2D;
            end
        end
        DONE: begin
            if (done) begin
                nx_state = IDLE;
            end else begin 
                nx_state = DONE;
            end
        end
        default: begin
            nx_state = IDLE;
        end
    endcase
end

assign  cr_idle      = (cr_state == IDLE       ) ? 1'b1 : 1'b0;
assign  cr_calc_dist = (cr_state == CALC_DIST  ) ? 1'b1 : 1'b0;
assign  cr_div_dist  = (cr_state == DIV_DIST   ) ? 1'b1 : 1'b0;
assign  cr_calc_r    = (cr_state == CALC_R     ) ? 1'b1 : 1'b0;
assign  cr_div_r     = (cr_state == CALC_R_DIV ) ? 1'b1 : 1'b0;
assign  cr_calc_x    = (cr_state == CALC_POS_X ) ? 1'b1 : 1'b0;
assign  cr_div_x     = (cr_state == CALC_DIV_X ) ? 1'b1 : 1'b0;
assign  cr_calc_y    = (cr_state == CALC_POS_Y ) ? 1'b1 : 1'b0;
assign  cr_div_y     = (cr_state == CALC_DIV_Y ) ? 1'b1 : 1'b0;
assign  cr_cnt_add   = (cr_state == CNT_ADD    ) ? 1'b1 : 1'b0;
assign  cr_calc_sqrt = (cr_state == CALC_SQRT  ) ? 1'b1 : 1'b0;
assign  cr_end_sqrt  = (cr_state == END_SQRT   ) ? 1'b1 : 1'b0;
assign  cr_x_2d      = (cr_state == CALC_X_2D  ) ? 1'b1 : 1'b0;
assign  cr_div_x_2d  = (cr_state == DIV_X_2D   ) ? 1'b1 : 1'b0;
assign  cr_y_2d      = (cr_state == CALC_Y_2D  ) ? 1'b1 : 1'b0;
assign  cr_div_y_2d  = (cr_state == DIV_Y_2D   ) ? 1'b1 : 1'b0;
assign  cr_done      = (cr_state == DONE       ) ? 1'b1 : 1'b0;

assign  nx_calc_dist = (nx_state == CALC_DIST  ) ? 1'b1 : 1'b0;
assign  nx_div_dist  = (nx_state == DIV_DIST   ) ? 1'b1 : 1'b0;
assign  nx_calc_r    = (nx_state == CALC_R     ) ? 1'b1 : 1'b0;
assign  nx_div_r     = (nx_state == CALC_R_DIV ) ? 1'b1 : 1'b0;
assign  nx_calc_x    = (nx_state == CALC_POS_X ) ? 1'b1 : 1'b0;
assign  nx_div_x     = (nx_state == CALC_DIV_X ) ? 1'b1 : 1'b0;
assign  nx_calc_y    = (nx_state == CALC_POS_Y ) ? 1'b1 : 1'b0;
assign  nx_div_y     = (nx_state == CALC_DIV_Y ) ? 1'b1 : 1'b0;
assign  nx_cnt_add   = (nx_state == CNT_ADD    ) ? 1'b1 : 1'b0;
assign  nx_calc_sqrt = (nx_state == CALC_SQRT  ) ? 1'b1 : 1'b0;
assign  nx_end_sqrt  = (nx_state == END_SQRT   ) ? 1'b1 : 1'b0;
assign  nx_x_2d      = (nx_state == CALC_X_2D  ) ? 1'b1 : 1'b0;
assign  nx_div_x_2d  = (nx_state == DIV_X_2D   ) ? 1'b1 : 1'b0;
assign  nx_y_2d      = (nx_state == CALC_Y_2D  ) ? 1'b1 : 1'b0;
assign  nx_div_y_2d  = (nx_state == DIV_Y_2D   ) ? 1'b1 : 1'b0;
assign  nx_done      = (nx_state == DONE       ) ? 1'b1 : 1'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dist_num <= 3'b0;
    end else if (nx_cnt_add) begin
        dist_num <= dist_num + 1'b1;
    end else if (cr_calc_r)begin
        dist_num <= 3'b0;
    end else begin
        dist_num <= dist_num;
    end
end

assign dist_done = (dist_num > DIST_NUM - 1'b1) ? 1'b1 : 1'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        distance[0] <= 26'b0;
        distance[1] <= 26'b0;
        distance[2] <= 26'b0;
        distance[3] <= 26'b0;
        distance[4] <= 26'b0;
        distance[5] <= 26'b0;
    end else if (cr_div_dist && res_rdy) begin
        distance[dist_num] <= merchant;
    end else begin
        distance[dist_num] <= distance[dist_num];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ena_sqrt <= 1'b0;
    end else if (nx_calc_sqrt) begin
        ena_sqrt <= 1'b1;
    end else if (nx_end_sqrt) begin
        ena_sqrt <= 1'b0;
    end else begin
        ena_sqrt <= ena_sqrt;
    end
end

always @(posedge clk_pix or negedge rst_n) begin
    if (!rst_n) begin
        done <= 1'b0;
    end else if (cr_done) begin
            done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        R <= 26'b0;
    end else if (cr_div_r) begin
        R = (merchant[25] == 1) ? (~merchant + 1'b1) : merchant;
    end else begin
        R <= R;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        x_position_temp <= 26'b0;
    end else if (cr_div_x) begin
        x_position_temp <= merchant;
    end else begin
        x_position_temp <= x_position_temp;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        y_position_temp <= 26'b0;
    end else if (cr_div_y) begin
        y_position_temp <= merchant;
    end else begin
        y_position_temp <= y_position_temp;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        x_2d <= 26'b0;
    end else if (cr_div_x_2d) begin
        x_2d <= 480 - merchant;
    end else begin
        x_2d <= x_2d;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        y_2d <= 26'b0;
    end else if (cr_div_y_2d) begin
        y_2d <= merchant;
    end else begin
        y_2d <= y_2d;
    end
end

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dividend <= 26'b0;
        divisor <=26'b0;
        data_rdy <= 1'b0;
    end else if (nx_calc_dist) begin
        dividend <= vel * lag_diff[dist_num] * 10000;
        divisor <= frequency;
        data_rdy <= 1'b1;
    end else if (cr_calc_dist) begin
        data_rdy <= 1'b0;
    end else if (nx_calc_r) begin
        dividend <=  distance[5] *distance[5] - distance[3] *distance[3] 
                   + distance[2] *distance[2] - distance[0] *distance[0];
        divisor <= 2 * (distance[0] - distance[2] + distance[3] - distance[5]);
        data_rdy <= 1'b1;
    end else if (cr_calc_r) begin
        data_rdy <= 1'b0;
    end else if (nx_calc_x) begin
        dividend <= 2 * R * (distance[2] - distance[0] + distance[3] - distance[5]) 
                           + distance[2] * distance[2] - distance[0] * distance[0] 
                           + distance[3] * distance[3] - distance[5] * distance[5];
        divisor <= COEF1;
        data_rdy <= 1'b1;
    end else if (cr_calc_x) begin
        data_rdy <= 1'b0;
    end else if (nx_calc_y) begin
        dividend <= 2 * R * (distance[4] - distance[1] + distance[5] - distance[0] 
                           + distance[3] - distance[2]) + distance[4] * distance[4] 
                           - distance[1] * distance[1] + distance[5] * distance[5] 
                           - distance[0] * distance[0] + distance[3] * distance[3] 
                           - distance[2] * distance[2];
        divisor <= COEF2;
        data_rdy <= 1'b1;
    end else if (cr_calc_y) begin
        data_rdy <= 1'b0;
    end else if (nx_x_2d) begin
        dividend <=   IntrinsicMatrix[0][0] * x_position_temp
                    + IntrinsicMatrix[0][1] * y_position_temp
                    + IntrinsicMatrix[0][2] * z_position ;
        divisor <= z_position;
        data_rdy <= 1'b1;
    end else if (cr_x_2d) begin
        data_rdy <= 1'b0;
    end else if (nx_y_2d) begin
        dividend <= IntrinsicMatrix[1][0] * x_position_temp 
                  + IntrinsicMatrix[1][1] * y_position_temp
                  + IntrinsicMatrix[1][2] * z_position ;
        divisor <= z_position;
        data_rdy <= 1'b1;
    end else if (cr_y_2d) begin
        data_rdy <= 1'b0;
    end else begin
        dividend <= dividend;
        divisor <= divisor;
        data_rdy <= data_rdy;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        z_position2 <= 26'b0;
    end else begin
        z_position2 <= (R / 10) * (R / 10) - x_position_temp * x_position_temp - y_position_temp * y_position_temp;
    end
end

divider_top#(           
     .N                 (26           )
    ,.M                 (26           )
)
U_DIVIDER(
     .clk               (clk          )
    ,.rstn              (rst_n        )
    ,.data_rdy          (data_rdy     )
    ,.dividend          (dividend     )
    ,.divisor           (divisor      )
    ,.res_rdy           (res_rdy      )
    ,.merchant          (merchant     )
    ,.remainder         (             )
);

sqrt#(
    .TIMES              (64           )
)
mysqrt(
     .clk               (clk           ) //input               
    ,.rst_n             (rst_n         ) //input
    ,.ena               (ena_sqrt      )             
    ,.in_data           (z_position2   ) //input wire [31:0]   
    ,.out_data          (z_position    ) //output reg [15:0]   
    ,.sqrt_end          (cal_end       ) //output reg          
);
endmodule