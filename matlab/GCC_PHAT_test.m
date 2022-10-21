clc
clear 
close all

%加载仿真输出进行对比
golden_result_f = '..\Module_test\XCORR\data\golden_result.dat';
golden_result = dlmread(golden_result_f);

mic_data = load('data.txt');
%加载一段声音（matlab自带敲锣声）
load gong;

%采样频率 越高越精准
Fs = 31250;  
%采样周期
dt=1/Fs;
%music_src为声源
music_src=single(y*10000);
music_src = double(music_src(1:512));

% music_src = B2QW(mic_data,16);
%设置两个麦克风坐标
mic_d=0.06;
mic_x=[-mic_d mic_d];
mic_y=[0 0];
% plot(mic_x,mic_y,'x');
% axis([-5 5 -5 5])
% hold on;
% quiver(-5,0,10,0,1,'color','black');
% quiver(0,-5,0,10,1,'color','black');

%声源位置
s_x=-10;
s_y=10;
true_degree = rad2deg(atan(s_y/s_x));
fprintf('true_degree = %f\r\n',true_degree);
plot(s_x,s_y,'o');
% quiver(s_x,s_y,-s_x-mic_d,-s_y,1);
% quiver(s_x,s_y,-s_x+mic_d,-s_y,1);

%求出距离
dis_s1=sqrt((mic_x(1)-s_x).^2+(mic_y(1)-s_y).^2);
dis_s2=sqrt((mic_x(2)-s_x).^2+(mic_y(2)-s_y).^2);
c=340;
delay=abs((dis_s1-dis_s2)./c);
fprintf('delay = %f\r\n',delay);
%设置延时
music_delay = int16((delayseq(music_src,delay,Fs)));
music_src = int16((music_src));

%生成test数据
tb_x = dec2bin(music_delay,16);
tb_y = dec2bin(music_src,16);

% figure(2);
% subplot(211);
% plot(music_src);
% axis([0 length(music_src) -2 2]);
% subplot(212);
% plot(music_delay);
% axis([0 length(music_delay) -2 2]);

% 
% data_delay_diff = music_delay_b2d - music_delay;
% data_src_diff = music_src_b2d - music_src;
%cc算法
[rcc,lag]=xcorr(music_delay,music_src,10);
figure(1);
plot(lag/Fs,rcc);
title('Matlab calculate');
[~,I] = max(abs(rcc));
% lagDiff = lag(I);
lagDiff = lag(I);
timeDiff = lagDiff/Fs;
fprintf('timeDiff_cc = %f\r\n',timeDiff);

% figure(2);
% plot(golden_result);
% title('Golden result');

%gcc+phat算法，根据公式写
% RGCC=fft(rcc);
% rgcc=ifft(RGCC*1./abs(RGCC));
% figure(3);
% plot(lag/Fs,rgcc);
% [M,I] = max(abs(rgcc));
% lagDiff = lag(I);
% timeDiff = lagDiff/Fs;
% fprintf('timeDiff_gcc_phat = %f\r\n',timeDiff);

%计算角度,这里假设为平面波
dis_r=timeDiff*c;
angel = dis_r./(mic_d*2);
angel=acos(angel)*180/pi;
if dis_s1<dis_s2
    angel=180-angel;
end
fprintf('angle_gcc_phat = %f\r\n',angel);
