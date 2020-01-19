`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:54:43 07/18/2019
// Design Name:   ts_input_pre
// Module Name:   E:/FPGA_pro/multi_ts_merge/ts_input_test.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ts_input_pre
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ts_input_test;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] ts_din_1;
	reg ts_din_1_en;
	reg [31:0] ts_din_2;
	reg ts_din_2_en;
	reg [31:0] ts_din_3;
	reg ts_din_3_en;
	reg [31:0] ts_din_4;
	reg ts_din_4_en;
	reg [7:0] con_din;
	reg con_din_en;

	// Outputs
	wire [7:0] ts_dout;
	wire ts_dout_en;

	// Instantiate the Unit Under Test (UUT)
	ts_input_pre uut (
		.clk(clk), 
		.rst(rst), 
		.ts_din_1(ts_din_1), 
		.ts_din_1_en(ts_din_1_en), 
		.ts_din_2(ts_din_2), 
		.ts_din_2_en(ts_din_2_en), 
		.ts_din_3(ts_din_3), 
		.ts_din_3_en(ts_din_3_en), 
		.ts_din_4(ts_din_4), 
		.ts_din_4_en(ts_din_4_en), 
		.ts_dout(ts_dout), 
		.ts_dout_en(ts_dout_en), 
		.con_din(con_din), 
		.con_din_en(con_din_en)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		#2 rst =1;
		
		ts_din_1 = 0;
		ts_din_1_en = 0;
		ts_din_2 = 0;
		ts_din_2_en = 0;
		ts_din_3 = 0;
		ts_din_3_en = 0;
		ts_din_4 = 0;
		ts_din_4_en = 0;
		con_din = 0;
		con_din_en = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
    rst=0;
  end
   initial begin
    #102;
    ts1_send();
  end
		// Add stimulus here
		initial begin
    #102;
    ts2_send();
  end
  
  initial begin
    #102;
    ts3_send();
  end
  initial begin
    #102;
    ts4_send();
  end
	

	
	
	reg[7:0]i;
	
	task ts1_send;
	begin
	
	#10 ts_din_1_en=1;
	ts_din_1=32'h479fff00;
	#10 ts_din_1=0;
	#450 ts_din_1=32'h11111111;
	#10 ts_din_1_en=0;
	ts_din_1=0;
	
	#40;
	
	for (i=0;i<15;i=i+1)begin
	#10 ts_din_1_en=1;
	ts_din_1={24'h470112,i};
	#10 ts_din_1=0;
	#450 ts_din_1=32'h11111111;
	#10 ts_din_1_en=0;
	ts_din_1=0;
	
	
	#30;
end
	
	#100;
	
	
	#10 ts_din_1_en=1;
	ts_din_1=32'h479fff01;
	#10 ts_din_1=0;
	#450 ts_din_1=32'h11111111;
	#10 ts_din_1_en=0;
	ts_din_1=0;
	
	#40;
	
	for (i=0;i<12;i=i+1)begin
	#10 ts_din_1_en=1;
	ts_din_1={24'h470116,i};
	#10 ts_din_1=0;
	#450 ts_din_1=32'h11111111;
	#10 ts_din_1_en=0;
	ts_din_1=0;
	
	#30;
	
	end
	end

	endtask
	
	
	reg[7:0]i2;
	
	task ts2_send;
	begin
	
	#10 ts_din_2_en=1;
	ts_din_2=32'h479fff00;
	#10 ts_din_2=0;
	#450 ts_din_2=32'h11111111;
	#10 ts_din_2_en=0;
	ts_din_2=0;
	
	#40;
	
	for (i2=0;i2<15;i2=i2+1)begin
	#10 ts_din_2_en=1;
	ts_din_2={24'h470113,i2};
	#10 ts_din_2=0;
	#450 ts_din_2=32'h11111111;
	#10 ts_din_2_en=0;
	ts_din_2=0;
	
	
	#30;
end
	
	#100;
	
	
	#10 ts_din_2_en=1;
	ts_din_2=32'h479fff01;
	#10 ts_din_2=0;
	#450 ts_din_2=32'h11111111;
	#10 ts_din_2_en=0;
	ts_din_2=0;
	
	#40;
	
	for (i2=0;i2<15;i2=i2+1)begin
	#10 ts_din_2_en=1;
	ts_din_2={24'h470117,i2};
	#10 ts_din_2=0;
	#450 ts_din_2=32'h11111111;
	#10 ts_din_2_en=0;
	ts_din_2=0;
	
	#30;
	
	end
	end

	endtask
	
	
	reg[7:0]i3;
	
	task ts3_send;
	begin
	
	#10 ts_din_3_en=1;
	ts_din_3=32'h479fff00;
	#10 ts_din_3=0;
	#450 ts_din_3=32'h11111111;
	#10 ts_din_3_en=0;
	ts_din_3=0;
	
	#40;
	
	for (i3=0;i3<11;i3=i3+1)begin
	#10 ts_din_3_en=1;
	ts_din_3={24'h470114,i3};
	#10 ts_din_3=0;
	#450 ts_din_3=32'h11111111;
	#10 ts_din_3_en=0;
	ts_din_3=0;
	
	
	#30;
end
	
	#100;
	
	
//	#10 ts_din_3_en=1;
//	ts_din_3=32'h479fff01;
//	#10 ts_din_3=0;
//	#450 ts_din_3=32'h11111111;
//	#10 ts_din_3_en=0;
//	ts_din_3=0;
//	
	#40;
	
	for (i3=0;i3<15;i3=i3+1)begin
	#10 ts_din_3_en=1;
	ts_din_3={24'h470118,i3};
	#10 ts_din_3=0;
	#450 ts_din_3=32'h11111111;
	#10 ts_din_3_en=0;
	ts_din_3=0;
	
	#30;
	
	end
	end

	endtask
	
	
	
	reg[7:0]i4;
	
	task ts4_send;
	begin
	
	#10 ts_din_4_en=1;
	ts_din_4=32'h479fff00;
	#10 ts_din_4=0;
	#450 ts_din_4=32'h11111111;
	#10 ts_din_4_en=0;
	ts_din_4=0;
	
	#40;
	
	for (i4=0;i4<15;i4=i4+1)begin
	#10 ts_din_4_en=1;
	ts_din_4={24'h470115,i4};
	#10 ts_din_4=0;
	#450 ts_din_4=32'h11111111;
	#10 ts_din_4_en=0;
	ts_din_4=0;
	
	
	#30;
end
	
	#100;
	
	
	#10 ts_din_4_en=1;
	ts_din_4=32'h479fff01;
	#10 ts_din_4=0;
	#450 ts_din_4=32'h11111111;
	#10 ts_din_4_en=0;
	ts_din_4=0;
	
	#40;
	
	for (i4=0;i4<15;i4=i4+1)begin
	#10 ts_din_4_en=1;
	ts_din_4={24'h470119,i4};
	#10 ts_din_4=0;
	#450 ts_din_4=32'h11111111;
	#10 ts_din_4_en=0;
	ts_din_4=0;
	
	#30;
	
	end
	end

	endtask
      
      
  always #5 clk=~clk;    
endmodule

