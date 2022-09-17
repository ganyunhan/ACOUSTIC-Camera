module cal_position(
    input [3:0] delay12,delay13,delay14,delay15,delay16,//d12,d13,d14
    input ena,//start caculate
    input fast_clk,//for sqrt 
    output reg [15:0] x_position,
    output reg [15:0] y_position,
    output wire [15:0] z_position,
    output wire cal_end//caculate end

);

localparam L=7'd100;   // distance between microphones (mm)
localparam vel=34;   //  velicity of sound (mm/0.1ms)

reg [15:0] R;       //distance between target and microphones
wire [15:0] dist12,dist13,dist14,dist15,dist16;        //d12,d13,d14,d15,d16
wire [31:0] z_position2;                //z*z

assign dist12=vel*delay12;              // d=v*t
assign dist13=vel*delay13;
assign dist14=vel*delay14;
assign dist15=vel*delay15;
assign dist16=vel*delay16;

always@(posedge ena) begin
    if(!cal_end)begin
        R<=(dist15*dist15+dist13*dist13-dist12*dist12-dist14*dist14-dist16*dist16)/(2*(dist12+dist14+dist16-dist15-dist13));   //R=(d13^2-d12^2-d14^2)/2(d12+d14-d13)
        x_position<=(2*R*dist13+dist13*dist13)/(4*1732/1000*L);                                //x=(2*R*d12+d12^2)/2L
        y_position<=((2*R+dist14+dist13)*(dist14-dist13))/(4*L);                                //y=(2*R*d14+d14^2)/2L
    end
    else begin
        x_position<=x_position;
        y_position<=y_position;
    R<=R;    
    end
end
assign z_position2=R*R-(x_position-1732*L/1000)*(x_position-1732*L/1000)-(y_position-L)*(y_position-L);//z^2=R^2-(x-L/2)^2-(y-L/2)^2
sqrt mysqrt(z_position2,fast_clk,z_position,cal_end);                                      //z=sqrt (z^2)
endmodule