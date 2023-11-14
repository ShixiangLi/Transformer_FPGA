`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 21:56:19
// Design Name: 
// Module Name: binary_score
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


module binary_score(
	input clk,
    input rst_n,
    
    input [16-1:0] query_in,
    input [30*16-1:0] key_in,
	input data_in_valid,
	
	output [30-1:0] data_out_1,
	output [30-1:0] data_out_2,
	output [30-1:0] data_out_3,
	output [30-1:0] data_out_4,
	output reg data_out_valid,
	output reg done
    );
	
	wire [3-1:0] threshold = 'd4; // Bool Function
	
	reg [4:0] time_step;

	always@(posedge clk,negedge rst_n)begin
		if(~rst_n)
			time_step <= 0;
		else if(data_in_valid==1'b1)
			time_step <= time_step +1'b1;
	end
	
	/*
	* Head 1
	*/
	genvar i_1;
	integer j_1;
	generate
		for (i_1 = 0; i_1 < 30; i_1 = i_1 + 1) begin
			wire [3:0] score_xor_result_1 = ~(key_in[i_1*16 +: 4] ^ query_in[3:0]);
			
			wire [2:0] score_popcount_out_1 = score_xor_result_1[0] + score_xor_result_1[1] + score_xor_result_1[2] + score_xor_result_1[3];

			// 计算POPCOUNT
//			reg [2:0] score_popcount_out_1;
//			
//			always@(posedge clk or negedge rst_n) begin
//				if (~rst_n) begin
//					score_popcount_out_1 <= 0;
//				end
//				else if (data_in_valid) begin
//					for (j_1 = 0; j_1 < 4; j_1 = j_1 + 1) begin
//						score_popcount_out_1 = score_popcount_out_1 + score_xor_result_1[j_1];
//					end
//				end
//			end
			
			assign data_out_1[i_1] = ((2*score_popcount_out_1-threshold) > 0 && data_in_valid) ? 1 : 0;
		end
	endgenerate

	
	/*
	* Head 2
	*/
	genvar i_2;
	integer j_2;
	generate
		for (i_2 = 0; i_2 < 30; i_2 = i_2 + 1) begin
			wire [3:0] score_xor_result_2 = key_in[i_2*16+4 +: 4] ^ query_in[7:4];

			// 计算POPCOUNT
			reg [2:0] score_popcount_out_2;
			
			always@(posedge clk or negedge rst_n) begin
				if (~rst_n) begin
					score_popcount_out_2 <= 0;
				end
				else if (data_in_valid) begin
					for (j_2 = 0; j_2 < 4; j_2 = j_2 + 1) begin
						score_popcount_out_2 = score_popcount_out_2 + score_xor_result_2[j_2];
					end
				end
			end
			
			assign data_out_2[i_2] = ((2*score_popcount_out_2-threshold) > 0 && data_in_valid) ? 1 : 0;
		end
	endgenerate
	
	/*
	* Head 3
	*/
	genvar i_3;
	integer j_3;
	generate
		for (i_3 = 0; i_3 < 30; i_3 = i_3 + 1) begin
			wire [3:0] score_xor_result_3 = key_in[i_3*16+8 +: 4] ^ query_in[11:8];

			// 计算POPCOUNT
			reg [2:0] score_popcount_out_3;
			
			always@(posedge clk or negedge rst_n) begin
				if (~rst_n) begin
					score_popcount_out_3 <= 0;
				end
				else if (data_in_valid) begin
					for (j_3 = 0; j_3 < 4; j_3 = j_3 + 1) begin
						score_popcount_out_3 = score_popcount_out_3 + score_xor_result_3[j_3];
					end
				end
			end
			
			assign data_out_3[i_3] = ((2*score_popcount_out_3-threshold) > 0 && data_in_valid) ? 1 : 0;
		end
	endgenerate
	
	/*
	* Head 4
	*/
	genvar i_4;
	integer j_4;
	generate
		for (i_4 = 0; i_4 < 30; i_4 = i_4 + 1) begin
			wire [3:0] score_xor_result_4 = key_in[i_4*16+12 +: 4] ^ query_in[15:12];

			// 计算POPCOUNT
			reg [2:0] score_popcount_out_4;
			
			always@(posedge clk or negedge rst_n) begin
				if (~rst_n) begin
					score_popcount_out_4 <= 0;
				end
				else if (data_in_valid) begin
					for (j_4 = 0; j_4 < 4; j_4 = j_4 + 1) begin
						score_popcount_out_4 = score_popcount_out_4 + score_xor_result_4[j_4];
					end
				end
			end
			
			assign data_out_4[i_4] = ((2*score_popcount_out_4-threshold) > 0 && data_in_valid) ? 1 : 0;
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
		else if (time_step == 5'd29)
			data_out_valid <= 1;
	end
	
endmodule
