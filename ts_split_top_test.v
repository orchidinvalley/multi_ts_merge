`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:24:06 08/29/2019
// Design Name:   ts_split_top
// Module Name:   E:/FPGA_pro/multi_ts_merge/ts_split_top_test.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ts_split_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ts_split_top_test;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] con_din;
	reg con_din_en;
	reg [7:0] udp_din;
	reg udp_din_en;

	// Outputs
	wire [7:0] con_dout;
	wire con_dout_en;
	wire ts_ram_wr;
	wire [12:0] ts_ram_waddr;
	wire [127:0] ts_ram_wdata;

	// Instantiate the Unit Under Test (UUT)
	ts_split_top uut (
		.clk(clk), 
		.rst(rst), 
		.con_din(con_din), 
		.con_din_en(con_din_en), 
		.udp_din(udp_din), 
		.udp_din_en(udp_din_en), 
		.con_dout(con_dout), 
		.con_dout_en(con_dout_en), 
		.ts_ram_wr(ts_ram_wr), 
		.ts_ram_waddr(ts_ram_waddr), 
		.ts_ram_wdata(ts_ram_wdata)
	);
	
	reg	[3:0]cnt=0;
	integer	num=0;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		con_din = 0;
		con_din_en = 0;
		udp_din = 0;
		udp_din_en = 0;

		#2	rst=1;
		// Wait 100 ns for global reset to finish
		#100;
				rst=0;
		#100;
		#10 con_din_en=1;			
				con_din=8'h40;
		#10 con_din=8'h04;
		#10 con_din=8'h00;
		#10 con_din=8'd01;
		#10 con_din=8'h00;
		#10 con_din=8'd01;
		#10 con_din=8'h00;
		#10 con_din=8'd01;
		#10 con_din=8'hc0;
		#10 con_din=8'd00;
		#10 con_din=8'd01;		
		#10 con_din=8'd192;
		#10 con_din=8'd18;
		#10 con_din=8'd8;
		#10 con_din=8'd8;
		#10 con_din=8'd25;
		#10 con_din=8'd24;
		#10 con_din=8'd02;
		#10 con_din=8'h02;
		#10 con_din=8'd192;
		#10 con_din=8'd18;
		#10 con_din=8'd8;
		#10 con_din=8'd9;
		#10 con_din=8'd24;
		#10 con_din=8'd25;
		#10 con_din=8'd01;
		#10 con_din=0;
		con_din_en=0;
		
		
		#100;
		
		#10 con_din_en=1;
		con_din=8'h40;
		#10 con_din=8'h03;
		#10 con_din=8'h00;
		#10 con_din=8'd01;
		#10 con_din=8'h00;
		#10 con_din=8'd01;
		#10 con_din=8'h00;
		#10 con_din=8'd01;
		#10 con_din=0;
		#10 con_din=0;
		#10 con_din=1;
		#10 con_din=0;
		#10 con_din=20;
		#10 con_din=0;
		#10 con_din=0;
		#10 con_din=0;
		#10 con_din=1;
		#10 con_din=0;
		#10 con_din=3;
		#10 con_din=1;
		#10 con_din=0;
		#10 con_din=5;
		#10 con_din=0;
		#10 con_din=0;
		#10 con_din=0;
		#10 con_din=1;
		#10 con_din=0;
		#10 con_din=3;
		#10 con_din=0;
		#10 con_din=0;
		#10 con_din=0;
		#10 con_din=0;
		#10 con_din=0;
		#10 con_din=0;
		#10 con_din_en=0;
        
		// Add stimulus here
		
		
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		
		#800;
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd8;
		#10 udp_din=8'd25;
		#10 udp_din=8'd24;
		for(num=0;num<8;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		
		#800;
		
		
	
		
		#10 udp_din=8'd192;
		udp_din_en=1;
		#10 udp_din=8'd18;
		#10 udp_din=8'd8;
		#10 udp_din=8'd9;
		#10 udp_din=8'd24;
		#10 udp_din=8'd25;
		for(num=0;num<6;num=num+1)
			ts_send();
		
		#10 udp_din_en=0;
		

	end
	
	always #5 clk=~clk;
   
   integer i;
  task ts_send;
	begin
		
		#10 udp_din=8'h47;
		#10 udp_din=8'h10;
		#10 udp_din=8'h01;
		#10 udp_din={4'h0,cnt};
		for(i=1;i<185;i=i+1)
		#10 udp_din=i;
		
		cnt=cnt+1;
	end
	endtask
      
endmodule

