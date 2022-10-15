clc;
clear;

thd_size = 49;
thd_data = zeros(thd_size,thd_size);
thd_ramdata = zeros(thd_size^2,1);
mid_x = 24;
mid_y = 24;

for i = 1:1:thd_size
    for j = 1:1:thd_size
        if sqrt((i-mid_x)^2+(j-mid_y)^2) <5
            thd_data(i,j) = 0xF800;
            thd_ramdata((j-1)*thd_size+i,1) = 0xF800;
        end
        if sqrt((i-mid_x)^2+(j-mid_y)^2)>=5 && sqrt((i-mid_x)^2+(j-mid_y)^2)<10
            thd_data(i,j)= 0xFA20;
            thd_ramdata((j-1)*thd_size+i,1) = 0xFA20;
        end
        if sqrt((i-mid_x)^2+(j-mid_y)^2)>=10 && sqrt((i-mid_x)^2+(j-mid_y)^2)<15
            thd_data(i,j) = 0xFEA0;
            thd_ramdata((j-1)*thd_size+i,1) = 0xFFE0;
        end
        if sqrt((i-mid_x)^2+(j-mid_y)^2)>=15 && sqrt((i-mid_x)^2+(j-mid_y)^2)<20
            thd_data(i,j) = 0xAFE5;
            thd_ramdata((j-1)*thd_size+i,1) = 0xAFE5;
        end
        if sqrt((i-mid_x)^2+(j-mid_y)^2)>=20 && sqrt((i-mid_x)^2+(j-mid_y)^2)<25
            thd_data(i,j) = 0x3666;
            thd_ramdata((j-1)*thd_size+i,1) = 0x3666;
        end
        if sqrt((i-mid_x)^2+(j-mid_y)^2)>=25 && sqrt((i-mid_x)^2+(j-mid_y)^2)<30
            thd_data(i,j) = 0xAEDC;
            thd_ramdata((j-1)*thd_size+i,1) = 0xAEDC;
        end
        if sqrt((i-mid_x)^2+(j-mid_y)^2)>=30 && sqrt((i-mid_x)^2+(j-mid_y)^2)<35
            thd_data(i,j) = 0x5CF4;
            thd_ramdata((j-1)*thd_size+i,1) = 0x5CF4;
        end
        if sqrt((i-mid_x)^2+(j-mid_y)^2)>=35
            thd_data(i,j) = 0xAEDC;
            thd_ramdata((j-1)*thd_size+i,1) = 0xAEDC;
        end
    end
end

data = dec2bin(thd_ramdata,16);

bin_data = {};
pic = uint8(zeros(thd_size,thd_size,3));

for i = 1:thd_size
    for j = 1:thd_size
        
        bin_data{i,j} = dec2bin(thd_data(i,j),16);

        pic(i,j,1) = bin2dec(bin_data{i,j}(1:5))*8;
        pic(i,j,2) = bin2dec(bin_data{i,j}(6:11))*4;
        pic(i,j,3) = bin2dec(bin_data{i,j}(12:16))*8;
    end
end

imshow(pic);

