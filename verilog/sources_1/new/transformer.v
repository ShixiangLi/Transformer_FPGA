`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 15:12:34
// Design Name: 
// Module Name: transformer
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


module transformer(
	input clk,
    input rst_n,
    
    input [16-1:0] data_in,
	input data_in_valid,
	
	output [9-1:0] data_out,
	output data_out_valid
    );
	
	// =========================================================================================================
	// ============================================Block 1======================================================
	// =========================================================================================================
    reg [4:0] block_1_time_step_pre;
    reg [4:0] block_1_time_step;
	reg [4:0] block_1_time_step_out;
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            block_1_time_step_pre <= 0;
        end
        else if (data_in_valid) begin
            block_1_time_step_pre <= block_1_time_step_pre + 1'b1;
        end
    end
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            block_1_time_step <= 0;
        end
        else if (block_1_time_step_pre <= 'd29) begin
            block_1_time_step <= block_1_time_step_pre;
        end
    end
	
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            block_1_time_step_out <= 0;
        end
		else if (block_1_time_step_out == 'd29)
			block_1_time_step_out <= 'd29;
        else if (block_1_valid) begin
            block_1_time_step_out <= block_1_time_step_out + 'd1;
        end
    end
	
	reg [16-1:0] block_1[30-1:0];
	wire [16-1:0] block_1_out;
	wire block_1_valid;
	wire block_1_done;
	
	integer i,j;
	always@(posedge clk,negedge rst_n) begin
		if (~rst_n) begin
			for (i = 0; i < 30; i = i + 1) begin
				for (j = 0; j < 16; j = j + 1) begin
					block_1[i][j] <= 0;
				end
			end
		end
		else if (~block_1_done) begin
			block_1[block_1_time_step_out] <= block_1_out;
		end
	end

//	always@(posedge clk,negedge rst_n) begin
//		if (~rst_n) begin
//			block_1_done <= 0;
//		end
//		else if (block_1_time_step_out == 'd29) begin
//			block_1_done <= 1;
//		end
//	end
	
	encoder encoder_block_1(
		.clk			(clk),
		.rst_n			(rst_n),
		
		.data_in		(data_in),
		.data_in_valid	(data_in_valid),
		.block_sel		(0),
		
		.data_out		(block_1_out),
		.data_out_valid	(block_1_valid),
		.done			(block_1_done)
    );
	
//	// =========================================================================================================
//	// ============================================Block 2======================================================
//	// =========================================================================================================
//    reg [4:0] block_2_time_step_pre;
//    reg [4:0] block_2_time_step;
//	reg [4:0] block_2_time_step_out;
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_2_time_step_pre <= 0;
//        end
//		else if (block_2_time_step_pre == 'd29)
//			block_2_time_step_pre <= 'd29;
//        else if (block_1_done) begin
//            block_2_time_step_pre <= block_2_time_step_pre + 1'b1;
//        end
//    end
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_2_time_step <= 0;
//        end
//        else if (block_2_time_step_pre <= 'd29) begin
//            block_2_time_step <= block_2_time_step_pre;
//        end
//    end
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_2_time_step_out <= 0;
//        end
//		else if (block_2_time_step_out == 'd29)
//			block_2_time_step_out <= 'd29;
//        else if (block_2_valid) begin
//            block_2_time_step_out <= block_2_time_step_out + 'd1;
//        end
//    end
	
//	reg [16-1:0] block_2[30-1:0];
//	wire [16-1:0] block_2_out;
//	wire block_2_valid;
//	wire block_2_done;
	
//	always@(posedge clk,negedge rst_n) begin
//		if (~rst_n) begin
//			for (i = 0; i < 30; i = i + 1) begin
//				for (j = 0; j < 16; j = j + 1) begin
//					block_2[i][j] <= 0;
//				end
//			end
//		end
//		else if (~block_2_done) begin
//			block_2[block_2_time_step_out] <= block_2_out;
//		end
//	end

////	always@(posedge clk,negedge rst_n) begin
////		if (~rst_n) begin
////			block_1_done <= 0;
////		end
////		else if (block_1_time_step_out == 'd29) begin
////			block_1_done <= 1;
////		end
////	end
	
//	encoder encoder_block_2(
//		.clk			(clk),
//		.rst_n			(rst_n),
		
//		.data_in		(block_1[block_2_time_step]),
//		.data_in_valid	(block_1_done),
//		.block_sel		(1),
		
//		.data_out		(block_2_out),
//		.data_out_valid	(block_2_valid),
//		.done			(block_2_done)
//    );
	
//	// =========================================================================================================
//	// ============================================Block 3======================================================
//	// =========================================================================================================
//    reg [4:0] block_3_time_step_pre;
//    reg [4:0] block_3_time_step;
//	reg [4:0] block_3_time_step_out;
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_3_time_step_pre <= 0;
//        end
//		else if (block_3_time_step_pre == 'd29)
//			block_3_time_step_pre <= 'd29;
//        else if (block_2_done) begin
//            block_3_time_step_pre <= block_3_time_step_pre + 1'b1;
//        end
//    end
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_3_time_step <= 0;
//        end
//        else if (block_3_time_step_pre <= 'd29) begin
//            block_3_time_step <= block_3_time_step_pre;
//        end
//    end
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_3_time_step_out <= 0;
//        end
//		else if (block_3_time_step_out == 'd29)
//			block_3_time_step_out <= 'd29;
//        else if (block_3_valid) begin
//            block_3_time_step_out <= block_3_time_step_out + 'd1;
//        end
//    end
	
//	reg [16-1:0] block_3[30-1:0];
//	wire [16-1:0] block_3_out;
//	wire block_3_valid;
//	wire block_3_done;
	
//	always@(posedge clk,negedge rst_n) begin
//		if (~rst_n) begin
//			for (i = 0; i < 30; i = i + 1) begin
//				for (j = 0; j < 16; j = j + 1) begin
//					block_3[i][j] <= 0;
//				end
//			end
//		end
//		else if (~block_3_done) begin
//			block_3[block_3_time_step_out] <= block_3_out;
//		end
//	end
	
//	encoder encoder_block_3(
//		.clk			(clk),
//		.rst_n			(rst_n),
		
//		.data_in		(block_2[block_3_time_step]),
//		.data_in_valid	(block_2_done),
//		.block_sel		(2),
		
//		.data_out		(block_3_out),
//		.data_out_valid	(block_3_valid),
//		.done			(block_3_done)
//    );
	
//	// =========================================================================================================
//	// ============================================Block 4======================================================
//	// =========================================================================================================
//    reg [4:0] block_4_time_step_pre;
//    reg [4:0] block_4_time_step;
//	reg [4:0] block_4_time_step_out;
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_4_time_step_pre <= 0;
//        end
//		else if (block_4_time_step_pre == 'd29)
//			block_4_time_step_pre <= 'd29;
//        else if (block_3_done) begin
//            block_4_time_step_pre <= block_4_time_step_pre + 1'b1;
//        end
//    end
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_4_time_step <= 0;
//        end
//        else if (block_4_time_step_pre <= 'd29) begin
//            block_4_time_step <= block_4_time_step_pre;
//        end
//    end
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_4_time_step_out <= 0;
//        end
//		else if (block_4_time_step_out == 'd29)
//			block_4_time_step_out <= 'd29;
//        else if (block_4_valid) begin
//            block_4_time_step_out <= block_4_time_step_out + 'd1;
//        end
//    end
	
//	reg [16-1:0] block_4[30-1:0];
//	wire [16-1:0] block_4_out;
//	wire block_4_valid;
//	wire block_4_done;
	
//	always@(posedge clk,negedge rst_n) begin
//		if (~rst_n) begin
//			for (i = 0; i < 30; i = i + 1) begin
//				for (j = 0; j < 16; j = j + 1) begin
//					block_4[i][j] <= 0;
//				end
//			end
//		end
//		else if (~block_4_done) begin
//			block_4[block_4_time_step_out] <= block_4_out;
//		end
//	end
	
//	encoder encoder_block_4(
//		.clk			(clk),
//		.rst_n			(rst_n),
		
//		.data_in		(block_3[block_4_time_step]),
//		.data_in_valid	(block_3_done),
//		.block_sel		(3),
		
//		.data_out		(block_4_out),
//		.data_out_valid	(block_4_valid),
//		.done			(block_4_done)
//    );
	
//	// =========================================================================================================
//	// ============================================Block 5======================================================
//	// =========================================================================================================
//    reg [4:0] block_5_time_step_pre;
//    reg [4:0] block_5_time_step;
//	reg [4:0] block_5_time_step_out;
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_5_time_step_pre <= 0;
//        end
//		else if (block_5_time_step_pre == 'd29)
//			block_5_time_step_pre <= 'd29;
//        else if (block_4_done) begin
//            block_5_time_step_pre <= block_5_time_step_pre + 1'b1;
//        end
//    end
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_5_time_step <= 0;
//        end
//        else if (block_5_time_step_pre <= 'd29) begin
//            block_5_time_step <= block_5_time_step_pre;
//        end
//    end
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_5_time_step_out <= 0;
//        end
//		else if (block_5_time_step_out == 'd29)
//			block_5_time_step_out <= 'd29;
//        else if (block_5_valid) begin
//            block_5_time_step_out <= block_5_time_step_out + 'd1;
//        end
//    end
	
//	reg [16-1:0] block_5[30-1:0];
//	wire [16-1:0] block_5_out;
//	wire block_5_valid;
//	wire block_5_done;
	
//	always@(posedge clk,negedge rst_n) begin
//		if (~rst_n) begin
//			for (i = 0; i < 30; i = i + 1) begin
//				for (j = 0; j < 16; j = j + 1) begin
//					block_5[i][j] <= 0;
//				end
//			end
//		end
//		else if (~block_5_done) begin
//			block_5[block_5_time_step_out] <= block_5_out;
//		end
//	end
	
//	encoder encoder_block_5(
//		.clk			(clk),
//		.rst_n			(rst_n),
		
//		.data_in		(block_4[block_5_time_step]),
//		.data_in_valid	(block_4_done),
//		.block_sel		(4),
		
//		.data_out		(block_5_out),
//		.data_out_valid	(block_5_valid),
//		.done			(block_5_done)
//    );
	
//	// =========================================================================================================
//	// ============================================Block 6======================================================
//	// =========================================================================================================
//    reg [4:0] block_6_time_step_pre;
//    reg [4:0] block_6_time_step;
//	reg [4:0] block_6_time_step_out;
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_6_time_step_pre <= 0;
//        end
//		else if (block_6_time_step_pre == 'd29)
//			block_6_time_step_pre <= 'd29;
//        else if (block_5_done) begin
//            block_6_time_step_pre <= block_6_time_step_pre + 1'b1;
//        end
//    end
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_6_time_step <= 0;
//        end
//        else if (block_6_time_step_pre <= 'd29) begin
//            block_6_time_step <= block_6_time_step_pre;
//        end
//    end
	
//    always @(posedge clk or negedge rst_n) begin
//        if (~rst_n) begin
//            block_6_time_step_out <= 0;
//        end
//		else if (block_6_time_step_out == 'd29)
//			block_6_time_step_out <= 'd29;
//        else if (block_6_valid) begin
//            block_6_time_step_out <= block_6_time_step_out + 'd1;
//        end
//    end
	
//	reg [16-1:0] block_6[30-1:0];
//	wire [16-1:0] block_6_out;
//	wire block_6_valid;
//	wire block_6_done;
	
//	always@(posedge clk,negedge rst_n) begin
//		if (~rst_n) begin
//			for (i = 0; i < 30; i = i + 1) begin
//				for (j = 0; j < 16; j = j + 1) begin
//					block_6[i][j] <= 0;
//				end
//			end
//		end
//		else if (~block_6_done) begin
//			block_6[block_6_time_step_out] <= block_6_out;
//		end
//	end
	
//	encoder encoder_block_6(
//		.clk			(clk),
//		.rst_n			(rst_n),
		
//		.data_in		(block_5[block_6_time_step]),
//		.data_in_valid	(block_5_done),
//		.block_sel		(4),
		
//		.data_out		(block_6_out),
//		.data_out_valid	(block_6_valid),
//		.done			(block_6_done)
//    );
	
	// =========================================================================================================
	// ============================================Flatten======================================================
	// =========================================================================================================
	reg [480-1:0] data_flatten;
	reg data_flatten_done;
	always@(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			data_flatten_done <= 0;
			for (i = 0; i < 30; i = i + 1) begin
				for (j = 0; j < 16; j = j + 1) begin
					data_flatten[i*16+j] <= 0;
				end
			end
		end
		else if (block_1_done) begin
			data_flatten_done <= 1;
			for (i = 0; i < 30; i = i + 1) begin
				for (j = 0; j < 16; j = j + 1) begin
					data_flatten[i*16+j] <= block_1[i][j];
				end
			end
		end
	end
	
	
	// =========================================================================================================
	// ============================================Output 1=====================================================
	// =========================================================================================================
	
	reg [256-1:0] output_1;
	wire [8-1:0] output_1_out;
	wire [6-1:0] output_1_time_step;
	wire output_1_valid;
	wire output_1_done;
	
	always@(posedge clk,negedge rst_n) begin
		if (~rst_n) begin
			output_1 <= 'd0;
		end
		else if (~output_1_done) begin
			output_1[output_1_time_step*8 +: 8] <= output_1_out;
		end
	end

	output_1 output_1_U(
		.clk			(clk),
		.rst_n			(rst_n),
		
		.data_in		(data_flatten),
		.data_in_valid	(data_flatten_done),
		
		.data_out		(output_1_out),
		.data_out_valid	(output_1_valid),
		.time_step		(output_1_time_step),
		.done			(output_1_done)
    );
	
	// =========================================================================================================
	// ============================================Output 2=====================================================
	// =========================================================================================================
	
	output_2 output_2_U(
		.clk			(clk),
		.rst_n			(rst_n),
		
		.data_in		(output_1),
		.data_in_valid	(output_1_done),
		
		.data_out		(data_out),
		.data_out_valid	(data_out_valid)
    );
	
	
	
	
	
	
	
	
	
	
	
	
	
endmodule
