`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:11:14 08/20/2019
// Design Name:   tsmf_split
// Module Name:   E:/FPGA_pro/multi_ts_merge/tsmf_split_test.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: tsmf_split
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tsmf_split_test;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] ts_din;
	reg ts_din_en;
	reg [7:0] freq_con_din;
	reg freq_con_din_en;
	reg [7:0] channel_din;
	reg channel_din_en;
	// Outputs
	wire ts_ram_wr;
	wire [12:0] ts_ram_waddr;
	wire [127:0]ts_ram_wdata;
	reg	ts_ram_valid;

	// Instantiate the Unit Under Test (UUT)
	tsmf_split uut (
		.clk(clk), 
		.rst(rst), 
		.ts_din(ts_din), 
		.ts_din_en(ts_din_en), 
		
		.freq_con_din(freq_con_din), 
		.freq_con_din_en(freq_con_din_en),
		.channel_din(channel_din),
		.channel_din_en(channel_din_en),
		.ts_ram_wr(ts_ram_wr),
		.ts_ram_waddr(ts_ram_waddr),
		.ts_ram_wdata(ts_ram_wdata),
		.ts_ram_valid(ts_ram_valid)
	);
	
	reg[31:0]i;
  always #5 clk=~clk;
  reg[3:0]cnt=0;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		ts_din = 0;
		ts_din_en = 0;
		freq_con_din = 0;
		freq_con_din_en = 0;
		channel_din	=	0;
		channel_din_en	=	0;
		
		#2 rst =1;
		// Wait 100 ns for global reset to finish
		#100;
		
			rst=0;
			
		#100;
		
		#10 freq_con_din_en=1;
		freq_con_din=00;
		#10 freq_con_din=00;
		#10 freq_con_din=1;
		#10 freq_con_din=0;
		#10 freq_con_din=20;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=1;
		#10 freq_con_din=0;
		#10 freq_con_din=3;
		#10 freq_con_din=1;
		#10 freq_con_din=0;
		#10 freq_con_din=5;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=1;
		#10 freq_con_din=0;
		#10 freq_con_din=3;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din_en=0;
		
		
		
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
			#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
			#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
			#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
			#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
			#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
			#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
		cnt=cnt+1;
		#100;
		
		ts_send();
        
		// Add stimulus here

	end
  
  
  task ts_send;
  begin
  
  #10 ts_din_en=1;
  ts_din=2;
  #10 ts_din={28'h4710010,cnt};
  
  for(i=1;i<47;i=i+1)
  #10 ts_din=i;
 	#10 ts_din_en=0;
 	ts_din=0;
 	
 	#100;
 	
 	
  	
  end
	endtask
      
endmodule

