module cal_position(
    input [3:0] delay12,delay13,delay14,//d12,d13,d14
    input ena,//start caculate
    input fast_clk,//for sqrt 
    output reg [15:0] x_position,
    output reg [15:0] y_position,
    output wire [15:0] z_position,
    output wire cal_end

);

localparam L=7'd100;   // mm
localparam vel=34;   // mm/0.1ms

reg [15:0] R;
wire [15:0] dist12,dist13,dist14;
wire [31:0] z_position2;

assign dist12=vel*delay12;
assign dist13=vel*delay13;
assign dist14=vel*delay14;

always@(posedge ena) begin
    if(!cal_end)begin
    R<=(dist13*dist13-dist12*dist12-dist14*dist14)/(2*(dist12+dist14-dist13));
    x_position<=(2*R*dist12+dist12*dist12)/(2*L);
    y_position<=(2*R*dist14+dist14*dist14)/(2*L);
    end
    else begin
    x_position<=x_position;
    y_position<=y_position;
    R<=R;    
    end
end
assign z_position2=R*R-(x_position-L/2)*(x_position-L/2)+(y_position-L/2)*(y_position-L/2);
sqrt mysqrt(z_position2,fast_clk,z_position,cal_end);
endmodule

module sqrt(
    input wire [31:0] in_data,
    input clk,
    output reg [15:0] out_data,
    output reg sqrt_end=0
);
localparam times=31;
reg [7:0]cnt;
reg [15:0] h_tempdata,l_tempdata,tempdata;
reg [3:0] state=0;
always @(posedge clk)begin
    case(state)
        0:begin 
            state<=1;
            cnt<=0;
            h_tempdata<=16'd65535;
            l_tempdata<=16'b0;
            tempdata<=1516;
            sqrt_end<=0;
        end
        1:begin
            if(cnt<=times)begin
                cnt+=1;
                if(tempdata*tempdata>in_data)begin
                    h_tempdata<=tempdata;
                end
                else begin
                    l_tempdata<=tempdata;
                end
                tempdata<=(h_tempdata+l_tempdata)/2; 
            end
            else begin
                state<=2;
                out_data<=tempdata;
                sqrt_end<=1;
            end
        end
        2:begin
            state<=0;
        end
        default:state<=0;
    endcase
end
endmodule