//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.8.08
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Created Time: Sat Oct 22 12:43:04 2022

module ram1_512 (dout, clka, cea, reseta, clkb, ceb, resetb, oce, ada, din, adb);

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
defparam sdpb_inst_0.INIT_RAM_00 = 256'h0127009D00660050FFDFFF58FF24FF1EFF38FF73FF89FFA5FFC9FFDC00000000;
defparam sdpb_inst_0.INIT_RAM_01 = 256'hFD38FE0EFF610124025102C102A20289024402230232020B01C401B501A70173;
defparam sdpb_inst_0.INIT_RAM_02 = 256'hFD9FFDCEFE60FF20FFA4FFDBFF9DFF58FECCFE3AFE4BFE2FFE2CFDDFFD14FCBC;
defparam sdpb_inst_0.INIT_RAM_03 = 256'h028702AA02B9024E021801BE00F8002EFF08FE51FE15FDDAFDD5FDD3FDC7FD90;
defparam sdpb_inst_0.INIT_RAM_04 = 256'hFF1CFD90FCD0FD3CFE79FFED011A0154018B01DF01FD020101C901A00195020F;
defparam sdpb_inst_0.INIT_RAM_05 = 256'hF54FF6E8F915FC2EFF43014F0292033603AB03B103CF03D903E6037D022B00B7;
defparam sdpb_inst_0.INIT_RAM_06 = 256'h091B09E80A7B0A860962088106B403A7014BFF01FCE8FAEAF898F694F51BF49E;
defparam sdpb_inst_0.INIT_RAM_07 = 256'h026D023800FCFEF5FD0EFB15F943F897F89FF9A1FC1BFEF601C6047106A207C5;
defparam sdpb_inst_0.INIT_RAM_08 = 256'h007A0161018701BA018A008CFFCCFEA2FD5DFCA6FC98FD0AFE0AFF3700AA01DB;
defparam sdpb_inst_0.INIT_RAM_09 = 256'h02D000FCFFA6FE5AFD2EFC76FB84FAC6FB18FBC8FC2EFC91FD3FFE27FF28FF86;
defparam sdpb_inst_0.INIT_RAM_0A = 256'hFC76FC9BFD5DFE8F0033023B03E90684086609C50A3109E508AB074706210482;
defparam sdpb_inst_0.INIT_RAM_0B = 256'h02C4FFECFD97FBCCFA32F91BF8A4F87AF917FA8DFBF4FDD4FED7FEA2FE1CFD44;
defparam sdpb_inst_0.INIT_RAM_0C = 256'h03430395036B033202ED01F80120008D005100C001C802B503D1044D04830479;
defparam sdpb_inst_0.INIT_RAM_0D = 256'hFE05FF88004B00B100E80126015701D70206019801730172018A017D021902D3;
defparam sdpb_inst_0.INIT_RAM_0E = 256'hFF8FFF3BFF1EFF06FE8AFE2AFE10FEAFFF59FEE8FD9BFB2BF99AFA31FAD5FBDD;
defparam sdpb_inst_0.INIT_RAM_0F = 256'h0718050001DAFE6EFB36F8AFF82FF88AF970FAE5FCBDFE4AFFCB004FFF99FF64;
defparam sdpb_inst_0.INIT_RAM_10 = 256'hFA8AFD60001D026F0430057207BE094B09A40944085906DC06D0078B080A0855;
defparam sdpb_inst_0.INIT_RAM_11 = 256'hFD63FFCF01D90334045D048A032B00E1FE90FCCEFADAF99CF83DF768F78DF85A;
defparam sdpb_inst_0.INIT_RAM_12 = 256'h0A080768060704DE025F00E7FF44FDDFFD16FC03FA4AF95AF95EF8C5F986FB5B;
defparam sdpb_inst_0.INIT_RAM_13 = 256'h00D3FDDDFA8FF71EF49AF453F5D5F985FEB5032307720A920BE30D1E0D670BF3;
defparam sdpb_inst_0.INIT_RAM_14 = 256'hFE19FD7FFCB0FC00FB1BFAC2FBDBFC78FC89FD73FE49FF4E00C30221031F02FD;
defparam sdpb_inst_0.INIT_RAM_15 = 256'hFCFDFAE9FA87FB68FC8FFE0DFF25FF30FED1FED0FF70FFACFF4DFE8AFDFAFDD4;
defparam sdpb_inst_0.INIT_RAM_16 = 256'hFB3BFD67FF95018A03A407170A7A0DA60F330EB20CB60ACB089505160241FF90;
defparam sdpb_inst_0.INIT_RAM_17 = 256'h00CDFF5FFC9DF9BEF7FAF7EAFA37FDB000BC02580163FF9CFDAAFBEBFA2AFA33;
defparam sdpb_inst_0.INIT_RAM_18 = 256'h098A06320277FF24FC07F911F6E6F637F797FACBFD73FF4C00B80161011B011E;
defparam sdpb_inst_0.INIT_RAM_19 = 256'hEE98EFE7F3A7F859FE2B02E9076D09860AEE0B390BB90D650E9A0E420DD60C56;
defparam sdpb_inst_0.INIT_RAM_1A = 256'h004E00E6028B03B4049C05E305AF044401CBFE63FC2FFADEF94AF72AF3D8F0CC;
defparam sdpb_inst_0.INIT_RAM_1B = 256'h0264FD59F7F4F348F0C4EFF9F177F3DCF67CFA29FC93FDBFFF09FFF1FFB4FFF3;
defparam sdpb_inst_0.INIT_RAM_1C = 256'h042E06F10A510DEE0FFF0E830C150A5B0A490B610BFB0B690AFD0A0808A505FC;
defparam sdpb_inst_0.INIT_RAM_1D = 256'hF966F9C8FAD6FB67FBCDFB32FA0FF880F732F551F484F5D0F92CFD4F012302B6;
defparam sdpb_inst_0.INIT_RAM_1E = 256'h00C9FF77FF59FFCD013201EC0135FEAAFC6EFC79FE8101890291FFF7FC96FA23;
defparam sdpb_inst_0.INIT_RAM_1F = 256'hF89CF717F7D8F7D2FA42FE250314079E0BD40E3D10250FCF0DEE0B5E07B50341;

endmodule //ram1_512
