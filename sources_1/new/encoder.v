`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/12 16:18:24
// Design Name: 
// Module Name: encoder
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


module encoder(
	input clk,
    input rst_n,
    
    input [16-1:0] data_in,
	input data_in_valid,
	input [2:0] block_sel,
	
	output [16-1:0] data_out,
	output data_out_valid,
	output done
    );
	
	// =========================================================================================================
	// ============================================Layer Norm===================================================
	// =========================================================================================================
    reg [4:0] ln_time_step_1_pre;
    reg [4:0] ln_time_step_1;
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			ln_time_step_1_pre <= 0;
		end
		else begin
			if (data_in_valid) begin
				ln_time_step_1_pre <= ln_time_step_1_pre + 1'b1;
			end
		end
	end

	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ln_time_step_1 <= 0;
        end
        else if (ln_time_step_1_pre <= 'd29) begin
            ln_time_step_1 <= ln_time_step_1_pre;
        end
    end
	
	reg [16-1:0] ln_1[30-1:0];
	wire [16-1:0] ln_1_out;
	wire ln_1_valid;
	wire ln_1_done;
	
	integer i,j;
	always@(posedge clk,negedge rst_n) begin
		if (~rst_n) begin
			for (i = 0; i < 30; i = i + 1) begin
				for (j = 0; j < 16; j = j + 1) begin
					ln_1[i][j] <= 0;
				end
			end
		end
		else if (~ln_1_done) begin
			ln_1[ln_time_step_1] <= ln_1_out;
		end
	end
	
	layer_norm_1 layer_norm_1(
		.clk			(clk),
		.rst_n			(rst_n),
		
		.data_in		(data_in),
		.data_in_valid	(data_in_valid),
		.block_sel		(block_sel),
		
		.data_out		(ln_1_out),
		.data_out_valid	(ln_1_valid),
		.done			(ln_1_done)
	);
	
	
	// =========================================================================================================
	// ==========================================Self Attention + Shortcut======================================
	// =========================================================================================================
    reg [4:0] attention_time_step_pre;
    reg [4:0] attention_time_step;
    reg [4:0] attention_time_step_out;
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            attention_time_step_pre <= 0;
        end
		else if (attention_time_step_pre == 'd29)
			attention_time_step_pre <= 'd29;
        else if (ln_1_done) begin
            attention_time_step_pre <= attention_time_step_pre + 1'b1;
        end
    end
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            attention_time_step <= 0;
        end
        else if (attention_time_step_pre <= 'd29) begin
            attention_time_step <= attention_time_step_pre;
        end
    end
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            attention_time_step_out <= 0;
        end
		else if (attention_time_step_out == 'd29)
			attention_time_step_out <= 'd29;
        else if (attention_valid) begin
            attention_time_step_out <= attention_time_step_out + 'd1;
        end
    end
	
	reg [16-1:0] attention[30-1:0];
	wire [16-1:0] attention_out;
	wire attention_valid;
	reg attention_done;
	
	always@(posedge clk,negedge rst_n) begin
		if (~rst_n) begin
			for (i = 0; i < 30; i = i + 1) begin
				for (j = 0; j < 16; j = j + 1) begin
					attention[i][j] <= 0;
				end
			end
		end
		else if (attention_valid) begin
			attention[attention_time_step_out] <= attention_out + ln_1[attention_time_step_out]; // shortcut
		end
	end
	
	always@(posedge clk,negedge rst_n) begin
		if (~rst_n) begin
			attention_done <= 0;
		end
		else if (attention_time_step_out == 'd29) begin
			attention_done <= 1;
		end
	end
	
	attention attention_U(
		.clk			(clk),
		.rst_n			(rst_n),
		
		.data_in		(ln_1[attention_time_step]),
		.data_in_valid	(ln_1_done),
		.block_sel		(block_sel),
		
		.data_out		(attention_out),
		.data_out_valid	(attention_valid)
    );
	
	
	// =========================================================================================================
	// ============================================Layer Norm===================================================
	// =========================================================================================================
    reg [4:0] ln_time_step_2_pre;
    reg [4:0] ln_time_step_2;
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ln_time_step_2_pre <= 0;
        end
		else if (ln_time_step_2_pre == 'd29)
			ln_time_step_2_pre <= 'd29;
        else if (attention_done) begin
            ln_time_step_2_pre <= ln_time_step_2_pre + 1'b1;
        end
    end
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ln_time_step_2 <= 0;
        end
        else if (ln_time_step_2_pre <= 'd29) begin
            ln_time_step_2 <= ln_time_step_2_pre;
        end
    end
	
	reg [16-1:0] ln_2[30-1:0];
	wire [16-1:0] ln_2_out;
	wire ln_2_valid;
	wire ln_2_done;
	
	always@(posedge clk,negedge rst_n) begin
		if (~rst_n) begin
			for (i = 0; i < 30; i = i + 1) begin
				for (j = 0; j < 16; j = j + 1) begin
					ln_2[i][j] <= 0;
				end
			end
		end
		else if (~ln_2_done) begin
			ln_2[ln_time_step_2] <= ln_2_out;
		end
	end
	
	layer_norm_2 layer_norm_2(
		.clk			(clk),
		.rst_n			(rst_n),
		
		.data_in		(attention[ln_time_step_2]),
		.data_in_valid	(attention_done),
		.block_sel		(block_sel),
		
		.data_out		(ln_2_out),
		.data_out_valid	(ln_2_valid),
		.done			(ln_2_done)
	);
	
	
	
	// =========================================================================================================
	// ============================================Hidden State 1===============================================
	// =========================================================================================================
    reg [4:0] hidden_state_1_time_step_pre;
    reg [4:0] hidden_state_1_time_step;
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            hidden_state_1_time_step_pre <= 0;
        end
		else if (hidden_state_1_time_step_pre == 'd29)
			hidden_state_1_time_step_pre <= 'd29;
        else if (ln_2_done) begin
            hidden_state_1_time_step_pre <= hidden_state_1_time_step_pre + 1'b1;
        end
    end
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            hidden_state_1_time_step <= 0;
        end
        else if (hidden_state_1_time_step_pre <= 'd29) begin
            hidden_state_1_time_step <= hidden_state_1_time_step_pre;
        end
    end
	
	reg [256-1:0] hd_1[30-1:0];
	wire [256-1:0] hd_1_out;
	wire hd_1_valid;
	wire hd_1_done;
	
	always@(posedge clk,negedge rst_n) begin
		if (~rst_n) begin
			for (i = 0; i < 30; i = i + 1) begin
				for (j = 0; j < 256; j = j + 1) begin
					hd_1[i][j] <= 0;
				end
			end
		end
		else if (~hd_1_done) begin
			hd_1[hidden_state_1_time_step] <= hd_1_out;
		end
	end
	
	encoder_hidden_state_1 encoder_hidden_state_1(
		.clk			(clk),
		.rst_n			(rst_n),
		
		.data_in		(ln_2[hidden_state_1_time_step]),
		.data_in_valid	(ln_2_done),
		.block_sel		(block_sel),
		
		.data_out		(hd_1_out),
		.data_out_valid	(hd_1_valid),
		.done			(hd_1_done)
    );
	
	// =========================================================================================================
	// ============================================Hidden State 2===============================================
	// =========================================================================================================
    reg [4:0] hidden_state_2_time_step_pre;
    reg [4:0] hidden_state_2_time_step;
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            hidden_state_2_time_step_pre <= 0;
        end
		else if (hidden_state_2_time_step_pre == 'd29)
			hidden_state_2_time_step_pre <= 'd29;
        else if (hd_1_done) begin
            hidden_state_2_time_step_pre <= hidden_state_2_time_step_pre + 1'b1;
        end
    end
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            hidden_state_2_time_step <= 0;
        end
        else if (hidden_state_2_time_step_pre <= 'd29) begin
            hidden_state_2_time_step <= hidden_state_2_time_step_pre;
        end
    end
	
	reg [16-1:0] hd_2[30-1:0];
	wire [16-1:0] hd_2_out;
	wire hd_2_valid;
	wire hd_2_done;
	
	always@(posedge clk,negedge rst_n) begin
		if (~rst_n) begin
			for (i = 0; i < 30; i = i + 1) begin
				for (j = 0; j < 16; j = j + 1) begin
					hd_2[i][j] <= 0;
				end
			end
		end
		else if (~hd_2_done) begin
			hd_2[hidden_state_2_time_step] <= hd_2_out + ln_2[hidden_state_2_time_step]; // shortcut
		end
	end
	
	encoder_hidden_state_2 encoder_hidden_state_2(
		.clk			(clk),
		.rst_n			(rst_n),
		
		.data_in		(hd_1[hidden_state_2_time_step]),
		.data_in_valid	(hd_1_done),
		.block_sel		(block_sel),
		
		.data_out		(hd_2_out),
		.data_out_valid	(hd_2_valid),
		.done			(hd_2_done)
    );
	
	// =========================================================================================================
	// ============================================Layer Norm===================================================
	// =========================================================================================================
    reg [4:0] ln_time_step_3_pre;
    reg [4:0] ln_time_step_3;
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ln_time_step_3_pre <= 0;
        end
		else if (ln_time_step_3_pre == 'd29)
			ln_time_step_3_pre <= 'd29;
        else if (hd_2_done) begin
            ln_time_step_3_pre <= ln_time_step_3_pre + 1'b1;
        end
    end
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ln_time_step_3 <= 0;
        end
        else if (ln_time_step_3_pre <= 'd29) begin
            ln_time_step_3 <= ln_time_step_3_pre;
        end
    end
	
//	reg [16-1:0] ln_3[30-1:0];
//	wire [16-1:0] ln_3_out;
	wire ln_3_valid;
	wire ln_3_done;
	
//	integer i,j;
//	always@(posedge clk,negedge rst_n) begin
//		if (~rst_n) begin
//			for (i = 0; i < 30; i = i + 1) begin
//				for (j = 0; j < 16; j = j + 1) begin
//					ln_3[i][j] <= 0;
//				end
//			end
//		end
//		else if (~ln_3_done) begin
//			ln_3[ln_time_step_3] <= ln_3_out;
//		end
//	end
	
	layer_norm_3 layer_norm_3(
		.clk			(clk),
		.rst_n			(rst_n),
		
		.data_in		(hd_2[ln_time_step_3]),
		.data_in_valid	(hd_2_done),
		.block_sel		(block_sel),
		
		.data_out		(data_out),
		.data_out_valid	(data_out_valid),
		.done			(done)
	);
	
	
	
	
	
	
endmodule
