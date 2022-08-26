clear;
clc;
close all;

o_x="..\project\data\x.txt";  %%待处理文件路径
o_y="..\project\data\y.txt";  %%待处理文件路径

data_x = dlmread(o_x);
data_y = dlmread(o_y);

[result,lags] = myxcorr(data_x,data_y,1024);
% result = result';
% [M1,I1] = max(abs(result));% 模仿 Matlab doc 给出延迟坐标
% plot(lags,result);

[result1,lags1] = xcorr(data_x,data_y);

result2 = result' - result1;
% [M2,I2] = max(abs(result1));% 模仿 Matlab doc 给出延迟坐标
% figure(2)
% plot(lags1,result1);