`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:19:53 10/09/2019
// Design Name:   ts_speed
// Module Name:   E:/FPGA_pro/multi_ts_merge/ts_speed_test.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ts_speed
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ts_speed_test;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] ts_din;
	reg ts_din_en;
	reg rate_con_start;
	reg rate_con_end;

	// Outputs
	wire [7:0] rate_dout;
	wire rate_dout_en;

	// Instantiate the Unit Under Test (UUT)
	ts_speed uut (
		.clk(clk), 
		.rst(rst), 
		.ts_din(ts_din), 
		.ts_din_en(ts_din_en), 
		.rate_dout(rate_dout), 
		.rate_dout_en(rate_dout_en), 
		.rate_con_start(rate_con_start), 
		.rate_con_end(rate_con_end)
	);
	
	integer	i=0;
	reg	[3:0]ip;
	integer	j=0;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		ts_din = 0;
		ts_din_en = 0;
		rate_con_start = 0;
		rate_con_end = 0;
		#3 rst =1;
		// Wait 100 ns for global reset to finish
		#100;
		rst =0;
		
		
		#100;
		rate_con_start=1;
		#10 rate_con_start=0;
		
		
	for(j=0;j<500;j=j+1)begin
		if(j==300)begin
			#10 rate_con_end=1;
			#10 rate_con_end=0;
		end
		else if(j==400)begin
			#10 rate_con_start=1;
			#10 rate_con_start=0;
		end
		else 
			#100 ts_send();
	end
		
		
        
		// Add stimulus here

	end
  
  always #5 clk=~clk;
  
  task ts_send();
  begin
  	#10 ts_din_en=1;  	
  	ts_din={$random}%15;
  	for(i=1;i<48;i=i+1)
  	#10 ts_din=i;
  	#10 ts_din_en=0;
  end
  endtask
      
endmodule

