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