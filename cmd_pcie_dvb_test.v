`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:53:25 08/16/2019
// Design Name:   cmd_pcie_dvb
// Module Name:   E:/FPGA_pro/multi_ts_merge/cmd_pcie_dvb_test.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cmd_pcie_dvb
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cmd_pcie_dvb_test;

	// Inputs
	reg trn_clk;
	reg clk_main;
	reg rst;
	reg [63:0] cmd_dma_din;
	reg cmd_dma_sof;
	reg cmd_dma_eof;
	reg cmd_dma_din_en;
	reg [7:0] cmd_dvb_din;
	reg cmd_dvb_din_en;

	// Outputs
	wire [63:0] cmd_dma_dout;
	wire cmd_dma_dout_en;
	wire [8:0] cmd_dma_addr;
	wire [7:0] cmd_dvb_dout;
	wire cmd_dvb_dout_en;

	// Instantiate the Unit Under Test (UUT)
	cmd_pcie_dvb uut (
		.trn_clk(trn_clk), 
		.clk_main(clk_main), 
		.rst(rst), 
		.cmd_dma_din(cmd_dma_din), 
		.cmd_dma_sof(cmd_dma_sof), 
		.cmd_dma_eof(cmd_dma_eof), 
		.cmd_dma_din_en(cmd_dma_din_en), 
		.cmd_dma_dout(cmd_dma_dout), 
		.cmd_dma_dout_en(cmd_dma_dout_en), 
		.cmd_dma_addr(cmd_dma_addr), 
		.cmd_dvb_din(cmd_dvb_din), 
		.cmd_dvb_din_en(cmd_dvb_din_en), 
		.cmd_dvb_dout(cmd_dvb_dout), 
		.cmd_dvb_dout_en(cmd_dvb_dout_en)
	);
integer i =8'd0;
	initial begin
		// Initialize Inputs
		trn_clk = 0;
		clk_main = 0;
		rst = 0;
		cmd_dma_din = 0;
		cmd_dma_sof = 0;
		cmd_dma_eof = 0;
		cmd_dma_din_en = 0;
		cmd_dvb_din = 0;
		cmd_dvb_din_en = 0;


		#2 rst=1;
		// Wait 100 ns for global reset to finish
		#100;
		#3 rst=0;
		
		
		
		#10 cmd_dvb_din_en=1;
		cmd_dvb_din=8'h40;
		#10 cmd_dvb_din=8'h01;
		#10 cmd_dvb_din=8'h00;
		#10 cmd_dvb_din=8'h01;
		for(;i<10;i=i+1)
		#10 cmd_dvb_din=i;
    #10 cmd_dvb_din_en=0;   
		// Add stimulus here

	end
	
	always #5 clk_main=~clk_main;
      
endmodule

