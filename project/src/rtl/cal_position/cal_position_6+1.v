module cal_position(
    input signed [32:0]lag_diff1,lag_diff2,lag_diff3,lag_diff4,lag_diff5,lag_diff6,
    //input signed [15:0] delay12,delay13,delay14,//d12,d13,d14
    input ena,//start caculate
    input fast_clk,//for sqrt 
    output signed [31:0] x_position,
    output signed [31:0] y_position,//mm
    output [15:0] z_position,
    output wire cal_end//caculate end

);

localparam signed L = 16'd200;   // distance between microphones (0.1mm)
localparam vel = 340;   //  velicity of sound (0.1mm/0.1ms)
localparam frequency = 93750;

reg signed [31:0] R;
reg signed [31:0] x_position_temp,y_position_temp;       //distance between target and microphones
wire signed [31:0] dist1,dist2,dist3,dist4,dist5,dist6;        //d12,d13,d14
wire [31:0] z_position2;                //z*z

assign dist1 = vel * lag_diff1 * 10000  / frequency;              // d=v*t
assign dist2 = vel * lag_diff2 * 10000  / frequency; 
assign dist3 = vel * lag_diff3 * 10000  / frequency; 
assign dist4 = vel * lag_diff4 * 10000  / frequency; 
assign dist5 = vel * lag_diff5 * 10000  / frequency; 
assign dist6 = vel * lag_diff6 * 10000  / frequency; 

always@(posedge ena) begin
    if(!cal_end)begin
        R <= (dist6 * dist6 - dist4 * dist4 + dist3 * dist3 - dist1 * dist1) / (2 * (dist1 - dist3 + dist4 - dist6));   
        x_position_temp <= (2 * R * (dist3 - dist1 + dist4 - dist6) + dist3 * dist3 -dist1 * dist1 + dist4 * dist4 - dist6 * dist6) / (8 * 1732 * L / 1000);                                
        y_position_temp <= (2 * R * (dist5 - dist2 + dist6 - dist1 + dist4 - dist3) + dist5 * dist5 - dist2 * dist2 + dist6 * dist6 - dist1 * dist1 + dist4 * dist4 - dist3 * dist3) / (16 * L);                            
    end
    else begin
        x_position_temp <= x_position_temp;
        y_position_temp <= y_position_temp;
        R <= R;    
    end
end
assign x_position = x_position_temp / 10;
assign y_position = y_position_temp / 10;
assign z_position2 = (R / 10) * (R / 10) - x_position * x_position - y_position * y_position;
sqrt mysqrt(z_position2,fast_clk,z_position,cal_end);                                      //z=sqrt (z^2)
endmodule