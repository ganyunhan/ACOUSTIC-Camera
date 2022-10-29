module thd_show(
     input                          clk_pix
    ,input                          rst_n
    ,input                          ena
    ,input  signed    [26- 1: 0]    pix_x_in
    ,input  signed    [26- 1: 0]    pix_y_in
    ,input  signed    [16- 1: 0]    ov_data
    ,output reg       [16- 1: 0]    thd_rgb_data
);

localparam THD_SIZE  = 49;
localparam RADIUS    = (THD_SIZE - 1) >> 1 ;

wire        [12- 1: 0] pix_addr;
wire        [16- 1: 0] pix_data;
wire signed [12- 1: 0] v_cnt;
wire signed [12- 1: 0] h_cnt;
reg  signed [16- 1: 0] pix_x;
reg  signed [16- 1: 0] pix_y;

always @(posedge clk_pix or negedge rst_n) begin
    if (!rst_n) begin
        pix_x <= 16'b0;
        pix_y <= 16'b0;
    end else if (ena) begin
        if ((pix_x_in == 238) && (pix_y_in == 145)) begin
            pix_x <= pix_x;
            pix_y <= pix_y;
        end else begin
            if (pix_x_in < 0) begin
                pix_x <= 15;
            end else if (pix_x_in > 480) begin
                pix_x <= 495;
            end else begin
                pix_x <= pix_x_in[16- 1: 0] + 15;
            end
            if (pix_y_in < 0) begin
                pix_y <= 10;
            end else if (pix_y_in > 272) begin
                pix_y <= 282;
            end else begin
                pix_y <= pix_y_in[16- 1: 0] + 10;
            end
        end
    end else begin
        pix_x <= pix_x;
        pix_y <= pix_y;
    end
end

always@(posedge clk_pix or negedge rst_n)
begin
    if(!rst_n)
        thd_rgb_data <= 16'b0;
    else if(h_cnt < pix_x - RADIUS || h_cnt > pix_x + RADIUS || v_cnt < pix_y - RADIUS || v_cnt > pix_y + RADIUS)
        thd_rgb_data <= ov_data;
    else
        thd_rgb_data <= pix_data;
end

assign pix_addr = (v_cnt - pix_y + RADIUS) * THD_SIZE + (h_cnt - pix_x + RADIUS);

Gowin_pROM hotspot_map(
     .clk        (clk_pix        )
    ,.reset      (!rst_n         )
    ,.oce        (1'b1           )
    ,.ce         (1'b1           )
    ,.ad         (pix_addr       )
    ,.dout       (pix_data       )
);

color_bar color_bar_pix(
     .clk        (clk_pix        )
    ,.rst        (!rst_n         )
    ,.h_cnt      (h_cnt          )
    ,.v_cnt      (v_cnt          ) 
);
endmodule



