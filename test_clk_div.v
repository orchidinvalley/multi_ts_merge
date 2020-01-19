`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:59:30 07/27/2019
// Design Name:   clk_div
// Module Name:   E:/FPGA_pro/multi_ts_merge/test_clk_div.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clk_div
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_clk_div;

	// Inputs
	reg clk;
	reg rst;
	wire clk_div;

	// Instantiate the Unit Under Test (UUT)
	clk_div uut (
		.clk(clk), 
		.rst(rst), 
		.clk_div(clk_div)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		
		#2 rst =1;
		// Wait 100 ns for global reset to finish
		#100;
        
    rst =0;
		// Add stimulus here

	end
	
	always #5 clk =!clk;
      
endmodule

