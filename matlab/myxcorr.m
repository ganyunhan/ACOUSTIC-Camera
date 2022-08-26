function [result,lag] = myxcorr(series_x,series_y,SeqLength)
     %MYXCORR 此处显示有关此函数的摘要
     %   此处显示详细说明
     lag = zeros(1,2*SeqLength-1);
     result = zeros(1,2*SeqLength-1); % 自编函数
     for n = 1:2*SeqLength-1
          series_x_sum = series_x( max(1,n-SeqLength+1):min(n,SeqLength) );
          series_y_sum = series_y( max(1,SeqLength-n+1):min(2*SeqLength-n,SeqLength) );
          result(n) = sum( series_x_sum.*series_y_sum );
          lag(n) = n-SeqLength;
     end
     end
     %1.写max/min/abs 
     %2.每次输出一个n(lag)的结果，并在top层比较和上一个相比的abs大小决定取舍 
     %3.数据输入前加一个fifo
     
     
     % result(1) = x(1) * y(SeqLength)
     % result(2) = x(1) * y(SeqLength - 1) + x(2) * y(SeqLength)
     % result(3) = x(1) * y(SeqLength - 2) + x(2) * y(SeqLength - 1) + x(3) * y(SeqLength)
     