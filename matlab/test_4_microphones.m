clc
clear 
close all

%加载一段声音（matlab自带敲锣声）
load gong;
%采样频率 越高越精准
Fs = 31250;  
%采样周期
dt=1/Fs;
%music_src为声源
music_src=single(y*100000);
music_src = double(music_src(1:1024));
%设置两个麦克风坐标
mic_d=0.06;
mic_x=[mic_d,-mic_d,-mic_d,mic_d];
mic_y=[mic_d,mic_d,-mic_d,-mic_d];
mic_z=[0,0,0,0];
figure(1);
hold on;
plot3(mic_x,mic_y,mic_z,'r*');

%声源坐标
s_x=10;
s_y=10;
s_z=10;
plot3(s_x,s_y,s_z,'r*');
hold off;

%求出距离
dis_s1=sqrt((mic_x(1)-s_x).^2+(mic_y(1)-s_y).^2+(mic_z(1)-s_z).^2);
dis_s2=sqrt((mic_x(2)-s_x).^2+(mic_y(2)-s_y).^2+(mic_z(2)-s_z).^2);
dis_s3=sqrt((mic_x(3)-s_x).^2+(mic_y(3)-s_y).^2+(mic_z(3)-s_z).^2);
dis_s4=sqrt((mic_x(4)-s_x).^2+(mic_y(4)-s_y).^2+(mic_z(4)-s_z).^2);
c=340;
delay2=abs((dis_s1-dis_s2)./c);
delay3=abs((dis_s1-dis_s3)./c);
delay4=abs((dis_s1-dis_s4)./c);

%设置延时
music_delay2 = int16(floor(delayseq(music_src,delay2,Fs)));
music_delay3 = int16(floor(delayseq(music_src,delay3,Fs)));
music_delay4 = int16(floor(delayseq(music_src,delay4,Fs)));
music_src = int16(floor(music_src));

tb_2 = dec2bin(music_delay2);
tb_3 = dec2bin(music_delay3);
tb_4 = dec2bin(music_delay4);
tb_1 = dec2bin(music_src);

music_delay2_b2d = B2QW(bin2dec(tb_2),16);
music_delay3_b2d = B2QW(bin2dec(tb_3),16);
music_delay4_b2d = B2QW(bin2dec(tb_4),16);
music_src_b2d = B2QW(bin2dec(tb_1),16);

%cc
[rcc2,lag2]=xcorr(music_delay2,music_src,16);
[rcc3,lag3]=xcorr(music_delay3,music_src,16);
[rcc4,lag4]=xcorr(music_delay4,music_src,16);

[~,I]=max(abs(rcc2));
[~,J]=max(abs(rcc3));
[~,K]=max(abs(rcc4));
lagDiff2=lag2(I);
lagDiff3=lag3(J);
lagDiff4=lag4(K);
timeDiff2 = lagDiff2/Fs;
timeDiff3 = lagDiff3/Fs;
timeDiff4 = lagDiff4/Fs;

dist21=timeDiff2*c;
dist31=timeDiff3*c;
dist41=timeDiff4*c;

real_dis21=((dis_s2)-(dis_s1));
real_dis31=((dis_s3)-(dis_s1));
real_dis41=((dis_s4)-(dis_s1));
error2=(dist21-real_dis21);
error3=(dist31-real_dis31);
error4=(dist41-real_dis41);

fprintf('error2 = %f\r\n',error2);
fprintf('error3 = %f\r\n',error3);
fprintf('error4 = %f\r\n',error4);

