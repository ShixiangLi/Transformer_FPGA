module output_2(
    input clk,
    input rst_n,
    
    input [256-1:0] data_in,
    input data_in_valid,
    
    output reg [9-1:0] data_out,
    output reg data_out_valid
);

    (* ram_style = "ultra" *) wire [256-1:0] inter_w_data;
    wire sel = 0;
    output_2_rom output_2_rom (
        .clka(clk),    // input wire clka
        .ena(data_in_valid),      // input wire ena
        .addra(sel),  // input wire [4 : 0] addra
        .douta(inter_w_data)  // output wire [3839 : 0] douta
    );
    
    (* ram_style = "ultra" *) wire [256-1:0] inter_xor_result = ~(inter_w_data ^ data_in);
	
	wire [8:0] inter_popcount_out = inter_xor_result[0] + inter_xor_result[1] + inter_xor_result[2] + inter_xor_result[3] + inter_xor_result[4] + inter_xor_result[5] + inter_xor_result[6] + inter_xor_result[7] + inter_xor_result[8] + inter_xor_result[9] + inter_xor_result[10] + inter_xor_result[11] + inter_xor_result[12] + inter_xor_result[13] + inter_xor_result[14] + inter_xor_result[15] + inter_xor_result[16] + inter_xor_result[17] + inter_xor_result[18] + inter_xor_result[19] + inter_xor_result[20] + inter_xor_result[21] + inter_xor_result[22] + inter_xor_result[23] + inter_xor_result[24] + inter_xor_result[25] + inter_xor_result[26] + inter_xor_result[27] + inter_xor_result[28] + inter_xor_result[29] + inter_xor_result[30] + inter_xor_result[31] + inter_xor_result[32] + inter_xor_result[33] + inter_xor_result[34] + inter_xor_result[35] + inter_xor_result[36] + inter_xor_result[37] + inter_xor_result[38] + inter_xor_result[39] + inter_xor_result[40] + inter_xor_result[41] + inter_xor_result[42] + inter_xor_result[43] + inter_xor_result[44] + inter_xor_result[45] + inter_xor_result[46] + inter_xor_result[47] + inter_xor_result[48] + inter_xor_result[49] + inter_xor_result[50] + inter_xor_result[51] + inter_xor_result[52] + inter_xor_result[53] + inter_xor_result[54] + inter_xor_result[55] + inter_xor_result[56] + inter_xor_result[57] + inter_xor_result[58] + inter_xor_result[59] + inter_xor_result[60] + inter_xor_result[61] + inter_xor_result[62] + inter_xor_result[63] + inter_xor_result[64] + inter_xor_result[65] + inter_xor_result[66] + inter_xor_result[67] + inter_xor_result[68] + inter_xor_result[69] + inter_xor_result[70] + inter_xor_result[71] + inter_xor_result[72] + inter_xor_result[73] + inter_xor_result[74] + inter_xor_result[75] + inter_xor_result[76] + inter_xor_result[77] + inter_xor_result[78] + inter_xor_result[79] + inter_xor_result[80] + inter_xor_result[81] + inter_xor_result[82] + inter_xor_result[83] + inter_xor_result[84] + inter_xor_result[85] + inter_xor_result[86] + inter_xor_result[87] + inter_xor_result[88] + inter_xor_result[89] + inter_xor_result[90] + inter_xor_result[91] + inter_xor_result[92] + inter_xor_result[93] + inter_xor_result[94] + inter_xor_result[95] + inter_xor_result[96] + inter_xor_result[97] + inter_xor_result[98] + inter_xor_result[99] + inter_xor_result[100] + inter_xor_result[101] + inter_xor_result[102] + inter_xor_result[103] + inter_xor_result[104] + inter_xor_result[105] + inter_xor_result[106] + inter_xor_result[107] + inter_xor_result[108] + inter_xor_result[109] + inter_xor_result[110] + inter_xor_result[111] + inter_xor_result[112] + inter_xor_result[113] + inter_xor_result[114] + inter_xor_result[115] + inter_xor_result[116] + inter_xor_result[117] + inter_xor_result[118] + inter_xor_result[119] + inter_xor_result[120] + inter_xor_result[121] + inter_xor_result[122] + inter_xor_result[123] + inter_xor_result[124] + inter_xor_result[125] + inter_xor_result[126] + inter_xor_result[127] + inter_xor_result[128] + inter_xor_result[129] + inter_xor_result[130] + inter_xor_result[131] + inter_xor_result[132] + inter_xor_result[133] + inter_xor_result[134] + inter_xor_result[135] + inter_xor_result[136] + inter_xor_result[137] + inter_xor_result[138] + inter_xor_result[139] + inter_xor_result[140] + inter_xor_result[141] + inter_xor_result[142] + inter_xor_result[143] + inter_xor_result[144] + inter_xor_result[145] + inter_xor_result[146] + inter_xor_result[147] + inter_xor_result[148] + inter_xor_result[149] + inter_xor_result[150] + inter_xor_result[151] + inter_xor_result[152] + inter_xor_result[153] + inter_xor_result[154] + inter_xor_result[155] + inter_xor_result[156] + inter_xor_result[157] + inter_xor_result[158] + inter_xor_result[159] + inter_xor_result[160] + inter_xor_result[161] + inter_xor_result[162] + inter_xor_result[163] + inter_xor_result[164] + inter_xor_result[165] + inter_xor_result[166] + inter_xor_result[167] + inter_xor_result[168] + inter_xor_result[169] + inter_xor_result[170] + inter_xor_result[171] + inter_xor_result[172] + inter_xor_result[173] + inter_xor_result[174] + inter_xor_result[175] + inter_xor_result[176] + inter_xor_result[177] + inter_xor_result[178] + inter_xor_result[179] + inter_xor_result[180] + inter_xor_result[181] + inter_xor_result[182] + inter_xor_result[183] + inter_xor_result[184] + inter_xor_result[185] + inter_xor_result[186] + inter_xor_result[187] + inter_xor_result[188] + inter_xor_result[189] + inter_xor_result[190] + inter_xor_result[191] + inter_xor_result[192] + inter_xor_result[193] + inter_xor_result[194] + inter_xor_result[195] + inter_xor_result[196] + inter_xor_result[197] + inter_xor_result[198] + inter_xor_result[199] + inter_xor_result[200] + inter_xor_result[201] + inter_xor_result[202] + inter_xor_result[203] + inter_xor_result[204] + inter_xor_result[205] + inter_xor_result[206] + inter_xor_result[207] + inter_xor_result[208] + inter_xor_result[209] + inter_xor_result[210] + inter_xor_result[211] + inter_xor_result[212] + inter_xor_result[213] + inter_xor_result[214] + inter_xor_result[215] + inter_xor_result[216] + inter_xor_result[217] + inter_xor_result[218] + inter_xor_result[219] + inter_xor_result[220] + inter_xor_result[221] + inter_xor_result[222] + inter_xor_result[223] + inter_xor_result[224] + inter_xor_result[225] + inter_xor_result[226] + inter_xor_result[227] + inter_xor_result[228] + inter_xor_result[229] + inter_xor_result[230] + inter_xor_result[231] + inter_xor_result[232] + inter_xor_result[233] + inter_xor_result[234] + inter_xor_result[235] + inter_xor_result[236] + inter_xor_result[237] + inter_xor_result[238] + inter_xor_result[239] + inter_xor_result[240] + inter_xor_result[241] + inter_xor_result[242] + inter_xor_result[243] + inter_xor_result[244] + inter_xor_result[245] + inter_xor_result[246] + inter_xor_result[247] + inter_xor_result[248] + inter_xor_result[249] + inter_xor_result[250] + inter_xor_result[251] + inter_xor_result[252] + inter_xor_result[253] + inter_xor_result[254] + inter_xor_result[255];
	
//    reg [9-1:0] inter_popcount_out;
//
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            inter_popcount_out <= 0;
//        end
//        else if (data_in_valid) begin
//            inter_popcount_out <= 0;
//            for (integer j = 0; j < 256; j = j + 1) begin
//                inter_popcount_out <= inter_popcount_out + inter_xor_result[j];
//            end
//        end
//    end

	reg data_out_valid_pre;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_out <= 0;
            data_out_valid_pre <= 0;
        end
        else if (data_in_valid) begin
            data_out <= inter_popcount_out; //(2*inter_popcount_out-256) > 0 ? 1 : 0;
            data_out_valid_pre <= 1;
        end
    end
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_out_valid <= 0;
        end
        else if (data_in_valid) begin
            data_out_valid <= 1;
        end
    end
endmodule
