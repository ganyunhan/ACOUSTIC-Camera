`include "define.v"
`include "static_macro_define.v"
module `module_name(
    series_x,
    series_y,
    result,
    clk,
    rstn,
    complete,
    delay
);

`include "parameter.v"

input signed [W-1:0] series_x, series_y;
input rstn;
input clk;
output signed [2*W-1:0] result;
output [5:0] delay;
output complete;

`getname(crosscorrelation,`module_name) u_xcorr
    (.series_x      (series_x),
     .series_y      (series_y),
     .result        (result),
     .clk           (clk),
     .rstn           (rstn),
     .complete      (complete),
     .delay         (delay)
    );
defparam u_xcorr .W = W;
defparam u_xcorr .N = N;
defparam u_xcorr .lag = lag;
endmodule