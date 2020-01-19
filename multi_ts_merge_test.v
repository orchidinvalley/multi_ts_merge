`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:51:16 10/28/2019
// Design Name:   multi_ts_merge
// Module Name:   E:/FPGA_pro/multi_ts_merge/multi_ts_merge_test.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: multi_ts_merge
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module multi_ts_merge_test;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] ts_din_1;
	reg ts_din_en_1;
	reg [7:0] ts_din_2;
	reg ts_din_en_2;
	reg [7:0] ts_din_3;
	reg ts_din_en_3;
	reg [7:0] ts_din_4;
	reg ts_din_en_4;
	reg [7:0] ts_din_5;
	reg ts_din_en_5;
	reg [7:0] ts_din_6;
	reg ts_din_en_6;
	reg [7:0] ts_din_7;
	reg ts_din_en_7;
	reg [7:0] ts_din_8;
	reg ts_din_en_8;

	// Instantiate the Unit Under Test (UUT)
	multi_ts_merge uut (
		.clk(clk), 
		.rst(rst), 
		.ts_din_1(ts_din_1), 
		.ts_din_en_1(ts_din_en_1), 
		.ts_din_2(ts_din_2), 
		.ts_din_en_2(ts_din_en_2), 
		.ts_din_3(ts_din_3), 
		.ts_din_en_3(ts_din_en_3), 
		.ts_din_4(ts_din_4), 
		.ts_din_en_4(ts_din_en_4), 
		.ts_din_5(ts_din_5), 
		.ts_din_en_5(ts_din_en_5), 
		.ts_din_6(ts_din_6), 
		.ts_din_en_6(ts_din_en_6), 
		.ts_din_7(ts_din_7), 
		.ts_din_en_7(ts_din_en_7), 
		.ts_din_8(ts_din_8), 
		.ts_din_en_8(ts_din_en_8)
	);

	integer i=0;
	integer k=0;
	integer	cnt;
	
	reg[3:0]sl1,sl2;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		ts_din_1 = 0;
		ts_din_en_1 = 0;
		ts_din_2 = 0;
		ts_din_en_2 = 0;
		ts_din_3 = 0;
		ts_din_en_3 = 0;
		ts_din_4 = 0;
		ts_din_en_4 = 0;
		ts_din_5 = 0;
		ts_din_en_5 = 0;
		ts_din_6 = 0;
		ts_din_en_6 = 0;
		ts_din_7 = 0;
		ts_din_en_7 = 0;
		ts_din_8 = 0;
		ts_din_en_8 = 0;


		#3 rst=1;
		// Wait 100 ns for global reset to finish
		#100;
     rst=0;  
		// Add stimulus here
		
		#100;
		
		cnt=49;
		tsmf_send();
		#100;
		
		for(k=0;k<cnt-15;k=k+1)
		ts_send();
		
		#100;
		
		cnt=23;
		tsmf_send();
		#100;
		
		for(k=0;k<25;k=k+1)
		ts_send();

	end
 	always #5 clk=~clk;
 	
 	task tsmf_send();
 	begin
 		#10 ts_din_1=8'h47;
 		ts_din_en_1=1;
 		#10 ts_din_1=8'h1f;
 		#10 ts_din_1=8'hfe;
 		#10 ts_din_1=8'h10;
 		#10 ts_din_1=8'h1a;
 		#10 ts_din_1=8'h86;
 		#10 ts_din_1=8'h00;
 		#10 ts_din_1=8'h00;
 		#10 ts_din_1=8'h00;
 		#10 ts_din_1=8'h00;
 		#10 ts_din_1=8'h00;
 		#10 ts_din_1=8'h00;
 		for(i=1;i<cnt;i=i+1)begin
 			sl1	={$random}%14+1;
 			sl2	={$random}%14+1;
 			#10 ts_din_1={sl1,sl2};
 		end
 		
 		for(i=1;i<185-cnt;i=i+1)
 		#10 ts_din_1=0;
 		#10 ts_din_en_1=0;
 		
	end
	endtask
 	
 	task ts_send();
 	begin
 	
 		#10 ts_din_1=8'h47;
 		ts_din_en_1=1;
 		#10 ts_din_1=8'h10;
 		#10 ts_din_1=8'h11;
 		#10 ts_din_1=8'h13;
 		
 		for(i=1;i<185;i=i+1)
 		begin
 			#10 ts_din_1=i;
 		end
 		
 		#10 ts_din_1	=0;
 		ts_din_en_1	=0;
 		#100;
 	end
 	endtask     
endmodule

