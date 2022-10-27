module thd_show(
     input                          clk_pix
    ,input                          rst_n
    ,input                          ena
    ,input  signed    [26- 1: 0]    pix_x_in
    ,input  signed    [26- 1: 0]    pix_y_in
    ,output                         syn_off0_hs
    ,output                         syn_off0_vs
    ,output                         out_de
    ,output                         syn_off0_re
    ,output reg [16- 1: 0]          thd_rgb_data
);

localparam THD_SIZE  = 49;
localparam RADIUS    = (THD_SIZE - 1) >> 1 ;

wire        [12- 1: 0] pix_addr;
wire        [16- 1: 0] pix_data;
wire signed [16- 1: 0] v_cnt;
wire signed [16- 1: 0] h_cnt;
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
                pix_x <= 0;
            end else if (pix_x_in > 480) begin
                pix_x <= 480;
            end else begin
                pix_x <= pix_x_in[16- 1: 0];
            end
            if (pix_y_in < 0) begin
                pix_y <= 0;
            end else if (pix_y_in > 272) begin
                pix_y <= 272;
            end else begin
                pix_y <= pix_y_in[16- 1: 0];
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
        thd_rgb_data <= 16'b0;
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

syn_gen syn_gen_inst
(                                   
    .I_pxl_clk   (clk_pix         ),//9Mhz    //32Mhz    //40MHz      //65MHz      //74.25MHz    //148.5
    .I_rst_n     (rst_n           ),//480x272 //800x480  //800x600    //1024x768   //1280x720    //1920x1080    
    .I_h_total   (16'd480         ),//16'd525 //16'd1056 // 16'd1056  // 16'd1344  // 16'd1650   // 16'd2200  
    .I_h_sync    (16'd1           ),//16'd41  //16'd128  // 16'd128   // 16'd136   // 16'd40     // 16'd44   
    .I_h_bporch  (16'd1           ),//16'd2   //16'd88   // 16'd88    // 16'd160   // 16'd220    // 16'd148   
    .I_h_res     (16'd480         ),//16'd480 //16'd800  // 16'd800   // 16'd1024  // 16'd1280   // 16'd1920  
    .I_v_total   (16'd272         ),//16'd284 //16'd505  // 16'd628   // 16'd806   // 16'd750    // 16'd1125   
    .I_v_sync    (16'd1           ),//16'd10  //16'd3    // 16'd4     // 16'd6     // 16'd5      // 16'd5      
    .I_v_bporch  (16'd1           ),//16'd2   //16'd21   // 16'd23    // 16'd29    // 16'd20     // 16'd36      
    .I_v_res     (16'd272         ),//16'd272 //16'd480  // 16'd600   // 16'd768   // 16'd720    // 16'd1080   
    .I_rd_hres   (16'd480         ),
    .I_rd_vres   (16'd272         ),
    .I_hs_pol    (1'b1            ),//HS polarity
    .I_vs_pol    (1'b1            ),//VS polarity
    .O_rden      (syn_off0_re     ),
    .O_de        (out_de          ),   
    .O_hs        (syn_off0_hs     ),
    .O_vs        (syn_off0_vs     ),
    .H_cnt       (h_cnt           ),
    .V_cnt       (v_cnt           ) 
);

endmodule



