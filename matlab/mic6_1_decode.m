function [x,y,z] = mic6_1_decode(lagDiff01,lagDiff02,lagDiff03,lagDiff04,lagDiff05,lagDiff06)
%MIC6_1_DECODE 此处显示有关此函数的摘要
%   此处显示详细说明
fq=93750;%HZ
vel=340;%mm/0.1ms
L=200;%mm

dist01=lagDiff01*vel*10000/fq;      %  s=> 0.1ms     乘10000
dist02=lagDiff02*vel*10000/fq;      %  s=> 0.1ms     乘10000
dist03=lagDiff03*vel*10000/fq;      %  s=> 0.1ms     乘10000
dist04=lagDiff04*vel*10000/fq;      %  s=> 0.1ms     乘10000
dist05=lagDiff05*vel*10000/fq;      %  s=> 0.1ms     乘10000
dist06=lagDiff06*vel*10000/fq;      %  s=> 0.1ms     乘10000

R_dividend = (dist06^2-dist04^2+dist03^2-dist01^2);
R_divisor = (2*(dist01-dist03+dist04-dist06));
R=R_dividend/R_divisor;

x_dividend = (2 * R * (dist03-dist01+dist04-dist06) +dist03^2-dist01^2+dist04^2-dist06^2 );
x_divisor = (8*sqrt(3) * L);
x=x_dividend/x_divisor;

y_dividend = (2 * R * (dist05-dist02+dist06-dist01+dist04-dist03)+(dist05^2-dist02^2+dist06^2-dist01^2+dist04^2-dist03^2));
y_divisor =  (16 * L);
y=y_dividend/y_divisor;

z_2=R^2-x^2-y^2;

z=sqrt(z_2);

end
