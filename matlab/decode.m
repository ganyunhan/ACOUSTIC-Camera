clear;
clc;
close all;

%% pre load
fs=31250;
filename='data.txt';  %%待处理文件路径
data = load(filename);
data_int = B2QW(data,16);
figure(1)
plot(data_int);
xlabel("plot")
ylabel("幅度")
grid on

%% fft
SpecPlot(data_int,fs,'single',2);

%% fir filter
% f = [200 400 34000 4000];
% dev = [0.01 0.02 0.01];
% a = [0 1 0];
% [n,wn,beta,ftype] = kaiserord(f,a,dev,fs);
% b = fir1(n,wn,'bandpass');
% % freqz(b)
% data_fir=filter(b,1,data_int);

%%
filorder = 8;  %滤波器阶数
cutf1 = 50;  %滤波频率1
cutf2 = 1000;  %滤波频率2
d = designfilt('bandpassfir','FilterOrder',filorder, ...
         'CutoffFrequency1',cutf1,'CutoffFrequency2',cutf2, ...
         'SampleRate',fs);
data_fir = filtfilt(d,data_int);
figure(3)
plot(data_int);
xlabel("plot")
ylabel("幅度")
grid on
%% fft
SpecPlot(data_fir,fs,'single',4);

%% play sound
sound(data_fir,fs);