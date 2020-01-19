`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:34:05 08/26/2019
// Design Name:   si_get
// Module Name:   E:/FPGA_pro/multi_ts_merge/si_get_test.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: si_get
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module si_get_test;

	// Inputs
	reg clk;
	reg rst;
	reg [32:0] ts_din;
	reg ts_din_en;
	reg [7:0] con_din;
	reg con_din_en;

	// Outputs
	wire [7:0] si_dout;
	wire si_dout_en;

	// Instantiate the Unit Under Test (UUT)
	si_get uut (
		.clk(clk), 
		.rst(rst), 
		.ts_din(ts_din), 
		.ts_din_en(ts_din_en), 
		.con_din(con_din), 
		.con_din_en(con_din_en), 
		.si_dout(si_dout), 
		.si_dout_en(si_dout_en)
	);

	integer start=1;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		ts_din = 0;
		ts_din_en = 0;
		con_din = 0;
		con_din_en = 0;
		
		#2 rst=1;
		// Wait 100 ns for global reset to finish
		#100;
		
		rst=0;
		
		#10 con_din_en=1;
		con_din=8'h01;
		#10 con_din=8'hc0;
		#10 con_din=8'h12;
		#10 con_din=8'h08;
		#10 con_din=8'h20;
		#10 con_din=8'h24;
		#10 con_din=8'h25;
		#10 con_din=8'h00;
		#10 con_din=8'h11;
		#10 con_din=8'h42;
		#10 con_din=8'h00;
		#10 con_din=8'h14;
		#10 con_din=0;
		con_din_en=0;
		
		
		#100;
		
		si_send();
		
		#100 
		ts_send();
		
		#100 start=start+1;
		si_send();
		
		#100 start=start+1;
		si_send();
		
		#100 start=start+1;
		si_send();
		
        
		// Add stimulus here

	end
	
	always #5 clk=~clk;
	integer i;
	
	task ts_send;
	begin
		
		#10 ts_din_en=1;
		ts_din=33'h100000001;
		#10 ts_din=33'h0c0120820;
		#10 ts_din=33'h000002425;
		#10 ts_din=33'h047011011;
		for(i=1;i<47;i=i+1)
		#10 ts_din=i;
		#10 ts_din=0;
			ts_din_en=0;
			
	end
	endtask
	
	reg	[3:0]cc=4'hA;
	
	task si_send;
	begin
		#10 ts_din_en=1;
		ts_din=33'h100000001;
		#10 ts_din=33'h0c0120820;
		#10 ts_din=33'h000002425;
		if(start==1)
			#10 ts_din={29'h04740111,cc};
		else	
			#10 ts_din={29'h04700111,cc};
		#10 ts_din=33'h00042F117;
		#10 ts_din=33'h00001c500;
		
		for(i=1;i<45;i=i+1)
		#10 ts_din=i;
		#10 ts_din=0;
			ts_din_en=0;
			cc=cc+1;
	end
	endtask
      
endmodule

