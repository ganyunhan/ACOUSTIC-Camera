`timescale 1ns / 1ps
module deUstb(out,in,clk);
input in;
input clk;
output out;
reg [3:0] cnt_r=0;
reg [1:0] isOk_r=0;
wire isOk=&cnt_r;
always @(posedge clk) begin
        if (in==0) begin
            if(isOk) begin
                cnt_r<=cnt_r;
            end
            else begin
                cnt_r<=cnt_r+1;
            end
        end
        else begin
            cnt_r<=0;
        end
end
always @(posedge clk) begin
        isOk_r[1]<=isOk_r[0];
        isOk_r[0]<=isOk;
end
assign out=(~isOk)&(~isOk_r[1]);
endmodule

