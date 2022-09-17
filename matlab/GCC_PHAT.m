clear;
clc;
close all;

% o_x="..\project\data\x.txt";  %%待处理文件路径
% o_y="..\project\data\y.txt";  %%待处理文件路径

o_x="..\Module_test\XCORR\data\x.txt";  %%待处理文件路径
o_y="..\Module_test\XCORR\data\y.txt";  %%待处理文件路径

data_ori_x = dlmread(o_x);
data_ori_y = dlmread(o_y);

tb_x = dec2bin(dlmread(o_x));
tb_y = dec2bin(dlmread(o_y));

data_x = B2QW(bin2dec(tb_x),16);
data_y = B2QW(bin2dec(tb_y),16);
% [result,lags] = myxcorr(data_x,data_y,1024);
% result = result';
% [M1,I1] = max(abs(result));% 模仿 Matlab doc 给出延迟坐标
% plot(lags,result);

[result1,lags1] = xcorr(data_x,data_y,10);

data_x_diff = data_ori_x - data_x;
data_y_diff = data_ori_y - data_y;
%result2 = result' - result1;
% [M2,I2] = max(abs(result1));% 模仿 Matlab doc 给出延迟坐标
% figure(2)
% plot(lags1,result1);