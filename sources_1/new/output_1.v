`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 16:03:54
// Design Name: 
// Module Name: output_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module output_1(
    input clk,
    input rst_n,
    
    input [480-1:0] data_in,
	input data_in_valid,
	
	output reg [8-1:0] data_out,
	output reg data_out_valid,
	output reg [6-1:0] time_step,
	output reg done
    );
	
    reg [6-1:0] time_step_pre;
    reg [6-1:0] time_step; // 添加一个寄存器用于延迟
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            time_step_pre <= 0;
        end
		else if (time_step_pre == 'd31) begin
            time_step_pre <= 'd31;
        end
        else if (data_in_valid) begin
            time_step_pre <= time_step_pre + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            time_step <= 0;
        end
        else if (time_step_pre <= 'd31) begin
            time_step <= time_step_pre;
        end
    end
	
	
	wire [8*480-1:0] inter_w_data;
	output_1_rom output_1_rom (
	  .clka(clk),    // input wire clka
	  .ena(data_in_valid),      // input wire ena
	  .addra(time_step),  // input wire [4 : 0] addra
	  .douta(inter_w_data)  // output wire [3839 : 0] douta
	);
	
	genvar i;
	integer j;

	generate
		for (i = 0; i < 8; i = i + 1) begin
			wire [480-1:0] inter_xor_result = ~(inter_w_data[i*480 +: 480] ^ data_in);
			
			wire [8:0] inter_popcount_out = inter_xor_result[0] + inter_xor_result[1] + inter_xor_result[2] + inter_xor_result[3] + inter_xor_result[4] + inter_xor_result[5] + inter_xor_result[6] + inter_xor_result[7] + inter_xor_result[8] + inter_xor_result[9] + inter_xor_result[10] + inter_xor_result[11] + inter_xor_result[12] + inter_xor_result[13] + inter_xor_result[14] + inter_xor_result[15] + inter_xor_result[16] + inter_xor_result[17] + inter_xor_result[18] + inter_xor_result[19] + inter_xor_result[20] + inter_xor_result[21] + inter_xor_result[22] + inter_xor_result[23] + inter_xor_result[24] + inter_xor_result[25] + inter_xor_result[26] + inter_xor_result[27] + inter_xor_result[28] + inter_xor_result[29] + inter_xor_result[30] + inter_xor_result[31] + inter_xor_result[32] + inter_xor_result[33] + inter_xor_result[34] + inter_xor_result[35] + inter_xor_result[36] + inter_xor_result[37] + inter_xor_result[38] + inter_xor_result[39] + inter_xor_result[40] + inter_xor_result[41] + inter_xor_result[42] + inter_xor_result[43] + inter_xor_result[44] + inter_xor_result[45] + inter_xor_result[46] + inter_xor_result[47] + inter_xor_result[48] + inter_xor_result[49] + inter_xor_result[50] + inter_xor_result[51] + inter_xor_result[52] + inter_xor_result[53] + inter_xor_result[54] + inter_xor_result[55] + inter_xor_result[56] + inter_xor_result[57] + inter_xor_result[58] + inter_xor_result[59] + inter_xor_result[60] + inter_xor_result[61] + inter_xor_result[62] + inter_xor_result[63] + inter_xor_result[64] + inter_xor_result[65] + inter_xor_result[66] + inter_xor_result[67] + inter_xor_result[68] + inter_xor_result[69] + inter_xor_result[70] + inter_xor_result[71] + inter_xor_result[72] + inter_xor_result[73] + inter_xor_result[74] + inter_xor_result[75] + inter_xor_result[76] + inter_xor_result[77] + inter_xor_result[78] + inter_xor_result[79] + inter_xor_result[80] + inter_xor_result[81] + inter_xor_result[82] + inter_xor_result[83] + inter_xor_result[84] + inter_xor_result[85] + inter_xor_result[86] + inter_xor_result[87] + inter_xor_result[88] + inter_xor_result[89] + inter_xor_result[90] + inter_xor_result[91] + inter_xor_result[92] + inter_xor_result[93] + inter_xor_result[94] + inter_xor_result[95] + inter_xor_result[96] + inter_xor_result[97] + inter_xor_result[98] + inter_xor_result[99] + inter_xor_result[100] + inter_xor_result[101] + inter_xor_result[102] + inter_xor_result[103] + inter_xor_result[104] + inter_xor_result[105] + inter_xor_result[106] + inter_xor_result[107] + inter_xor_result[108] + inter_xor_result[109] + inter_xor_result[110] + inter_xor_result[111] + inter_xor_result[112] + inter_xor_result[113] + inter_xor_result[114] + inter_xor_result[115] + inter_xor_result[116] + inter_xor_result[117] + inter_xor_result[118] + inter_xor_result[119] + inter_xor_result[120] + inter_xor_result[121] + inter_xor_result[122] + inter_xor_result[123] + inter_xor_result[124] + inter_xor_result[125] + inter_xor_result[126] + inter_xor_result[127] + inter_xor_result[128] + inter_xor_result[129] + inter_xor_result[130] + inter_xor_result[131] + inter_xor_result[132] + inter_xor_result[133] + inter_xor_result[134] + inter_xor_result[135] + inter_xor_result[136] + inter_xor_result[137] + inter_xor_result[138] + inter_xor_result[139] + inter_xor_result[140] + inter_xor_result[141] + inter_xor_result[142] + inter_xor_result[143] + inter_xor_result[144] + inter_xor_result[145] + inter_xor_result[146] + inter_xor_result[147] + inter_xor_result[148] + inter_xor_result[149] + inter_xor_result[150] + inter_xor_result[151] + inter_xor_result[152] + inter_xor_result[153] + inter_xor_result[154] + inter_xor_result[155] + inter_xor_result[156] + inter_xor_result[157] + inter_xor_result[158] + inter_xor_result[159] + inter_xor_result[160] + inter_xor_result[161] + inter_xor_result[162] + inter_xor_result[163] + inter_xor_result[164] + inter_xor_result[165] + inter_xor_result[166] + inter_xor_result[167] + inter_xor_result[168] + inter_xor_result[169] + inter_xor_result[170] + inter_xor_result[171] + inter_xor_result[172] + inter_xor_result[173] + inter_xor_result[174] + inter_xor_result[175] + inter_xor_result[176] + inter_xor_result[177] + inter_xor_result[178] + inter_xor_result[179] + inter_xor_result[180] + inter_xor_result[181] + inter_xor_result[182] + inter_xor_result[183] + inter_xor_result[184] + inter_xor_result[185] + inter_xor_result[186] + inter_xor_result[187] + inter_xor_result[188] + inter_xor_result[189] + inter_xor_result[190] + inter_xor_result[191] + inter_xor_result[192] + inter_xor_result[193] + inter_xor_result[194] + inter_xor_result[195] + inter_xor_result[196] + inter_xor_result[197] + inter_xor_result[198] + inter_xor_result[199] + inter_xor_result[200] + inter_xor_result[201] + inter_xor_result[202] + inter_xor_result[203] + inter_xor_result[204] + inter_xor_result[205] + inter_xor_result[206] + inter_xor_result[207] + inter_xor_result[208] + inter_xor_result[209] + inter_xor_result[210] + inter_xor_result[211] + inter_xor_result[212] + inter_xor_result[213] + inter_xor_result[214] + inter_xor_result[215] + inter_xor_result[216] + inter_xor_result[217] + inter_xor_result[218] + inter_xor_result[219] + inter_xor_result[220] + inter_xor_result[221] + inter_xor_result[222] + inter_xor_result[223] + inter_xor_result[224] + inter_xor_result[225] + inter_xor_result[226] + inter_xor_result[227] + inter_xor_result[228] + inter_xor_result[229] + inter_xor_result[230] + inter_xor_result[231] + inter_xor_result[232] + inter_xor_result[233] + inter_xor_result[234] + inter_xor_result[235] + inter_xor_result[236] + inter_xor_result[237] + inter_xor_result[238] + inter_xor_result[239] + inter_xor_result[240] + inter_xor_result[241] + inter_xor_result[242] + inter_xor_result[243] + inter_xor_result[244] + inter_xor_result[245] + inter_xor_result[246] + inter_xor_result[247] + inter_xor_result[248] + inter_xor_result[249] + inter_xor_result[250] + inter_xor_result[251] + inter_xor_result[252] + inter_xor_result[253] + inter_xor_result[254] + inter_xor_result[255] + inter_xor_result[256] + inter_xor_result[257] + inter_xor_result[258] + inter_xor_result[259] + inter_xor_result[260] + inter_xor_result[261] + inter_xor_result[262] + inter_xor_result[263] + inter_xor_result[264] + inter_xor_result[265] + inter_xor_result[266] + inter_xor_result[267] + inter_xor_result[268] + inter_xor_result[269] + inter_xor_result[270] + inter_xor_result[271] + inter_xor_result[272] + inter_xor_result[273] + inter_xor_result[274] + inter_xor_result[275] + inter_xor_result[276] + inter_xor_result[277] + inter_xor_result[278] + inter_xor_result[279] + inter_xor_result[280] + inter_xor_result[281] + inter_xor_result[282] + inter_xor_result[283] + inter_xor_result[284] + inter_xor_result[285] + inter_xor_result[286] + inter_xor_result[287] + inter_xor_result[288] + inter_xor_result[289] + inter_xor_result[290] + inter_xor_result[291] + inter_xor_result[292] + inter_xor_result[293] + inter_xor_result[294] + inter_xor_result[295] + inter_xor_result[296] + inter_xor_result[297] + inter_xor_result[298] + inter_xor_result[299] + inter_xor_result[300] + inter_xor_result[301] + inter_xor_result[302] + inter_xor_result[303] + inter_xor_result[304] + inter_xor_result[305] + inter_xor_result[306] + inter_xor_result[307] + inter_xor_result[308] + inter_xor_result[309] + inter_xor_result[310] + inter_xor_result[311] + inter_xor_result[312] + inter_xor_result[313] + inter_xor_result[314] + inter_xor_result[315] + inter_xor_result[316] + inter_xor_result[317] + inter_xor_result[318] + inter_xor_result[319] + inter_xor_result[320] + inter_xor_result[321] + inter_xor_result[322] + inter_xor_result[323] + inter_xor_result[324] + inter_xor_result[325] + inter_xor_result[326] + inter_xor_result[327] + inter_xor_result[328] + inter_xor_result[329] + inter_xor_result[330] + inter_xor_result[331] + inter_xor_result[332] + inter_xor_result[333] + inter_xor_result[334] + inter_xor_result[335] + inter_xor_result[336] + inter_xor_result[337] + inter_xor_result[338] + inter_xor_result[339] + inter_xor_result[340] + inter_xor_result[341] + inter_xor_result[342] + inter_xor_result[343] + inter_xor_result[344] + inter_xor_result[345] + inter_xor_result[346] + inter_xor_result[347] + inter_xor_result[348] + inter_xor_result[349] + inter_xor_result[350] + inter_xor_result[351] + inter_xor_result[352] + inter_xor_result[353] + inter_xor_result[354] + inter_xor_result[355] + inter_xor_result[356] + inter_xor_result[357] + inter_xor_result[358] + inter_xor_result[359] + inter_xor_result[360] + inter_xor_result[361] + inter_xor_result[362] + inter_xor_result[363] + inter_xor_result[364] + inter_xor_result[365] + inter_xor_result[366] + inter_xor_result[367] + inter_xor_result[368] + inter_xor_result[369] + inter_xor_result[370] + inter_xor_result[371] + inter_xor_result[372] + inter_xor_result[373] + inter_xor_result[374] + inter_xor_result[375] + inter_xor_result[376] + inter_xor_result[377] + inter_xor_result[378] + inter_xor_result[379] + inter_xor_result[380] + inter_xor_result[381] + inter_xor_result[382] + inter_xor_result[383] + inter_xor_result[384] + inter_xor_result[385] + inter_xor_result[386] + inter_xor_result[387] + inter_xor_result[388] + inter_xor_result[389] + inter_xor_result[390] + inter_xor_result[391] + inter_xor_result[392] + inter_xor_result[393] + inter_xor_result[394] + inter_xor_result[395] + inter_xor_result[396] + inter_xor_result[397] + inter_xor_result[398] + inter_xor_result[399] + inter_xor_result[400] + inter_xor_result[401] + inter_xor_result[402] + inter_xor_result[403] + inter_xor_result[404] + inter_xor_result[405] + inter_xor_result[406] + inter_xor_result[407] + inter_xor_result[408] + inter_xor_result[409] + inter_xor_result[410] + inter_xor_result[411] + inter_xor_result[412] + inter_xor_result[413] + inter_xor_result[414] + inter_xor_result[415] + inter_xor_result[416] + inter_xor_result[417] + inter_xor_result[418] + inter_xor_result[419] + inter_xor_result[420] + inter_xor_result[421] + inter_xor_result[422] + inter_xor_result[423] + inter_xor_result[424] + inter_xor_result[425] + inter_xor_result[426] + inter_xor_result[427] + inter_xor_result[428] + inter_xor_result[429] + inter_xor_result[430] + inter_xor_result[431] + inter_xor_result[432] + inter_xor_result[433] + inter_xor_result[434] + inter_xor_result[435] + inter_xor_result[436] + inter_xor_result[437] + inter_xor_result[438] + inter_xor_result[439] + inter_xor_result[440] + inter_xor_result[441] + inter_xor_result[442] + inter_xor_result[443] + inter_xor_result[444] + inter_xor_result[445] + inter_xor_result[446] + inter_xor_result[447] + inter_xor_result[448] + inter_xor_result[449] + inter_xor_result[450] + inter_xor_result[451] + inter_xor_result[452] + inter_xor_result[453] + inter_xor_result[454] + inter_xor_result[455] + inter_xor_result[456] + inter_xor_result[457] + inter_xor_result[458] + inter_xor_result[459] + inter_xor_result[460] + inter_xor_result[461] + inter_xor_result[462] + inter_xor_result[463] + inter_xor_result[464] + inter_xor_result[465] + inter_xor_result[466] + inter_xor_result[467] + inter_xor_result[468] + inter_xor_result[469] + inter_xor_result[470] + inter_xor_result[471] + inter_xor_result[472] + inter_xor_result[473] + inter_xor_result[474] + inter_xor_result[475] + inter_xor_result[476] + inter_xor_result[477] + inter_xor_result[478] + inter_xor_result[479];
			
//			reg [9-1:0] inter_popcount_out;
//
//			always@(posedge clk or negedge rst_n) begin
//				if (~rst_n) begin
//					inter_popcount_out <= 0;
//				end
//				else if (data_in_valid) begin
//					for (j = 0; j < 480; j = j + 1) begin
//						inter_popcount_out <= inter_popcount_out + inter_xor_result[j];
//					end
//				end
//			end
			
			always@(posedge clk or negedge rst_n) begin
				if (~rst_n) begin
					data_out[i] <= 0;
				end
				else if (data_in_valid) begin
					data_out[i] <= (2*inter_popcount_out-480) > 0 ? 1 : 0;
				end
			end
		end
	endgenerate
	

	
	always@(posedge clk,negedge rst_n)begin
		if(~rst_n)
			done <= 0;
		else if (time_step == 'd31)
			done <= 1;
	end
	
	always@(posedge clk,negedge rst_n)begin
		if(~rst_n)
			data_out_valid <= 0;
		else if (data_in_valid)
			data_out_valid <= 1;
		else 
			data_out_valid <= 0;
	end
endmodule
