clc
clear 
close all

fid=fopen( '..\project\src\acos_rom.mi','w');

N = 2000;

t = linspace(-1,1,N);

data = floor(acos(t)*180/pi*10);

for i = 1:N
    fprintf(fid,'%x\r\n',data(i));
end

fclose(fid);
