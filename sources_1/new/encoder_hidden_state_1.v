`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 09:43:10
// Design Name: 
// Module Name: encoder_hidden_state_1
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


module encoder_hidden_state_1(
    input clk,
    input rst_n,
    
    input [16-1:0] data_in,
	input data_in_valid,
	input wire [2-1:0] block_sel,
	
	output reg [256-1:0] data_out,
	output reg data_out_valid,
	output reg done
    );
	
    reg [4:0] time_step_pre;
    reg [4:0] time_step; // 添加一个寄存器用于延迟
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            time_step_pre <= 0;
        end
		else if (time_step_pre == 'd29) begin
            time_step_pre <= 'd29;
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
	
	
	wire [16*256-1:0] inter_w_data;
	wire [2:0] sel = block_sel;
	encoder_hidden_state_1_rom encoder_hidden_state_1_rom (
	  .clka(clk),    // input wire clka
	  .ena(data_in_valid),      // input wire ena
	  .addra(sel),  // input wire [2 : 0] addra
	  .douta(inter_w_data)  // output wire [4095 : 0] douta
	);
	
	genvar i;
	integer j;

	generate
		for (i = 0; i < 256; i = i + 1) begin
			wire [15:0] inter_xor_result = ~(inter_w_data[i*16 +: 16] ^ data_in);
			
			wire [4:0] inter_popcount_out = inter_xor_result[0] + inter_xor_result[1] + inter_xor_result[2] + inter_xor_result[3] + inter_xor_result[4] + inter_xor_result[5] + inter_xor_result[6] + inter_xor_result[7] + inter_xor_result[8] + inter_xor_result[9] + inter_xor_result[10] + inter_xor_result[11] + inter_xor_result[12] + inter_xor_result[13] + inter_xor_result[14] + inter_xor_result[15];
			
//			reg [4:0] inter_popcount_out;
//
//			always@(posedge clk or negedge rst_n) begin
//				if (~rst_n) begin
//					inter_popcount_out <= 0;
//				end
//				else if (data_in_valid) begin
//					for (j = 0; j < 16; j = j + 1) begin
//						inter_popcount_out <= inter_popcount_out + inter_xor_result[j];
//					end
//				end
//			end
			
			always@(posedge clk or negedge rst_n) begin
				if (~rst_n) begin
					data_out[i] <= 0;
				end
				else if (data_in_valid) begin
					data_out[i] <= (2*inter_popcount_out-16) > 0 ? 1 : 0;
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
