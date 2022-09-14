function SpecPlot(signal,fs,bandtype,plotnum)
% signalΪ�����ź�
% fsΪ����Ƶ��(���������ź�Ƶ��)
% bandtypeΪƵ�׻���ѡ���źţ�'single'Ϊ����Ƶ�ף�'double'Ϊ˫��Ƶ��
if nargin < 2
    fprintf('error,ʹ��open SpecPlot���������в鿴\n');
    return
end
if nargin == 2 % Ĭ�ϻ�˫��Ƶ��
    bandtype = 'double';
end
len = length(signal); % �źų���
mag = abs(fftshift(fft(signal))); % Ƶ�׷���|F(e^jw)|
mag = mag/max(mag); % ��һ��
if (strcmp(bandtype,'single'))
    f = [0:len/2]*fs/len; % ����Ƶ�׺����귶ΧΪ[0:fs/2]
    figure
    semilogy(f,mag(round(len/2):len));title('Ƶ��ͼ');xlabel('f/Hz');ylabel('|X(f)|');
else
    f = [-len/2:len/2-1]*fs/len; % ����Ƶ�׺����귶ΧΪ[-fs/2:fs/2]
    figure(plotnum);
    semilogy(f,mag);title('Ƶ��ͼ');xlabel('f/Hz');ylabel('|X(f)|');
end
end
