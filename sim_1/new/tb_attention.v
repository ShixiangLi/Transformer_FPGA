`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 17:01:30
// Design Name: 
// Module Name: tb_attention
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


module tb_attention;

reg clk;
reg rst_n;

reg [16-1:0] data_in;
reg data_in_valid;
integer file,i;

wire [3-1:0] block_sel;
assign block_sel = 'd0;

initial begin
    clk = 1'b0;
    forever begin
        #5 clk = ~clk;
    end
end

initial begin
    rst_n = 0;
    data_in_valid = 0;
    #100;
    rst_n = 1;
    #100;
    file = $fopen("test_data.txt", "rb");
    if (file==0) begin
        $display("[-]error");
        $stop;
    end
    for (i=0;i<30;i=i+1) begin
        @(posedge clk);
        $fscanf(file, "%b", data_in);
        data_in_valid <= 1;
    end
    
    data_in_valid <= 0;
    $fclose(file);
end

attention attention(
	.clk			(clk),
    .rst_n			(rst_n),
    
    .data_in		(data_in),
	.data_in_valid	(data_in_valid),
	.block_sel		(block_sel)
    );

endmodule
