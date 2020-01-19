`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:34:40 09/30/2019
// Design Name:   nit_replace
// Module Name:   E:/FPGA_pro/multi_ts_merge/nit_replace_test.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: nit_replace
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module nit_replace_test;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] ts_din;
	reg ts_din_en;
	reg [7:0]nit_con;
	reg nit_con_en;

	// Outputs
	wire [31:0] ts_dout;
	wire ts_dout_en;

	// Instantiate the Unit Under Test (UUT)
	nit_replace uut (
		.clk(clk), 
		.rst(rst), 
		.ts_din(ts_din), 
		.ts_din_en(ts_din_en), 
		.nit_con(nit_con), 
		.nit_con_en(nit_con_en), 
		.ts_dout(ts_dout), 
		.ts_dout_en(ts_dout_en)
	);

reg	[7:0]cnt;
integer	i=0;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		ts_din = 0;
		ts_din_en = 0;
		nit_con = 0;
		nit_con_en = 0;

		#3 rst=1;
		// Wait 100 ns for global reset to finish
		#100;
		
		rst=0;
		cnt=0;
		#10 nit_con=5;
			nit_con_en=1;
		#10 nit_con=8'h47;
		#10 nit_con=8'h10;
		#10 nit_con=8'h01;
		#10	nit_con=cnt;
		for(i=1;i<185;i=i+1)
		#10 nit_con=i;
		cnt=cnt+1;
		#10 nit_con=8'h47;
		#10 nit_con=8'h10;
		#10 nit_con=8'h01;
		#10	nit_con=cnt;
		for(i=1;i<185;i=i+1)
		#10 nit_con=i;
		#10 nit_con=8'h47;
		#10 nit_con=8'h10;
		#10 nit_con=8'h01;
		#10	nit_con=cnt;
		for(i=1;i<185;i=i+1)
		#10 nit_con=i;
		#10 nit_con=8'h47;
		#10 nit_con=8'h10;
		#10 nit_con=8'h01;
		#10	nit_con=cnt;
		for(i=1;i<185;i=i+1)
		#10 nit_con=i;
		#10 nit_con=8'h47;
		#10 nit_con=8'h10;
		#10 nit_con=8'h01;
		#10	nit_con=cnt;
		for(i=1;i<185;i=i+1)
		#10 nit_con=i;
		#10 nit_con_en=0;
        
		// Add stimulus here
		cnt=0;
		
		ts_send();
		
		#100;
		#10 ts_din_en=1;
		ts_din=1;
		#10 ts_din=32'h47400100;
		
		for(i=1;i<47;i=i+1)
		#10 ts_din=0;
		#10 ts_din_en=0;
		#100;
		ts_send();
		
		#100;
		
		ts_send();
		
		#100;
		#10 ts_din_en=1;
		ts_din=1;
		#10 ts_din=32'h47400100;
		for(i=1;i<47;i=i+1)
		#10 ts_din=0;
		#10 ts_din_en=0;
		
			#100;
		#10 ts_din_en=1;
		ts_din=1;
		#10 ts_din=32'h47400100;
		for(i=1;i<47;i=i+1)
		#10 ts_din=0;
		#10 ts_din_en=0;
		
			#100;
		#10 ts_din_en=1;
		ts_din=1;
		#10 ts_din=32'h47400100;
		for(i=1;i<47;i=i+1)
		#10 ts_din=0;
		#10 ts_din_en=0;
		
		
			#100;
		#10 ts_din_en=1;
		ts_din=1;
		#10 ts_din=32'h47400100;
		for(i=1;i<47;i=i+1)
		#10 ts_din=0;
		#10 ts_din_en=0;
		
		
			#100;
		#10 ts_din_en=1;
		ts_din=1;
		#10 ts_din=32'h47400100;
		for(i=1;i<47;i=i+1)
		#10 ts_din=0;
		#10 ts_din_en=0;
		
			#100;
		#10 ts_din_en=1;
		ts_din=1;
		#10 ts_din=32'h47400100;
		for(i=1;i<47;i=i+1)
		#10 ts_din=0;
		#10 ts_din_en=0;
		
	end
	
	always #5 clk=~clk;
	
	task ts_send();
	begin
		
		#10 ts_din_en=1;
		ts_din=1;
		#10 ts_din=	32'h47020101;
		for(i=1;i<47;i=i+1)
		#10 ts_din=i;
		#10 ts_din=0;
		ts_din_en=0;
	
		
		cnt=cnt+1;
	end
	endtask
      
endmodule

