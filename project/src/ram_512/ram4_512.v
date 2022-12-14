//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.8.08
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Created Time: Sat Oct 22 12:49:19 2022

module ram4_512 (dout, clka, cea, reseta, clkb, ceb, resetb, oce, ada, din, adb);

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
defparam sdpb_inst_0.INIT_RAM_00 = 256'h008000650039FFB5FF3FFF22FF1FFF4AFF7DFF8EFFB0FFD0FFE2000000000000;
defparam sdpb_inst_0.INIT_RAM_01 = 256'hFE5AFFE6018E028502BF0299027B02310228022E01F601B901B6019901630102;
defparam sdpb_inst_0.INIT_RAM_02 = 256'hFDE9FE9CFF4BFFC0FFD1FF87FF3DFE95FE35FE4CFE26FE2AFDA6FCE7FCCCFD73;
defparam sdpb_inst_0.INIT_RAM_03 = 256'h02B602A40233020E018700C3FFE0FEBDFE3EFE01FDD5FDD4FDD4FDB8FD8BFDAB;
defparam sdpb_inst_0.INIT_RAM_04 = 256'hFD3DFCD0FD8BFEE200560141015801AA01E9020501F301BB019601A9023D0293;
defparam sdpb_inst_0.INIT_RAM_05 = 256'hF777F9E1FD26FFF201C002CA035E03B503B403D903D903E2032B01BF0047FEA0;
defparam sdpb_inst_0.INIT_RAM_06 = 256'h0A0B0AA20A400917082E05DB02E300ABFE57FC60FA40F7F8F615F4D8F4B3F5B4;
defparam sdpb_inst_0.INIT_RAM_07 = 256'h01FB0070FE61FC84FA7DF8F1F890F8C0FA3CFCEBFFCA028C052D0705081E096F;
defparam sdpb_inst_0.INIT_RAM_08 = 256'h017A018D01C701470050FF86FE3DFD16FC94FCA9FD4AFE5CFF9C011002160275;
defparam sdpb_inst_0.INIT_RAM_09 = 256'h008FFF49FDFBFCEFFC40FB34FAC7FB49FBF2FC3FFCC3FD73FE7FFF49FFB700CF;
defparam sdpb_inst_0.INIT_RAM_0A = 256'hFCC4FDAFFEF300D002B00496073108CF0A090A2309AD0830070005AC040D0243;
defparam sdpb_inst_0.INIT_RAM_0B = 256'hFF26FD10FB4BF9D3F8E8F895F883F97FFAEEFC78FE46FEDDFE7DFDECFCF7FC6B;
defparam sdpb_inst_0.INIT_RAM_0C = 256'h03960353032B02B401AE00F1006F005B0105020F0303040F0454049A042C01FD;
defparam sdpb_inst_0.INIT_RAM_0D = 256'hFFCB007200C100FA0133017101FC01E90185016F017C01840194025A02F60362;
defparam sdpb_inst_0.INIT_RAM_0E = 256'hFF26FF21FEE8FE68FE19FE27FEF4FF54FEA2FCFFFA7DF99FFA70FAFFFC70FE92;
defparam sdpb_inst_0.INIT_RAM_0F = 256'h043800D3FD84FA51F85CF83EF8BDF9CCFB6CFD37FEBA001D0028FF70FF77FF80;
defparam sdpb_inst_0.INIT_RAM_10 = 256'hFE3800CC030D048006080858097D0996091407EB06A3070E07AB08370822068E;
defparam sdpb_inst_0.INIT_RAM_11 = 256'h007B024803900493044802940028FE0AFC40FA68F947F7D9F76AF7A6F8DEFB4F;
defparam sdpb_inst_0.INIT_RAM_12 = 256'h06CC05D9042D01D40083FEC2FDA3FCD3FB93F9D6F961F935F8C8FA05FBE8FE0F;
defparam sdpb_inst_0.INIT_RAM_13 = 256'hFCF5F98CF63CF446F49CF69DFB00000F0460088F0B110C350D670D170B730950;
defparam sdpb_inst_0.INIT_RAM_14 = 256'hFD3BFC80FBC2FAE1FAF6FC2EFC70FCBCFDB9FE86FFB3013002750344028CFFFF;
defparam sdpb_inst_0.INIT_RAM_15 = 256'hFA9BFAB5FBB9FCF3FE7AFF3DFF1AFEBAFEFAFF90FFA3FF16FE5BFDDDFDECFE08;
defparam sdpb_inst_0.INIT_RAM_16 = 256'hFE1500270213048008240B660E5D0F350E450C0D0A5507990434017BFED0FC49;
defparam sdpb_inst_0.INIT_RAM_17 = 256'hFEAEFBBCF915F7C3F852FB37FE9C0174024400EBFF06FD30FB55F9FCFA6BFBBF;
defparam sdpb_inst_0.INIT_RAM_18 = 256'h0518017CFE37FB2CF84BF68FF656F871FBA9FE0CFFBB010A01540114011A008A;
defparam sdpb_inst_0.INIT_RAM_19 = 256'hF0EEF4CDFA11FF960451084809EE0B2D0B350C270DDD0EA30E180D9F0B9308AB;
defparam sdpb_inst_0.INIT_RAM_1A = 256'h014D02FD03E705030606055A03B400D2FD91FBCDFA6FF8CAF64AF2E6F004EE80;
defparam sdpb_inst_0.INIT_RAM_1B = 256'hFBC1F67EF24DF065F021F234F47BF788FB0BFCFAFE11FF6DFFEDFFB000170062;
defparam sdpb_inst_0.INIT_RAM_1C = 256'h07E00B5A0ED70FE00DCA0B790A260A8A0BB00BDE0B470AC809B20806050B0118;
defparam sdpb_inst_0.INIT_RAM_1D = 256'hFA1AFB06FB94FBB7FAEEF99AF824F6B0F4E6F4A7F69FFA50FE8C01CF030104DE;
defparam sdpb_inst_0.INIT_RAM_1E = 256'hFF58FF650026018701E6009FFDDCFC2EFCE7FF55023C0213FEFCFBB5F9CAF962;
defparam sdpb_inst_0.INIT_RAM_1F = 256'hF74CF7C5F849FB37FF92045F08FC0CA00EE6104C0F610D3A0A830656025A004B;

endmodule //ram4_512
