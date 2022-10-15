% clear;
% clc;
% close all;

%% pre load
fs=46875;
c=340;
mic_d=0.06;
filename='data2.txt';  %%寰呭鐞嗘枃浠惰矾寰?
data = load(filename);
data_int = B2QW(data,16);
mic1_data = zeros(512,1);
mic2_data = zeros(512,1);
for i=1:2:1024
    mic2_data(fix(i/2)+1,1) = data_int(i,1);
end
for i=2:2:1024
    mic1_data(fix(i/2),1) = data_int(i,1);
end

%鐢熸垚test鏁版嵁
tb_x = dec2bin(mic2_data,16);
tb_y = dec2bin(mic1_data,16);
% figure(1)
% plot(mic1_data);
% plot(mic2_data);
% xlabel("plot")
% ylabel("骞呭害")
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
filorder = 8;  %婊ゆ尝鍣ㄩ樁鏁?
cutf1 = 50;  %婊ゆ尝棰戠巼1
cutf2 = 1000;  %婊ゆ尝棰戠巼2k////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
d = designfilt('bandpassfir','FilterOrder',filorder, ...
         'CutoffFrequency1',cutf1,'CutoffFrequency2',cutf2, ...
         'SampleRate',fs);
data_fir = filtfilt(d,data_int);
% figure(3)
% plot(data_int);
% xlabel("plot")
% ylabel("骞呭害")
% grid on
plot(mic1_data,'DisplayName','mic1_data');hold on;plot(mic2_data,'DisplayName','mic2_data');hold off;
%% fft
% SpecPlot(data_fir,fs,'single',4);
[rcc,lag] = xcorr(mic1_data,mic2_data,16);

RGCC=fft(rcc,64); %fft后，虚部实部存入ram
RGCC_abs=abs(RGCC); %负数求模
RGCC_PHAT = RGCC*1./RGCC_abs; %实部和虚部分别除以模
rgcc=ifft(RGCC_PHAT,33); %ifft

[~,I] = max(abs(rgcc));
lagDiff = lag(I);
timeDiff = lagDiff/fs;
dis_r=timeDiff*c;
angel = dis_r./(mic_d);
angel=acos(angel)*180/pi;

%% play sound
sound(data_fir,fs);