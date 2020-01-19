`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:52:22 08/19/2019
// Design Name:   ts_ip_rej
// Module Name:   E:/FPGA_pro/multi_ts_merge/ts_ip_rej_test.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ts_ip_rej
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ts_ip_rej_test;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] ts_din;
	reg ts_din_en;
	reg [7:0]ip_port_con_din;
	reg ip_port_con_din_en;

	// Outputs
	wire [31:0] ts_dout;
	wire ts_dout_en;

	// Instantiate the Unit Under Test (UUT)
	ts_ip_rej uut (
		.clk(clk), 
		.rst(rst), 
		.ts_din(ts_din), 
		.ts_din_en(ts_din_en), 
		.ts_dout(ts_dout), 
		.ts_dout_en(ts_dout_en), 
		.ip_port_con_din(ip_port_con_din), 
		.ip_port_con_din_en(ip_port_con_din_en)
	);
reg [7:0]i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		ts_din = 0;
		ts_din_en = 0;
		ip_port_con_din = 0;
		ip_port_con_din_en = 0;
		#2 rst=1;
		// Wait 100 ns for global reset to finish
		#100;
		rst=0;
		
		#100;
		
		#10 ip_port_con_din_en=1;
		ip_port_con_din=1;
		#10 ip_port_con_din=8'd192;
		#10 ip_port_con_din=8'd18;
		#10 ip_port_con_din=8'd8;
		#10 ip_port_con_din=8'd8;
		#10 ip_port_con_din=8'd24;
		#10 ip_port_con_din=8'd25;
		#10 ip_port_con_din=8'd02;
		#10 ip_port_con_din=8'h02;
		#10 ip_port_con_din=8'd192;
		#10 ip_port_con_din=8'd18;
		#10 ip_port_con_din=8'd8;
		#10 ip_port_con_din=8'd9;
		#10 ip_port_con_din=8'd24;
		#10 ip_port_con_din=8'd25;
		#10 ip_port_con_din=8'd01;
		#10 ip_port_con_din=0;
		ip_port_con_din_en=0;
		
    #100;
    
    #10 ts_din=32'h1;
    ts_din_en=1;
    #10 ts_din=32'hc0120808;
    #10 ts_din=32'h1819;
    #10 ts_din=32'h47100101;
    for (i=0;i<46;i=i+1)
    	#10 ts_din={23'h0,i};
    #10 ts_din=0;
    ts_din_en=0;  
		// Add stimulus here


		#100;
		
		#10 ts_din=32'h2;
    ts_din_en=1;
    #10 ts_din=32'hc0120809;
    #10 ts_din=32'h1819;
    #10 ts_din=32'h47100101;
    for (i=0;i<46;i=i+1)
    	#10 ts_din={23'h0,i};
    #10 ts_din=0;
    ts_din_en=0;  
    
    
#10 ip_port_con_din_en=1;
		ip_port_con_din=1;
		#10 ip_port_con_din=8'd192;
		#10 ip_port_con_din=8'd18;
		#10 ip_port_con_din=8'd8;
		#10 ip_port_con_din=8'd8;
		#10 ip_port_con_din=8'd24;
		#10 ip_port_con_din=8'd25;
		#10 ip_port_con_din=8'd02;
		#10 ip_port_con_din_en=0;

	end
  always #5 clk=~clk;    
endmodule

