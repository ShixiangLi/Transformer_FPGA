`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/11 22:33:54
// Design Name: 
// Module Name: binary_query
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


module binary_query(
	input clk,
    input rst_n,
    
    input [16*30-1:0] value_in,
    input [30-1:0] score_in_1,
    input [30-1:0] score_in_2,
    input [30-1:0] score_in_3,
    input [30-1:0] score_in_4,
	input data_in_valid,
	
	output reg [16-1:0] data_out,
	output reg data_out_valid,
	output reg done
    );
	
	reg [4:0] time_step;

	always@(posedge clk,negedge rst_n)begin
		if(~rst_n)
			time_step <= 0;
		else if(data_in_valid==1'b1)
			time_step <= time_step +1'b1;
	end
	
	integer j;
	wire [29:0] value_xor_result_1_1 = value_in[0*30 +: 30] ^ score_in_1;
	wire [29:0] value_xor_result_1_2 = value_in[1*30 +: 30] ^ score_in_1;
	wire [29:0] value_xor_result_1_3 = value_in[2*30 +: 30] ^ score_in_1;
	wire [29:0] value_xor_result_1_4 = value_in[3*30 +: 30] ^ score_in_1;
	wire [29:0] value_xor_result_2_1 = value_in[4*30 +: 30] ^ score_in_2;
	wire [29:0] value_xor_result_2_2 = value_in[5*30 +: 30] ^ score_in_2;
	wire [29:0] value_xor_result_2_3 = value_in[6*30 +: 30] ^ score_in_2;
	wire [29:0] value_xor_result_2_4 = value_in[7*30 +: 30] ^ score_in_2;
	wire [29:0] value_xor_result_3_1 = value_in[8*30 +: 30] ^ score_in_3;
	wire [29:0] value_xor_result_3_2 = value_in[9*30 +: 30] ^ score_in_3;
	wire [29:0] value_xor_result_3_3 = value_in[10*30 +: 30] ^ score_in_3;
	wire [29:0] value_xor_result_3_4 = value_in[11*30 +: 30] ^ score_in_3;
	wire [29:0] value_xor_result_4_1 = value_in[12*30 +: 30] ^ score_in_4;
	wire [29:0] value_xor_result_4_2 = value_in[13*30 +: 30] ^ score_in_4;
	wire [29:0] value_xor_result_4_3 = value_in[14*30 +: 30] ^ score_in_4;
	wire [29:0] value_xor_result_4_4 = value_in[15*30 +: 30] ^ score_in_4;
	
	reg [8:0] value_popcount_out_1_1;
	reg [8:0] value_popcount_out_1_2;
	reg [8:0] value_popcount_out_1_3;
	reg [8:0] value_popcount_out_1_4;
	reg [8:0] value_popcount_out_2_1;
	reg [8:0] value_popcount_out_2_2;
	reg [8:0] value_popcount_out_2_3;
	reg [8:0] value_popcount_out_2_4;
	reg [8:0] value_popcount_out_3_1;
	reg [8:0] value_popcount_out_3_2;
	reg [8:0] value_popcount_out_3_3;
	reg [8:0] value_popcount_out_3_4;
	reg [8:0] value_popcount_out_4_1;
	reg [8:0] value_popcount_out_4_2;
	reg [8:0] value_popcount_out_4_3;
	reg [8:0] value_popcount_out_4_4;

	always@(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			value_popcount_out_1_1 <= 0;
			value_popcount_out_1_2 <= 0;
			value_popcount_out_1_3 <= 0;
			value_popcount_out_1_4 <= 0;
			value_popcount_out_2_1 <= 0;
			value_popcount_out_2_2 <= 0;
			value_popcount_out_2_3 <= 0;
			value_popcount_out_2_4 <= 0;
			value_popcount_out_3_1 <= 0;
			value_popcount_out_3_2 <= 0;
			value_popcount_out_3_3 <= 0;
			value_popcount_out_3_4 <= 0;
			value_popcount_out_4_1 <= 0;
			value_popcount_out_4_2 <= 0;
			value_popcount_out_4_3 <= 0;
			value_popcount_out_4_4 <= 0;
		end
		else if (data_in_valid) begin
			for (j = 0; j < 30; j = j + 1) begin
				value_popcount_out_1_1 <= value_popcount_out_1_1 + value_xor_result_1_1[j];
				value_popcount_out_1_2 <= value_popcount_out_1_2 + value_xor_result_1_2[j];
				value_popcount_out_1_3 <= value_popcount_out_1_3 + value_xor_result_1_3[j];
				value_popcount_out_1_4 <= value_popcount_out_1_4 + value_xor_result_1_4[j];
				value_popcount_out_2_1 <= value_popcount_out_2_1 + value_xor_result_2_1[j];
				value_popcount_out_2_2 <= value_popcount_out_2_2 + value_xor_result_2_2[j];
				value_popcount_out_2_3 <= value_popcount_out_2_3 + value_xor_result_2_3[j];
				value_popcount_out_2_4 <= value_popcount_out_2_4 + value_xor_result_2_4[j];
				value_popcount_out_3_1 <= value_popcount_out_3_1 + value_xor_result_3_1[j];
				value_popcount_out_3_2 <= value_popcount_out_3_2 + value_xor_result_3_2[j];
				value_popcount_out_3_3 <= value_popcount_out_3_3 + value_xor_result_3_3[j];
				value_popcount_out_3_4 <= value_popcount_out_3_4 + value_xor_result_3_4[j];
				value_popcount_out_4_1 <= value_popcount_out_4_1 + value_xor_result_4_1[j];
				value_popcount_out_4_2 <= value_popcount_out_4_2 + value_xor_result_4_2[j];
				value_popcount_out_4_3 <= value_popcount_out_4_3 + value_xor_result_4_3[j];
				value_popcount_out_4_4 <= value_popcount_out_4_4 + value_xor_result_4_4[j];
			end
		end
	end
	
	always@(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			data_out <= 0;
		end
		else if (data_in_valid) begin
			data_out[0]  <= (2*value_popcount_out_1_1-30) > 0 ? 1 : 0;
			data_out[1]  <= (2*value_popcount_out_1_2-30) > 0 ? 1 : 0;
			data_out[2]  <= (2*value_popcount_out_1_3-30) > 0 ? 1 : 0;
			data_out[3]  <= (2*value_popcount_out_1_4-30) > 0 ? 1 : 0;
			data_out[4]  <= (2*value_popcount_out_2_1-30) > 0 ? 1 : 0;
			data_out[5]  <= (2*value_popcount_out_2_2-30) > 0 ? 1 : 0;
			data_out[6]  <= (2*value_popcount_out_2_3-30) > 0 ? 1 : 0;
			data_out[7]  <= (2*value_popcount_out_2_4-30) > 0 ? 1 : 0;
			data_out[8]  <= (2*value_popcount_out_3_1-30) > 0 ? 1 : 0;
			data_out[9]  <= (2*value_popcount_out_3_2-30) > 0 ? 1 : 0;
			data_out[10] <= (2*value_popcount_out_3_3-30) > 0 ? 1 : 0;
			data_out[11] <= (2*value_popcount_out_3_4-30) > 0 ? 1 : 0;
			data_out[12] <= (2*value_popcount_out_4_1-30) > 0 ? 1 : 0;
			data_out[13] <= (2*value_popcount_out_4_2-30) > 0 ? 1 : 0;
			data_out[14] <= (2*value_popcount_out_4_3-30) > 0 ? 1 : 0;
			data_out[15] <= (2*value_popcount_out_4_4-30) > 0 ? 1 : 0;
		end
	end
	
	always@(posedge clk,negedge rst_n)begin
		if(~rst_n)
			data_out_valid <= 0;
		else if (data_in_valid)
			data_out_valid <= 1;
		else 
			data_out_valid <= 0;
	end
	
	always@(posedge clk,negedge rst_n)begin
		if(~rst_n)
			done <= 0;
		else if (time_step == 5'd29)
			done <= 1;
	end
	
endmodule
