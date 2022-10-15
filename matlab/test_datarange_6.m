lag1=[-16:16];
fq=93750;%HZ
vel=34;%mm/0.1ms
L=20;%mm
dist=lag1*34*10000/fq;      %  s=> 0.1ms     乘10000
hold on
xlabel('x');
ylabel('y');
zlabel('z');

for q=1:1:100
    i=unidrnd(33);
    j=unidrnd(33);
    k=unidrnd(33);
    l=unidrnd(33);
    m=unidrnd(33);
    n=unidrnd(33);
        R(i,j,k,l,m,n)=(dist(n)^2-dist(l)^2+dist(k)^2-dist(i)^2)/(2*(dist(i)-dist(k)+dist(l)-dist(n)));
        x(i,j,k,l,m,n)= (2 * R(i,j,k,l,m,n) * (dist(k)-dist(i)+dist(l)-dist(n)) +dist(k)^2-dist(i)^2+dist(l)^2-dist(n)^2 )/ (8*sqrt(3) * L);
        y(i,j,k,l,m,n)= (2 * R(i,j,k,l,m,n) * (dist(m)-dist(j)+dist(n)-dist(i)+dist(l)-dist(k))+(dist(m)^2-dist(j)^2+dist(n)^2-dist(i)^2+dist(l)^2-dist(k)^2))/ (16 * L); 
        z_2(i,j,k,l,m,n)=R(i,j,k,l,m,n)^2-x(i,j,k,l,m,n)^2-y(i,j,k,l,m,n)^2;
        z(i,j,k,l,m,n)=sqrt(z_2(i,j,k,l,m,n));
        if((1000000000000>z(i,j,k,l,m,n))&&(z(i,j,k,l,m,n)>110))
                plot3(x(i,j,k,l,m,n),y(i,j,k,l,m,n),z(i,j,k,l,m,n),'.');               
        disp(lag1(i))
        disp(lag1(j))
        disp(lag1(k))
        disp(lag1(l))
        disp(lag1(m))
        disp(lag1(n))
        disp("r")
        disp(R(i,j,k,l,m,n))
        disp(dist(i))
        disp(dist(j))
        disp(dist(k))
        disp(dist(l))
        disp(dist(m))
        disp(dist(n))
        disp(x(i,j,k,l,m,n))
        disp(y(i,j,k,l,m,n))
        disp(z(i,j,k,l,m,n))
        disp("end")
        end
         clear R
         clear x
         clear y
         clear z_2
         clear z
        end

hold off