//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.8.08
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Created Time: Sat Oct 22 12:50:04 2022

module ram6_512 (dout, clka, cea, reseta, clkb, ceb, resetb, oce, ada, din, adb);

output [15:0] dout;
input clka;
input cea;
input reseta;
input clkb;
input ceb;
input resetb;
input oce;
input [8:0] ada;
input [15:0] din;
input [8:0] adb;

wire [15:0] sdpb_inst_0_dout_w;
wire gw_vcc;
wire gw_gnd;

assign gw_vcc = 1'b1;
assign gw_gnd = 1'b0;

SDPB sdpb_inst_0 (
    .DO({sdpb_inst_0_dout_w[15:0],dout[15:0]}),
    .CLKA(clka),
    .CEA(cea),
    .RESETA(reseta),
    .CLKB(clkb),
    .CEB(ceb),
    .RESETB(resetb),
    .OCE(oce),
    .BLKSELA({gw_gnd,gw_gnd,gw_gnd}),
    .BLKSELB({gw_gnd,gw_gnd,gw_gnd}),
    .ADA({gw_gnd,ada[8:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[15:0]}),
    .ADB({gw_gnd,adb[8:0],gw_gnd,gw_gnd,gw_gnd,gw_gnd})
);

defparam sdpb_inst_0.READ_MODE = 1'b0;
defparam sdpb_inst_0.BIT_WIDTH_0 = 16;
defparam sdpb_inst_0.BIT_WIDTH_1 = 16;
defparam sdpb_inst_0.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_0.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_0.RESET_MODE = "SYNC";
defparam sdpb_inst_0.INIT_RAM_00 = 256'h020801B201C1019301760105009800560055FFB4FF5DFF0BFF39FF23FF9FFF5C;
defparam sdpb_inst_0.INIT_RAM_01 = 256'hFE2EFE27FDC4FCF2FCC9FD54FE40FFA8016B026B02C8029502890230022E0228;
defparam sdpb_inst_0.INIT_RAM_02 = 256'hFDDAFDD1FDD7FDBBFD90FDA3FDE0FE7FFF3EFFB1FFDAFF8BFF4EFEA6FE3AFE48;
defparam sdpb_inst_0.INIT_RAM_03 = 256'h01FC01BE019C019C022E028C02B402AB0240021001A100D60005FED7FE48FE06;
defparam sdpb_inst_0.INIT_RAM_04 = 256'h03DB03E3035101E90077FED0FD5FFCCBFD6BFEB5002E01320158019B01E701FF;
defparam sdpb_inst_0.INIT_RAM_05 = 256'hFA88F836F649F4EFF4A9F587F73EF989FCC4FFAC019602B3035003B103B403D4;
defparam sdpb_inst_0.INIT_RAM_06 = 256'hFF76023A04E306DE07F9094E09FE0A930A61093208550635033200ECFE9DFC96;
defparam sdpb_inst_0.INIT_RAM_07 = 256'hFD30FE39FF7300E602010272021800AAFE9EFCBCFABBF90DF893F8AFF9FAFC95;
defparam sdpb_inst_0.INIT_RAM_08 = 256'hFCAFFD5CFE5CFF3CFFA200AD0173018901C501630069FFA3FE67FD30FC9BFCA0;
defparam sdpb_inst_0.INIT_RAM_09 = 256'h09C80861071E05DC043E027C00BBFF6EFE23FD06FC58FB52FAC5FB33FBE3FC36;
defparam sdpb_inst_0.INIT_RAM_0A = 256'hFE1CFEDDFE8DFE00FD16FC6CFCB3FD8CFECA008E0282044B06EF08A309F20A28;
defparam sdpb_inst_0.INIT_RAM_0B = 256'h02E303F80452049104510250FF75FD45FB80F9F8F8FCF89AF87DF952FAC8FC3F;
defparam sdpb_inst_0.INIT_RAM_0C = 256'h017801860189023F02E903550398035C032F02CD01CC0103007B005400E801F2;
defparam sdpb_inst_0.INIT_RAM_0D = 256'hFAC1F997FA59FAEBFC32FE5BFFB2006200BC00F2012F016501EF01F6018C0170;
defparam sdpb_inst_0.INIT_RAM_0E = 256'hFE8CFFFE003CFF7DFF6FFF88FF2EFF20FEF6FE75FE20FE1BFED9FF59FEC1FD42;
defparam sdpb_inst_0.INIT_RAM_0F = 256'h06B506F3079F0825083C06C7048E013DFDE3FAABF879F836F8A8F9A5FB34FD06;
defparam sdpb_inst_0.INIT_RAM_10 = 256'hF96CF7FFF768F799F8A5FAFDFDE1008502CF046005C8081D096C099D09290819;
defparam sdpb_inst_0.INIT_RAM_11 = 256'hF95DF948F8C2F9CFFBAEFDC70037021C036B0480046802D30074FE3EFC7BFA93;
defparam sdpb_inst_0.INIT_RAM_12 = 256'h0AE20C120D4D0D3B0BA8099D070705EC0479020800AEFEF5FDBBFCEEFBC4FA01;
defparam sdpb_inst_0.INIT_RAM_13 = 256'hFF8901040254033802C00056FD55F9F5F696F462F47BF644FA63FF8403DF081E;
defparam sdpb_inst_0.INIT_RAM_14 = 256'hFFA8FF2DFE6EFDE7FDE1FE12FD57FC93FBDCFAF7FADDFC0FFC74FCA4FD9EFE6C;
defparam sdpb_inst_0.INIT_RAM_15 = 256'h0A880803048E01CCFF1EFC90FAB6FA9FFB98FCC8FE50FF36FF24FEC2FEE8FF84;
defparam sdpb_inst_0.INIT_RAM_16 = 256'hFF44FD61FB93FA08FA53FB85FDCFFFEB01DC042107B80B050E190F380E760C4F;
defparam sdpb_inst_0.INIT_RAM_17 = 256'hFF8F00EB015C0115011D00A8FEFAFC17F957F7D5F821FACDFE3D012D0253011D;
defparam sdpb_inst_0.INIT_RAM_18 = 256'h0DAE0EA40E280DBA0BE50908058C01E1FE97FB85F899F6AEF644F814FB52FDCF;
defparam sdpb_inst_0.INIT_RAM_19 = 256'hFA9EF8FFF6A9F346F055EE7EF07FF452F95BFF0603BE07F709C30B180B340BF8;
defparam sdpb_inst_0.INIT_RAM_1A = 256'hFDEFFF46FFF2FFAF00090058012002D103D304D805FD057F03F2013AFDE2FBF3;
defparam sdpb_inst_0.INIT_RAM_1B = 256'h0B530AE009D6084B056F01A4FC67F714F2ACF088F009F1E7F439F718FAB4FCD3;
defparam sdpb_inst_0.INIT_RAM_1C = 256'hF645F9D7FE0C019002E10493077E0AED0E7D0FF60E160BB60A360A6D0B920BED;
defparam sdpb_inst_0.INIT_RAM_1D = 256'h01FB0250FF63FC0EF9EAF961F9F7FAF4FB82FBC3FB0BF9CBF849F6E7F50EF493;
defparam sdpb_inst_0.INIT_RAM_1E = 256'h0F910D840AE006E602B2007CFF61FF5FFFFF016701EC00E1FE2EFC41FCB6FEFC;
defparam sdpb_inst_0.INIT_RAM_1F = 256'h000000000000FAC6F88FF841F731F7D0F811FAD0FEFB03D9086F0C520EA11043;

endmodule //ram6_512
