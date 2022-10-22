function [x_2d,y_2d] = coord_3Dto2D(x,y,z)
%COORD_3DTO2D 此处显示有关此函数的摘要
%   此处显示详细说明
 IntrinsicMatrix = [437,0,242;
                    0,330,145];
x_2d_dividend = (IntrinsicMatrix(1,1) * x + IntrinsicMatrix(1,2) * y + IntrinsicMatrix(1,3) * z);
x_2d = round(x_2d_dividend / z );

y_2d_dividend = (IntrinsicMatrix(2,1) * x + IntrinsicMatrix(2,2) * y + IntrinsicMatrix(2,3) * z);
 y_2d = round(y_2d_dividend / z );

plot3(x_2d,y_2d,0,'r*');
hold off;
 
end

