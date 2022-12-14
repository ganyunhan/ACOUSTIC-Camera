//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.8.08
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Created Time: Sat Oct 22 12:44:58 2022

module ram3_512 (dout, clka, cea, reseta, clkb, ceb, resetb, oce, ada, din, adb);

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
defparam sdpb_inst_0.INIT_RAM_00 = 256'hFF44FF22FF1EFF47FF7BFF8DFFAEFFCFFFE00000000000000000000000000000;
defparam sdpb_inst_0.INIT_RAM_01 = 256'h02C0029B027E02340227023001FA01BA01B6019C0167010A00850065003FFFBE;
defparam sdpb_inst_0.INIT_RAM_02 = 256'hFFD4FF8BFF43FEA0FE35FE4CFE27FE2CFDB2FCEFFCC7FD67FE49FFCA017A027C;
defparam sdpb_inst_0.INIT_RAM_03 = 256'h019300CEFFF1FECBFE41FE05FDD5FDD5FDD4FDBBFD8BFDA9FDE2FE90FF42FFBB;
defparam sdpb_inst_0.INIT_RAM_04 = 256'h0041013B015601A401E7020301F601BE019701A40234029102B402A902380211;
defparam sdpb_inst_0.INIT_RAM_05 = 256'h01AB02C0035603B403B303D703D903E4033D01D5005EFEB9FD4CFCCEFD79FECC;
defparam sdpb_inst_0.INIT_RAM_06 = 256'h08410609030900CCFE79FC7BFA63F817F62EF4E4F4ADF59EF759F9B6FCF5FFD0;
defparam sdpb_inst_0.INIT_RAM_07 = 256'hFA9BF8FFF890F8B8FA1AFCC1FFA00264050806F3080B09600A040A9B0A500925;
defparam sdpb_inst_0.INIT_RAM_08 = 256'h005CFF96FE51FD23FC97FCA5FD3CFE4BFF8700FC020B02750209008EFE7FFCA1;
defparam sdpb_inst_0.INIT_RAM_09 = 256'hFC4CFB43FAC5FB3EFBEAFC3BFCB8FD68FE6DFF43FFAC00BF0177018B01C60155;
defparam sdpb_inst_0.INIT_RAM_0A = 256'h02990471071008BA09FE0A2609BB0849070E05C40425026000A4FF5CFE0EFCFB;
defparam sdpb_inst_0.INIT_RAM_0B = 256'hF8F1F898F87FF969FADBFC5CFE31FEDEFE84FDF7FD06FC6BFCBBFD9EFEDD00B0;
defparam sdpb_inst_0.INIT_RAM_0C = 256'h01BD00FA0074005800F6020102F3040404530496043F0227FF4DFD2BFB65F9E5;
defparam sdpb_inst_0.INIT_RAM_0D = 256'h0131016B01F601F00188017001790186018D024D02EF035C03970358032D02C1;
defparam sdpb_inst_0.INIT_RAM_0E = 256'hFE1CFE21FEE7FF57FEB1FD21FA9DF99AFA64FAF5FC50FE78FFBF006A00BE00F6;
defparam sdpb_inst_0.INIT_RAM_0F = 256'hF869F83AF8B2F9B9FB50FD1FFEA3000E0032FF76FF73FF85FF2AFF21FEEFFE6E;
defparam sdpb_inst_0.INIT_RAM_10 = 256'h05E7083C0975099A091E080206AB070107A4082F082F06AB04630108FDB3FA7D;
defparam sdpb_inst_0.INIT_RAM_11 = 256'h045802B4004DFE24FC5DFA7DF95AF7EBF769F7A0F8C1FB27FE0D00A902EF0470;
defparam sdpb_inst_0.INIT_RAM_12 = 256'h0099FEDBFDAFFCE1FBABF9EBF95EF93FF8C4F9EAFBCBFDEB00590232037E048A;
defparam sdpb_inst_0.INIT_RAM_13 = 256'hF48BF670FAB2FFCB042008580AFA0C240D5A0D2A0B8D097706E805E3045301ED;
defparam sdpb_inst_0.INIT_RAM_14 = 256'hFAE9FC1FFC72FCB0FDACFE79FF9E011A0265033F02A7002BFD25F9C1F668F453;
defparam sdpb_inst_0.INIT_RAM_15 = 256'hFE65FF3AFF1FFEBEFEF1FF8BFFA6FF22FE64FDE2FDE6FE0DFD49FC8AFBCFFAEC;
defparam sdpb_inst_0.INIT_RAM_16 = 256'h07EE0B360E3C0F370E5E0C2E0A6F07CE046001A3FEF6FC6CFAA7FAAAFBA9FCDE;
defparam sdpb_inst_0.INIT_RAM_17 = 256'hF838FB02FE6D0152024C0104FF25FD48FB74FA01FA5FFBA2FDF2000901F70450;
defparam sdpb_inst_0.INIT_RAM_18 = 256'hF871F69EF64CF842FB7EFDEEFFA500FB01580114011C009AFED5FBE9F935F7CB;
defparam sdpb_inst_0.INIT_RAM_19 = 256'h0407082109D80B240B340C0F0DC60EA40E200DAE0BBC08DA055201AEFE66FB58;
defparam sdpb_inst_0.INIT_RAM_1A = 256'h0603056D03D40106FDB8FBE0FA86F8E5F67AF315F02CEE7DF0B6F48FF9B6FF4F;
defparam sdpb_inst_0.INIT_RAM_1B = 256'hF014F20EF45AF750FAE0FCE7FE00FF5AFFF0FFAF0010005D013602E803DD04EE;
defparam sdpb_inst_0.INIT_RAM_1C = 256'h0DF00B970A2D0A7C0BA20BE60B4D0AD409C40829053D015FFC14F6C8F27BF076;
defparam sdpb_inst_0.INIT_RAM_1D = 256'hFAFCF9B3F836F6CCF4F9F49CF671FA14FE4D01B102F104B807AF0B240EAB0FED;
defparam sdpb_inst_0.INIT_RAM_1E = 256'h01EA00C1FE04FC37FCCEFF28021D0233FF2FFBE1F9D9F961FA08FAFDFB8BFBBE;
defparam sdpb_inst_0.INIT_RAM_1F = 256'hFF46041C08B60C7A0EC410490F790D5F0AB2069E02840063FF5CFF6200120178;

endmodule //ram3_512
