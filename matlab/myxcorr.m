function [result,lag] = myxcorr(series_x,series_y,SeqLength)
%MYXCORR 此处显示有关此函数的摘要
%   此处显示详细说明
lag = zeros(1,2*SeqLength-1);
result = zeros(1,2*SeqLength-1); % 自编函数
for n = 1:2*SeqLength-1
     result(n) = sum( series_x( max(1,n-SeqLength+1):min(n,SeqLength) ).*series_y( max(1,SeqLength-n+1):min(2*SeqLength-n,SeqLength) ) );
     lag(n) = n-SeqLength;
end
end


