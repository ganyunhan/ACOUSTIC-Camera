module sqrt(       //使用二分法计算开根号
    input wire [31:0] in_data,
    input clk,
    output reg [15:0] out_data,
    output reg sqrt_end=0
);
localparam times=31;    //max iteration times
reg [7:0]cnt;           //iteration counter
reg [15:0] h_tempdata,l_tempdata,tempdata;   //data used in the iteration
reg [3:0] state=0;
always @(posedge clk)begin
    case(state)
        0:begin 
            state<=1;
            cnt<=0;
            h_tempdata<=16'd65535;          //begining high data    
            l_tempdata<=16'b0;              //begining low data   
            tempdata<=1516;                 //begining mid data random
            sqrt_end<=0;                    //the flag of caculation
        end
        1:begin
            if(cnt<=times)begin                     //Less than the max iteration times
                cnt+=1;
                if(tempdata*tempdata>in_data)begin  //tempdata>target     =>    tempdata>target>l_tempdata
                    h_tempdata<=tempdata;           
                end
                else begin
                    l_tempdata<=tempdata;           //tempdata<target     =>tempdata<target<h_tempdata
                end
                tempdata<=(h_tempdata+l_tempdata)/2; //二分，取l_tempdata和h_tempdata中点
            end
            else begin
                state<=2;                            //arrive the max iteration times
                out_data<=tempdata;
                sqrt_end<=1;                         //caculation ends
            end
        end
        2:begin
            state<=0;                               //reset
        end
        default:state<=0;
    endcase
end
endmodule