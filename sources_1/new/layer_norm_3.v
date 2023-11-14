`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 14:59:41
// Design Name: 
// Module Name: layer_norm_3
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


module layer_norm_3(
	input clk,
    input rst_n,
    
    input [16-1:0] data_in,
	input data_in_valid,
	input [2:0] block_sel,
	
	output [16-1:0] data_out,
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
	
	wire [30*8-1:0] alpha;
	wire [30*8-1:0] beta;
	wire [2:0] sel = block_sel;
	
	alpha_rom_3 alpha_rom_3 (
	  .clka(clk),    // input wire clka
	  .ena(data_in_valid),      // input wire ena
	  .addra(sel),  // input wire [2 : 0] addra
	  .douta(alpha)  // output wire [719 : 0] douta
	);
	
	beta_rom_3 beta_rom_3 (
	  .clka(clk),    // input wire clka
	  .ena(data_in_valid),      // input wire ena
	  .addra(sel),  // input wire [2 : 0] addra
	  .douta(beta)  // output wire [719 : 0] douta
	);
	
	genvar i;
	generate
		for (i = 0; i < 16; i = i + 1) begin
			wire signed [8-1:0] alpha_i = alpha[time_step*8 +: 8];
			wire signed [8-1:0] beta_i = beta[time_step*8 +: 8];
			
//			always@(posedge clk or negedge rst_n) begin
//				if (~rst_n) begin
//					data_out[i] <= 0;
//				end
//				else if (data_in_valid) begin
//					data_out[i] <= (data_in[i] * alpha_i + beta_i) > 0 ? 1 : 0;
//				end
//			end
			assign data_out[i] = (data_in[i] * alpha_i + beta_i) > 0 ? 1 : 0;
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
