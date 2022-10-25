function [x,y,z] = mic6_1_decode(lagDiff01,lagDiff02,lagDiff03,lagDiff04,lagDiff05,lagDiff06)
%MIC6_1_DECODE 此处显示有关此函数的摘要
%   此处显示详细说明
fq=93750;%HZ
vel=340;%mm/0.1ms
L=200;%mm

dist01=round(round(lagDiff01*vel*10000)/fq);      %  s=> 0.1ms     乘10000
dist02=round(round(lagDiff02*vel*10000)/fq);      %  s=> 0.1ms     乘10000
dist03=round(round(lagDiff03*vel*10000)/fq);      %  s=> 0.1ms     乘10000
dist04=round(round(lagDiff04*vel*10000)/fq);      %  s=> 0.1ms     乘10000
dist05=round(round(lagDiff05*vel*10000)/fq);      %  s=> 0.1ms     乘10000
dist06=round(round(lagDiff06*vel*10000)/fq);      %  s=> 0.1ms     乘10000

R_dividend = round(dist06^2-dist04^2+dist03^2-dist01^2);
R_divisor = round(2*(dist01-dist03+dist04-dist06));
R=abs(round(R_dividend/R_divisor))

x_dividend = round(2 * R * (dist03-dist01+dist04-dist06) +dist03^2-dist01^2+dist04^2-dist06^2 );
x_divisor = round(8*sqrt(3) * L);
x=round(x_dividend/(10*x_divisor));

y_dividend = round(2 * R * (dist05-dist02+dist06-dist01+dist04-dist03)+(dist05^2-dist02^2+dist06^2-dist01^2+dist04^2-dist03^2));
y_divisor =  round(16 * L);
y=round(y_dividend/(10*y_divisor));

z_2=round(R/10)^2-x^2-y^2;

z=round(sqrt(z_2));

end
