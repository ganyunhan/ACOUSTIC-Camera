//使用二分法计算开根号
module sqrt#(
    parameter TIMES = 31
)
(
     input                      clk
    ,input                      rst_n
    ,input                      ena
    ,input wire [26- 1: 0]      in_data
    ,output reg [16- 1: 0]      out_data
    ,output reg                 sqrt_end
)/* synthesis syn_preserve = 1 */ /* synthesis syn_keep=1 */;

reg [8 - 1: 0] cnt;          //iteration counter
reg [16- 1: 0] h_tempdata;   //data used in the iteration
reg [16- 1: 0] l_tempdata;   //data used in the iteration
reg [16- 1: 0] tempdata;     //data used in the iteration
reg [4 - 1: 0] state;

always @(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        sqrt_end <= 1'b0;
        state <= 4'b0;
        cnt <= 8'b0;
        out_data <= 16'b0;
    end else if (ena) begin
        case(state)
            0: begin 
                state <= 4'b1;
                cnt <= 8'b0;
                h_tempdata <= 16'd65535;          //begining high data    
                l_tempdata <= 16'b0;              //begining low data   
                tempdata <= 1516;                 //begining mid data random
                sqrt_end <= 0;                    //the flag of caculation
            end
            1: begin
                if(cnt <= TIMES)begin                     //Less than the max iteration times
                    cnt <= cnt + 1'b1;
                    if(tempdata*tempdata > in_data)begin  //tempdata>target     =>    tempdata>target>l_tempdata
                        h_tempdata <= tempdata;           
                    end
                    else begin
                        l_tempdata <= tempdata;           //tempdata<target     =>    tempdata<target<h_tempdata
                    end
                    tempdata <= (h_tempdata + l_tempdata) / 'd2; //二分，取l_tempdata和h_tempdata中点
                end
                else begin
                    state <= 2;                            //arrive the max iteration times
                    out_data <= tempdata;
                    sqrt_end <= 1;                         //caculation ends
                end
            end
            2: begin
                state <= 0;                               //reset
            end
            default: state <= 0;
        endcase
    end else begin
        sqrt_end <= 1'b0;
        state <= 4'b0;
        cnt <= 8'b0;
        out_data <= out_data;
    end
end
endmodule