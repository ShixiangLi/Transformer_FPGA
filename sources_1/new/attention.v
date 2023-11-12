`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 16:23:40
// Design Name: 
// Module Name: attention
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


module attention(
	input clk,
    input rst_n,
    
    input [16-1:0] data_in,
	input data_in_valid,
	input [2:0] block_sel,
	
	output [16-1:0] data_out,
	output data_out_valid
    );
	// =========================================================================================================
	// =====================================Get Query Key Value=================================================
	// =========================================================================================================
	
	/*
	* time_step计数，也是qkv的时间步坐标
	*/
	
    reg [4:0] qkv_time_step_pre;
    reg [4:0] qkv_time_step; // 添加一个寄存器用于延迟
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            qkv_time_step_pre <= 0;
        end
		else if (qkv_time_step_pre == 'd29)
			qkv_time_step_pre <= 'd29;
        else if (data_in_valid) begin
            qkv_time_step_pre <= qkv_time_step_pre + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            qkv_time_step <= 0;
        end
        else if (qkv_time_step_pre <= 'd29) begin
            qkv_time_step <= qkv_time_step_pre;
        end
    end
	
	/*
	* QKV数组赋值：30x16
	*/
	reg [16-1:0] query[30-1:0];
	reg [16-1:0] key[30-1:0];
	reg [16-1:0] value[30-1:0];
	wire [16-1:0] query_out;
	wire [16-1:0] key_out;
	wire [16-1:0] value_out;
	wire qkv_data_valid;
	wire qkv_done;
	
	integer i,j;
	always@(posedge clk,negedge rst_n) begin
		if (~rst_n) begin
			for (i = 0; i < 30; i = i + 1) begin
				for (j = 0; j < 16; j = j + 1) begin
					query[i][j] <= 0;
					key[i][j] <= 0;
					value[i][j] <= 0;
				end
			end
		end
		else if (~qkv_done) begin
			query[qkv_time_step] <= query_out;
			key[qkv_time_step] <= key_out;
			value[qkv_time_step] <= value_out;
		end
	end

	/*
	* QKV实例化，得到QKV的结果
	*/
	binary_QKV binary_QKV(
		.clk			(clk),
		.rst_n			(rst_n),

		.data_in		(data_in),
		.data_in_valid	(data_in_valid),
		.block_sel		(block_sel),

		.query_out		(query_out),
		.key_out		(key_out),
		.value_out		(value_out),
		.data_out_valid	(qkv_data_valid),
		.done			(qkv_done)
    );
	
	// =========================================================================================================
	// =====================================Get Attention Scores================================================
	// =========================================================================================================
	reg [4:0] score_time_step;
	always@(posedge clk,negedge rst_n)begin
		if(~rst_n)
			score_time_step <= 0;
		else if (score_time_step == 'd29)
			score_time_step <= 'd29;
		else if (qkv_done==1'b1)
			score_time_step <= score_time_step +1'b1;
	end
	
	wire [30*16-1:0] key_flatten;
	genvar k;
	generate
		for (k=0;k<30;k=k+1)begin
			assign key_flatten[k*16 +: 16] = key[k];
		end
	endgenerate
	
	reg [30-1:0] score_out_1[30-1:0];
	reg [30-1:0] score_out_2[30-1:0];
	reg [30-1:0] score_out_3[30-1:0];
	reg [30-1:0] score_out_4[30-1:0];
	wire [30-1:0] score_1;
	wire [30-1:0] score_2;
	wire [30-1:0] score_3;
	wire [30-1:0] score_4;
	wire score_out_valid;
	wire score_done;
	
	always@(posedge clk,negedge rst_n) begin
		if (~rst_n) begin
			score_out_1[score_time_step] <= 0;
			score_out_2[score_time_step] <= 0;
			score_out_3[score_time_step] <= 0;
			score_out_4[score_time_step] <= 0;
		end
		else if (qkv_done) begin
			score_out_1[score_time_step] <= score_1;
			score_out_2[score_time_step] <= score_2;
			score_out_3[score_time_step] <= score_3;
			score_out_4[score_time_step] <= score_4;
		end
	end
	
	binary_score binary_score(
		.clk			(clk),
		.rst_n			(rst_n),

		.query_in		(query[score_time_step]),
		.key_in         (key_flatten),
		.data_in_valid	(qkv_done),

		.data_out_1		(score_1),
		.data_out_2		(score_2),
		.data_out_3		(score_3),
		.data_out_4		(score_4),
		.data_out_valid	(score_out_valid),
		.done			(score_done)
    );
	
	// =========================================================================================================
	// =====================================Get Weighted Value==================================================
	// =========================================================================================================
	wire [30*16-1:0] value_flatten;
	genvar l;
	generate
		for (k=0;k<16;k=k+1)begin
			for (l=0;l<30;l=l+1)begin
				assign value_flatten[k*30+l] = value[l][k];
			end
		end
	endgenerate
	
	reg [4:0] value_time_step;
	always@(posedge clk,negedge rst_n)begin
		if(~rst_n)
			value_time_step <= 0;
		else if (value_time_step == 'd29)
			value_time_step <= 'd29;
		else if (score_done==1'b1)
			value_time_step <= value_time_step +1'b1;
	end
	
	reg [16-1:0] value_weighted[30-1:0];
	wire [16-1:0] value_weighted_out;
	wire value_weighted_valid;
	wire value_weighted_done;
	
	always@(posedge clk,negedge rst_n) begin
		if (~rst_n) begin
			value_weighted[value_time_step] <= 0;
		end
		else if (score_done) begin
			value_weighted[value_time_step] <= value_weighted_out;
		end
	end
	
	binary_query binary_query(
		.clk			(clk),
		.rst_n			(rst_n),

		.value_in		(value_flatten),
		.score_in_1		(score_out_1[value_time_step]),
		.score_in_2		(score_out_2[value_time_step]),
		.score_in_3		(score_out_3[value_time_step]),
		.score_in_4		(score_out_4[value_time_step]),
		.data_in_valid	(score_done),

		.data_out		(value_weighted_out),
		.data_out_valid	(value_weighted_valid),
		.done			(value_weighted_done)
    );
	
	// =========================================================================================================
	// =====================================Get Intermediate 1==================================================
	// =========================================================================================================

	
    reg [4:0] inter_1_time_step_pre;
    reg [4:0] inter_1_time_step; // 添加一个寄存器用于延迟
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            inter_1_time_step_pre <= 0;
        end
		else if (inter_1_time_step_pre == 'd29)
			inter_1_time_step_pre <= 'd29;
        else if (value_weighted_done) begin
            inter_1_time_step_pre <= inter_1_time_step_pre + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            inter_1_time_step <= 0;
        end
        else if (inter_1_time_step_pre <= 'd29) begin
            inter_1_time_step <= inter_1_time_step_pre;
        end
    end
	
	reg [64-1:0] attention_inter_1[30-1:0];
	wire [64-1:0] attention_inter_1_out;
	wire attention_inter_1_valid;
	wire attention_inter_1_done;
	
	always@(posedge clk,negedge rst_n) begin
		if (~rst_n) begin
			for (i = 0; i < 30; i = i + 1) begin
				for (j = 0; j < 64; j = j + 1) begin
					attention_inter_1[i][j] <= 0;
				end
			end
		end
		else if (~attention_inter_1_done) begin
			attention_inter_1[inter_1_time_step] <= attention_inter_1_out;
		end
	end
	
	binary_intermediate_1 binary_intermediate_1(
		.clk			(clk),
		.rst_n			(rst_n),

		.data_in		(value_weighted[inter_1_time_step]),
		.data_in_valid	(value_weighted_done),
		.block_sel		(block_sel),

		.data_out		(attention_inter_1_out),
		.data_out_valid	(attention_inter_1_valid),
		.done			(attention_inter_1_done)
		);
		
	// =========================================================================================================
	// =====================================Get Intermediate 2==================================================
	// =========================================================================================================

	
    reg [4:0] inter_2_time_step_pre;
    reg [4:0] inter_2_time_step; // 添加一个寄存器用于延迟
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            inter_2_time_step_pre <= 0;
        end
		else if (inter_2_time_step_pre == 'd29)
			inter_2_time_step_pre <= 'd29;
        else if (attention_inter_1_done) begin
            inter_2_time_step_pre <= inter_2_time_step_pre + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            inter_2_time_step <= 0;
        end
        else if (inter_2_time_step_pre <= 'd29) begin
            inter_2_time_step <= inter_2_time_step_pre;
        end
    end
	
	reg [16-1:0] attention_inter_2[30-1:0];
	wire [16-1:0] attention_inter_2_out;
	wire attention_inter_2_valid;
	wire attention_inter_2_done;
	
	always@(posedge clk,negedge rst_n) begin
		if (~rst_n) begin
			for (i = 0; i < 30; i = i + 1) begin
				for (j = 0; j < 16; j = j + 1) begin
					attention_inter_2[i][j] <= 0;
				end
			end
		end
		else if (~attention_inter_2_done) begin
			attention_inter_2[inter_2_time_step] <= attention_inter_2_out;
		end
	end
	
	binary_intermediate_2 binary_intermediate_2(
		.clk			(clk),
		.rst_n			(rst_n),

		.data_in		(attention_inter_1[inter_2_time_step]),
		.data_in_valid	(attention_inter_1_done),
		.block_sel		(block_sel),

		.data_out		(data_out), // attention_inter_2_out
		.data_out_valid	(attention_inter_2_valid), // 
		.done			(data_out_valid) // attention_inter_2_done
		);
	
	
endmodule
