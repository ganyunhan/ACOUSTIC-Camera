clear;
clc;
close all;

o_x="..\Module_test\XCORR\data\x_data.dat";  %%待处理文件路径
o_y="..\Module_test\XCORR\data\y_data.dat";  %%待处理文件路径

data_x = dlmread(o_x);
data_y = dlmread(o_y);

golden_result_f = '..\Module_test\XCORR\data\golden_result.dat';
golden_result = dlmread(golden_result_f);

[result1,lags1] = xcorr(data_x,data_y,10);

figure(1);
plot(result1);
title('Test result');

figure(2);
plot(golden_result);
title('Golden result');

err = (result1 - golden_result')/result1';