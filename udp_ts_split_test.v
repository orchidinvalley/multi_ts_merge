`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:03:04 08/16/2019
// Design Name:   udp_ts_split
// Module Name:   E:/FPGA_pro/multi_ts_merge/udp_ts_split_test.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: udp_ts_split
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module udp_ts_split_test;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] udp_din;
	reg udp_din_en;

	// Outputs
	wire [32:0] ts_dout;
	wire ts_dout_en;

	// Instantiate the Unit Under Test (UUT)
	udp_ts_split uut (
		.clk(clk), 
		.rst(rst), 
		.udp_din(udp_din), 
		.udp_din_en(udp_din_en), 
		.ts_dout(ts_dout), 
		.ts_dout_en(ts_dout_en)
	);

integer cnt=8'd0;
	integer	i=	8'd1;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		udp_din = 0;
		udp_din_en = 0;
		
		#2 rst=1;

		// Wait 100 ns for global reset to finish
		#100;
		
		#5 rst=0;
		
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(;cnt<8;cnt=cnt+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
		cnt =0;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd25;
		for(;cnt<6;cnt=cnt+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		
		
        
		// Add stimulus here

	end
	
	
	always #5 clk=~clk;
	
	
	
	task ts_send;
	begin
		
		#10 udp_din=8'h47;
		#10 udp_din=8'h10;
		#10 udp_din=8'h01;
		#10 udp_din=cnt;
		for(i=1;i<185;i=i+1)
		#10 udp_din=i;
	end
	endtask
      
endmodule

