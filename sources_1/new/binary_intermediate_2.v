`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/12 11:42:35
// Design Name: 
// Module Name: binary_intermediate_2
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


module binary_intermediate_2(
    input clk,
    input rst_n,
    
    input [64-1:0] data_in,
	input data_in_valid,
	input wire [2-1:0] block_sel,
	
	output reg [16-1:0] data_out,
	output reg data_out_valid,
	output reg done
    );
	
    reg [4:0] time_step_pre;
    reg [4:0] time_step; // 添加一个寄存器用于延迟
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            time_step_pre <= 0;
        end
		else if (time_step_pre == 'd29)
			time_step_pre <= 'd29;
        else if (data_in_valid) begin
            time_step_pre <= time_step_pre + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            time_step <= 0;
        end
        else if (time_step_pre <= 'd29) begin
            time_step <= time_step_pre;
        end
    end
	
	wire [16*64-1:0] inter_w_data;
	wire [2:0] sel = block_sel;
	attention_intermediate_2 attention_intermediate_2 (
	  .clka(clk),    // input wire clka
	  .ena(data_in_valid),      // input wire ena
	  .addra(sel),  // input wire [2 : 0] addra
	  .douta(inter_w_data)  // output wire [1023 : 0] douta
	);
	
	genvar i;
	integer j;

	generate
		for (i = 0; i < 16; i = i + 1) begin
			wire [63:0] inter_xor_result = ~(inter_w_data[i*64 +: 64] ^ data_in);
			
			wire [6:0] inter_popcount_out = inter_xor_result[0] + inter_xor_result[1] + inter_xor_result[2] + inter_xor_result[3] + inter_xor_result[4] + inter_xor_result[5] + inter_xor_result[6] + inter_xor_result[7] + inter_xor_result[8] + inter_xor_result[9] + inter_xor_result[10] + inter_xor_result[11] + inter_xor_result[12] + inter_xor_result[13] + inter_xor_result[14] + inter_xor_result[15] + inter_xor_result[16] + inter_xor_result[17] + inter_xor_result[18] + inter_xor_result[19] + inter_xor_result[20] + inter_xor_result[21] + inter_xor_result[22] + inter_xor_result[23] + inter_xor_result[24] + inter_xor_result[25] + inter_xor_result[26] + inter_xor_result[27] + inter_xor_result[28] + inter_xor_result[29] + inter_xor_result[30] + inter_xor_result[31] + inter_xor_result[32] + inter_xor_result[33] + inter_xor_result[34] + inter_xor_result[35] + inter_xor_result[36] + inter_xor_result[37] + inter_xor_result[38] + inter_xor_result[39] + inter_xor_result[40] + inter_xor_result[41] + inter_xor_result[42] + inter_xor_result[43] + inter_xor_result[44] + inter_xor_result[45] + inter_xor_result[46] + inter_xor_result[47] + inter_xor_result[48] + inter_xor_result[49] + inter_xor_result[50] + inter_xor_result[51] + inter_xor_result[52] + inter_xor_result[53] + inter_xor_result[54] + inter_xor_result[55] + inter_xor_result[56] + inter_xor_result[57] + inter_xor_result[58] + inter_xor_result[59] + inter_xor_result[60] + inter_xor_result[61] + inter_xor_result[62] + inter_xor_result[63];
			
//			reg [6:0] inter_popcount_out;
//
//			always@(posedge clk or negedge rst_n) begin
//				if (~rst_n) begin
//					inter_popcount_out <= 0;
//				end
//				else if (data_in_valid) begin
//					for (j = 0; j < 64; j = j + 1) begin
//						inter_popcount_out <= inter_popcount_out + inter_xor_result[j];
//					end
//				end
//			end
			
			always@(posedge clk or negedge rst_n) begin
				if (~rst_n) begin
					data_out[i] <= 0;
				end
				else if (data_in_valid) begin
					data_out[i] <= (2*inter_popcount_out-64) > 0 ? 1 : 0;
				end
			end
		end
	endgenerate
	

	
	always@(posedge clk,negedge rst_n)begin
		if(~rst_n)
			done <= 0;
		else if (time_step == 5'd29)
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
