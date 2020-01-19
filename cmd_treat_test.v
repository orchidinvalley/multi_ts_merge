`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:51:19 08/29/2019
// Design Name:   command_treat
// Module Name:   E:/FPGA_pro/multi_ts_merge/cmd_treat_test.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: command_treat
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cmd_treat_test;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] con_din;
	reg con_din_en;

	// Outputs
	wire [7:0] si_get_con;
	wire si_get_con_en;
	wire	[7:0]nit_con;
  wire	nit_con_en;
	wire [7:0] freq_con;
	wire freq_con_en;
	wire [7:0] channel_con;
	wire channel_con_en;
	wire [7:0] ip_port_con;
	wire ip_port_con_en;
	wire [7:0] reply_con;
	wire reply_con_en;

	// Instantiate the Unit Under Test (UUT)
	command_treat uut (
		.clk(clk), 
		.rst(rst), 
		.con_din(con_din), 
		.con_din_en(con_din_en), 
		.si_get_con(si_get_con), 
		.si_get_con_en(si_get_con_en), 
		.nit_con(nit_con), 
    .nit_con_en(nit_con_en), 
		.freq_con(freq_con), 
		.freq_con_en(freq_con_en), 
		.channel_con(channel_con), 
		.channel_con_en(channel_con_en), 
		.ip_port_con(ip_port_con), 
		.ip_port_con_en(ip_port_con_en),
		.reply_con(reply_con), 
    .reply_con_en(reply_con_en)
	);
reg	[7:0]op;
reg [7:0]ret;
	integer i=0;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		con_din = 0;
		con_din_en = 0;

		#2 rst=1;
		// Wait 100 ns for global reset to finish
		#100;
		rst =0;
		#100;
		
		op=1;
		send_cmd();
		
		#100;
		op=3;
		ret=1;
		send_cmd();
		
			#100;
		op=4;
		send_cmd();
		
        
		// Add stimulus here

	end
	
	
	task  send_cmd;
	begin
		#10 con_din=8'h40;
				con_din_en=1;
		#10 con_din=op;
		#10 con_din=8'h00;
		#10 con_din=ret;
		#10 con_din=8'h00;
		#10 con_din=8'h01;
		#10 con_din=8'h00;
		#10 con_din=8'h01;
		for(i=1;i<20;i=i+1)
		#10 con_din=i;
		#10 con_din=0;
			con_din_en=0;
	
		
	end
	endtask
	
	always #5 clk=~clk;
      
endmodule

