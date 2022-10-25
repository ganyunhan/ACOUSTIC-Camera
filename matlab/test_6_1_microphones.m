clc
clear 
close all

%加载一段声音（matlab自带敲锣声）
load gong;
%采样频率 越高越精准
Fs = 93750;  
%采样周期
dt=1/Fs;
%music_src为声源
music_src=single(y*10000);
music_src = double(music_src(1:512));

filename='data_6+1.txt';  %%寰呭鐞嗘枃浠惰矾寰?
data = load(filename);
data_int = B2QW(data,16);
music_delay00 = data_int(1:512);
music_delay01 = data_int(513:1024);
music_delay02 = data_int(1025:1536);
music_delay03 = data_int(1537:2048);
music_delay04 = data_int(2049:2560);
music_delay05 = data_int(2561:3072);
music_delay06 = data_int(3073:3584);
%设置两个麦克风坐标
mic_d=0.02;
root_3=1.732;
mic_x=[root_3*mic_d,0      ,-root_3*mic_d,-root_3*mic_d,0       ,root_3*mic_d];
mic_y=[mic_d       ,2*mic_d,mic_d        ,-mic_d       ,-2*mic_d,-mic_d      ];
mic_z=[0           ,0      ,0            ,0            ,0       ,0           ];
figure(1);
hold on;
plot3(mic_x,mic_y,mic_z,'r*');

%声源坐标
s_x=0.03;
s_y=0.04;
s_z=0.08;
plot3(s_x,s_y,s_z,'r*');

%求出距离
dis_s0=sqrt(s_x.^2+s_y.^2+s_z.^2);
dis_s1=sqrt((mic_x(1)-s_x).^2+(mic_y(1)-s_y).^2+(mic_z(1)-s_z).^2);
dis_s2=sqrt((mic_x(2)-s_x).^2+(mic_y(2)-s_y).^2+(mic_z(2)-s_z).^2);
dis_s3=sqrt((mic_x(3)-s_x).^2+(mic_y(3)-s_y).^2+(mic_z(3)-s_z).^2);
dis_s4=sqrt((mic_x(4)-s_x).^2+(mic_y(4)-s_y).^2+(mic_z(4)-s_z).^2);
dis_s5=sqrt((mic_x(5)-s_x).^2+(mic_y(5)-s_y).^2+(mic_z(5)-s_z).^2);
dis_s6=sqrt((mic_x(6)-s_x).^2+(mic_y(6)-s_y).^2+(mic_z(6)-s_z).^2);
c=340;
delay01=(dis_s1-dis_s0)/c;
delay02=(dis_s2-dis_s0)/c;
delay03=(dis_s3-dis_s0)/c;
delay04=(dis_s4-dis_s0)/c;
delay05=(dis_s5-dis_s0)/c;
delay06=(dis_s6-dis_s0)/c;

%设置延时
% music_delay00 = int16(floor(music_src));
% music_delay01 = int16(floor(delayseq(music_src,delay01,Fs)));
% music_delay02 = int16(floor(delayseq(music_src,delay02,Fs)));
% music_delay03 = int16(floor(delayseq(music_src,delay03,Fs)));
% music_delay04 = int16(floor(delayseq(music_src,delay04,Fs)));
% music_delay05 = int16(floor(delayseq(music_src,delay05,Fs)));
% music_delay06 = int16(floor(delayseq(music_src,delay06,Fs)));

tb_0 = dec2bin(music_delay00);
tb_1 = dec2bin(music_delay01);
tb_2 = dec2bin(music_delay02);
tb_3 = dec2bin(music_delay03);
tb_4 = dec2bin(music_delay04);
tb_5 = dec2bin(music_delay05);
tb_6 = dec2bin(music_delay06);

%cc
[rcc01,lag01]=xcorr(music_delay01,music_delay00,16);
[rcc02,lag02]=xcorr(music_delay02,music_delay00,16);
[rcc03,lag03]=xcorr(music_delay03,music_delay00,16);
[rcc04,lag04]=xcorr(music_delay04,music_delay00,16);
[rcc05,lag05]=xcorr(music_delay05,music_delay00,16);
[rcc06,lag06]=xcorr(music_delay06,music_delay00,16);

[~,I]=max(abs(rcc01));
[~,J]=max(abs(rcc02));
[~,K]=max(abs(rcc03));
[~,L]=max(abs(rcc04));
[~,M]=max(abs(rcc05));
[~,N]=max(abs(rcc06));

lagDiff01=lag01(I);
lagDiff02=lag02(J);
lagDiff03=lag03(K);
lagDiff04=lag04(L);
lagDiff05=lag05(M);
lagDiff06=lag06(N);

timeDiff01 = lagDiff01/Fs;
timeDiff02 = lagDiff02/Fs;
timeDiff03 = lagDiff03/Fs;
timeDiff04 = lagDiff04/Fs;
timeDiff05 = lagDiff05/Fs;
timeDiff06 = lagDiff06/Fs;

dist01=timeDiff01*c;
dist02=timeDiff02*c;
dist03=timeDiff03*c;
dist04=timeDiff04*c;
dist05=timeDiff05*c;
dist06=timeDiff06*c;

dis_real01=((dis_s1)-(dis_s0));
dis_real02=((dis_s2)-(dis_s0));
dis_real03=((dis_s3)-(dis_s0));
dis_real04=((dis_s4)-(dis_s0));
dis_real05=((dis_s5)-(dis_s0));
dis_real06=((dis_s6)-(dis_s0));

error1=(dist01-dis_real01);
error2=(dist02-dis_real02);
error3=(dist03-dis_real03);
error4=(dist04-dis_real04);
error5=(dist05-dis_real05);
error6=(dist06-dis_real06);

fprintf('dist01 = %f\r\n',dist01);
fprintf('dist02 = %f\r\n',dist02);
fprintf('dist03 = %f\r\n',dist03);
fprintf('dist04 = %f\r\n',dist04);
fprintf('dist05 = %f\r\n',dist05)
fprintf('dist06 = %f\r\n',dist06);

[x,y,z] = mic6_1_decode(-1,-6,-6,2,5,5);

fprintf('x = %f\r\n',x);
fprintf('y = %f\r\n',y);
fprintf('z = %f\r\n',z);

[x_2d,y_2d] = coord_3Dto2D(x,y,z);
