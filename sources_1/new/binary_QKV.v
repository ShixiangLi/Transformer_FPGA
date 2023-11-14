`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/09 11:24:47
// Design Name: 
// Module Name: binary_QKV
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


module binary_QKV(
    input clk,
    input rst_n,
    
    input [16-1:0] data_in,
	input data_in_valid,
	input wire [2:0] block_sel,
	
	output reg [16-1:0] query_out,
	output reg [16-1:0] key_out,
	output reg [16-1:0] value_out,
	output reg data_out_valid,
	output reg done
    );

    reg [4:0] time_step_pre;
    reg [4:0] time_step; // 添加�?个寄存器用于延迟
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            time_step_pre <= 0;
        end
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
	
	wire [16*16*3-1:0] qkv_w_data;
	wire [2:0] sel = block_sel;
	qkv_w_rom qkv_w_rom (
	  .clka(clk),    // input wire clka
	  .ena(data_in_valid),      // input wire ena
	  .addra(sel),  // input wire [2 : 0] addra
	  .douta(qkv_w_data)  // output wire [767 : 0] douta
	);

	genvar i;
	integer j;

	generate
		for (i = 0; i < 16; i = i + 1) begin
			wire [15:0] query_xor_result = ~(qkv_w_data[i*16 +: 16] ^ data_in);
			wire [15:0] key_xor_result = ~(qkv_w_data[i*16+256 +: 16] ^ data_in);
			wire [15:0] value_xor_result = ~(qkv_w_data[i*16+512 +: 16] ^ data_in);
			
			wire [4:0] query_popcount_out = query_xor_result[0] + query_xor_result[1] + query_xor_result[2] + query_xor_result[3] + query_xor_result[4] + query_xor_result[5] + query_xor_result[6] + query_xor_result[7] + query_xor_result[8] + query_xor_result[9] + query_xor_result[10] + query_xor_result[11] + query_xor_result[12] + query_xor_result[13] + query_xor_result[14] + query_xor_result[15];
			wire [4:0] key_popcount_out = key_xor_result[0] + key_xor_result[1] + key_xor_result[2] + key_xor_result[3] + key_xor_result[4] + key_xor_result[5] + key_xor_result[6] + key_xor_result[7] + key_xor_result[8] + key_xor_result[9] + key_xor_result[10] + key_xor_result[11] + key_xor_result[12] + key_xor_result[13] + key_xor_result[14] + key_xor_result[15];
			wire [4:0] value_popcount_out = value_xor_result[0] + value_xor_result[1] + value_xor_result[2] + value_xor_result[3] + value_xor_result[4] + value_xor_result[5] + value_xor_result[6] + value_xor_result[7] + value_xor_result[8] + value_xor_result[9] + value_xor_result[10] + value_xor_result[11] + value_xor_result[12] + value_xor_result[13] + value_xor_result[14] + value_xor_result[15];
			
			
			
//			reg [4:0] query_popcount_out;
//			reg [4:0] key_popcount_out;
//			reg [4:0] value_popcount_out;
//
//			always@(posedge clk or negedge rst_n) begin
//				if (~rst_n) begin
//					query_popcount_out <= 0;
//					key_popcount_out <= 0;
//					value_popcount_out <= 0;
//				end
//				else if (data_in_valid) begin
//					for (j = 0; j < 16; j = j + 1) begin
//						query_popcount_out <= query_popcount_out + query_xor_result[j];
//						key_popcount_out <= key_popcount_out + key_xor_result[j];
//						value_popcount_out <= value_popcount_out + value_xor_result[j];
//					end
//				end
//			end
			
			always@(posedge clk or negedge rst_n) begin
				if (~rst_n) begin
					query_out[i] <= 0;
					key_out[i] <= 0;
					value_out[i] <= 0;
				end
				else if (data_in_valid) begin
					query_out[i] <= (2*query_popcount_out-16) >= 0 ? 1 : 0;
					key_out[i] <= (2*key_popcount_out-16) >= 0 ? 1 : 0;
					value_out[i] <= (2*value_popcount_out-16) >= 0 ? 1 : 0;
				end
			end
			
			//assign query_out[i] = ((2*query_popcount_out-16) && data_in_valid) > 0 ? 1 : 0;
			//assign key_out[i] = ((2*key_popcount_out-16) && data_in_valid) > 0 ? 1 : 0;
			//assign value_out[i] = ((2*value_popcount_out-16) && data_in_valid) > 0 ? 1 : 0;
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
