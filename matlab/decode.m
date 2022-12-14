% clear;
% clc;
% close all;

%% pre load
fs=93750;
c=340;
mic_d=0.06;
filename='data_6+1.txt';  %%待处理文件路???
data = load(filename);
data_int = B2QW(data,16);
mic0_data = data_int(1:512);
mic1_data = data_int(513:1024);
mic2_data = data_int(1025:1536);
mic3_data = data_int(1537:2048);
mic4_data = data_int(2049:2560);
mic5_data = data_int(2561:3072);
mic6_data = data_int(3073:3584);
% for i=1:2:1024
%     mic2_data(fix(i/2)+1,1) = data_int(i,1);
% end
% for i=2:2:1024
%     mic1_data(fix(i/2),1) = data_int(i,1);
% end

%生成test数据
tb_x = dec2bin(mic2_data,16);
tb_y = dec2bin(mic1_data,16);
% figure(1)
% plot(mic1_data);
% plot(mic2_data);
% xlabel("plot")
% ylabel("幅度")
% grid on

%% fft
% SpecPlot(data_int,fs,'single',2);

%% fir filter
% f = [200 400 34000 4000];
% dev = [0.01 0.02 0.01];
% a = [0 1 0];
% [n,wn,beta,ftype] = kaiserord(f,a,dev,fs);
% b = fir1(n,wn,'bandpass');
% % freqz(b)
% data_fir=filter(b,1,data_int);

%%
filorder = 8;  %滤波器阶???
cutf1 = 50;  %滤波频率1
cutf2 = 1000;  %滤波频率2k////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
d = designfilt('bandpassfir','FilterOrder',filorder, ...
         'CutoffFrequency1',cutf1,'CutoffFrequency2',cutf2, ...
         'SampleRate',fs);
data_fir = filtfilt(d,data_int);
% figure(3)
% plot(data_int);
% xlabel("plot")
% ylabel("幅度")
% grid on
plot(mic1_data,'DisplayName','mic1_data');hold on;plot(mic2_data,'DisplayName','mic2_data');hold off;
%% fft
% SpecPlot(data_fir,fs,'single',4);
[rcc,lag] = xcorr(mic1_data,mic2_data,16);

RGCC=fft(rcc,64); %fft?????鲿ʵ??????ram
RGCC_abs=abs(RGCC); %??????ģ
RGCC_PHAT = RGCC*1./RGCC_abs; %ʵ?????鲿?ֱ?????ģ
rgcc=ifft(RGCC_PHAT,33); %ifft

[~,I] = max(abs(rgcc));
lagDiff = lag(I);
timeDiff = lagDiff/fs;
dis_r=timeDiff*c;
angel = dis_r./(mic_d);
angel=acos(angel)*180/pi;

%% play sound
sound(data_fir,fs);