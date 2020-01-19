`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:58:18 11/01/2019
// Design Name:   multi_ts_merge_v1
// Module Name:   E:/FPGA_pro/multi_ts_merge/multi_merge_v1_test.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: multi_ts_merge_v1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module multi_merge_v1_test;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] ts_din_1;
	reg ts_din_1_en;
	reg [7:0] ts_din_2;
	reg ts_din_2_en;
	reg [7:0] ts_din_3;
	reg ts_din_3_en;
	reg [7:0] ts_din_4;
	reg ts_din_4_en;
	reg [7:0] ts_din_5;
	reg ts_din_5_en;
	reg [7:0] ts_din_6;
	reg ts_din_6_en;
	reg [7:0] ts_din_7;
	reg ts_din_7_en;
	reg [7:0] ts_din_8;
	reg ts_din_8_en;
	reg [7:0] con_din;
	reg con_din_en;
	wire [7:0] ts_dout;
	wire ts_dout_syn;
	wire ts_dout_en;
	
	// Instantiate the Unit Under Test (UUT)
	multi_ts_merge_v1 uut (
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
		.ts_din_5(ts_din_5), 
		.ts_din_5_en(ts_din_5_en), 
		.ts_din_6(ts_din_6), 
		.ts_din_6_en(ts_din_6_en), 
		.ts_din_7(ts_din_7), 
		.ts_din_7_en(ts_din_7_en), 
		.ts_din_8(ts_din_8), 
		.ts_din_8_en(ts_din_8_en), 
    .con_din(con_din), 
    .con_din_en(con_din_en),
    .ts_dout(ts_dout),
    .ts_dout_syn(ts_dout_syn),
    .ts_dout_en(ts_dout_en)
	);

	integer i=0;
	integer k=0;
	integer	num;
	reg[3:0]cnt=0;
	
	reg[3:0]sl1,sl2;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		ts_din_1 = 0;
		ts_din_1_en = 0;
		ts_din_2 = 0;
		ts_din_2_en = 0;
		ts_din_3 = 0;
		ts_din_3_en = 0;
		ts_din_4 = 0;
		ts_din_4_en = 0;
		ts_din_5 = 0;
		ts_din_5_en = 0;
		ts_din_6 = 0;
		ts_din_6_en = 0;
		ts_din_7 = 0;
		ts_din_7_en = 0;
		ts_din_1 = 0;
		ts_din_1_en = 0;
		ts_din_8 = 0;
		ts_din_8_en = 0;
		con_din	=	0;
		con_din_en	=	0;
		
		#3 rst	=1;
		// Wait 100 ns for global reset to finish
		#100;
		rst =0;
        
		// Add stimulus here
		
		
		#10 con_din_en=1;
		con_din=8'h11;
		#10 con_din=8'h11;
		#10 con_din=8'h11;
		#10 con_din=8'h11;
		#10 con_din=8'h0;
		#10 con_din=8'h0;
		#10 con_din=8'h0;
		#10 con_din=8'h0;
		#10 con_din=8'h0;
		con_din_en=0;
		
		
		#100;
		
		num=49;
		tsmf_send_1();
		#100;
		
		for(k=1;k<num-1;k=k+1)
		ts_send_1();

		#100;
		num=34;
		cnt=cnt+1;
		tsmf_send_2();
		
		#100;
		
		for(k=1;k<num;k=k+1)
		ts_send_2();
		
			#100;
		num=24;
		cnt=cnt+1;
		tsmf_send_3();
		
		#100;
		
		for(k=1;k<num;k=k+1)
		ts_send_3();
		
		
		#100;
		
		num=23;
		cnt=cnt+1;
		tsmf_send_4();
		#100;
		
		for(k=1;k<num;k=k+1)
		ts_send_4();
		
		
		#100;
		
		num=23;
		cnt=cnt+1;
		tsmf_send_1();
		#100;
		
		for(k=1;k<num;k=k+1)
		ts_send_1();


	
	end
	
	always #5 clk=!clk;
	
	task tsmf_send_1();
 	begin
 		#10 ts_din_1=8'h47;
 		ts_din_1_en=1;
 		#10 ts_din_1=8'h1f;
 		#10 ts_din_1=8'hfe;
 		#10 ts_din_1={4'h1,cnt};
 		#10 ts_din_1=8'h1a;
 		#10 ts_din_1=8'h86;
 		#10 ts_din_1=8'h00;
 		#10 ts_din_1=8'h00;
 		#10 ts_din_1=8'h00;
 		#10 ts_din_1=8'h00;
 		#10 ts_din_1=8'h00;
 		#10 ts_din_1=8'h00;
 		for(i=1;i<num;i=i+1)begin
 			sl1	={$random}%14+1;
 			sl2	={$random}%14+1;
 			#10 ts_din_1={sl1,sl2};
 		end
 		
 		for(i=1;i<185-num;i=i+1)
 		#10 ts_din_1=0;
 		#10 ts_din_1_en=0;
 		
	end
	endtask
 	
 	task ts_send_1();
 	begin
 	
 		#10 ts_din_1=8'h47;
 		ts_din_1_en=1;
 		#10 ts_din_1=8'h10;
 		#10 ts_din_1=8'h11;
 		#10 ts_din_1=8'h13;
 		
 		for(i=1;i<185;i=i+1)
 		begin
 			#10 ts_din_1=i;
 		end
 		
 		#10 ts_din_1	=0;
 		ts_din_1_en	=0;
 		#100;
 	end
 	endtask    
 	
 	task tsmf_send_2();
 	begin
 		#10 ts_din_2=8'h47;
 		ts_din_2_en=1;
 		#10 ts_din_2=8'h1f;
 		#10 ts_din_2=8'hfe;
 		#10 ts_din_2={4'h1,cnt};
 		#10 ts_din_2=8'h1a;
 		#10 ts_din_2=8'h86;
 		#10 ts_din_2=8'h00;
 		#10 ts_din_2=8'h00;
 		#10 ts_din_2=8'h00;
 		#10 ts_din_2=8'h00;
 		#10 ts_din_2=8'h00;
 		#10 ts_din_2=8'h00;
 		for(i=1;i<num;i=i+1)begin
 			sl1	={$random}%14+1;
 			sl2	={$random}%14+1;
 			#10 ts_din_2={sl1,sl2};
 		end
 		
 		for(i=1;i<185-num;i=i+1)
 		#10 ts_din_2=0;
 		#10 ts_din_2_en=0;
 		
	end
	endtask
 	
 	task ts_send_2();
 	begin
 	
 		#10 ts_din_2=8'h47;
 		ts_din_2_en=1;
 		#10 ts_din_2=8'h10;
 		#10 ts_din_2=8'h11;
 		#10 ts_din_2=8'h13;
 		
 		for(i=1;i<185;i=i+1)
 		begin
 			#10 ts_din_2=i;
 		end
 		
 		#10 ts_din_2	=0;
 		ts_din_2_en	=0;
 		#100;
 	end
 	endtask    
	
	
	task tsmf_send_3();
 	begin
 		#10 ts_din_3=8'h47;
 		ts_din_3_en=1;
 		#10 ts_din_3=8'h1f;
 		#10 ts_din_3=8'hfe;
 		#10 ts_din_3={4'h1,cnt};
 		#10 ts_din_3=8'h1a;
 		#10 ts_din_3=8'h86;
 		#10 ts_din_3=8'h00;
 		#10 ts_din_3=8'h00;
 		#10 ts_din_3=8'h00;
 		#10 ts_din_3=8'h00;
 		#10 ts_din_3=8'h00;
 		#10 ts_din_3=8'h00;
 		for(i=1;i<num;i=i+1)begin
 			sl1	={$random}%14+1;
 			sl2	={$random}%14+1;
 			#10 ts_din_3={sl1,sl2};
 		end
 		
 		for(i=1;i<185-num;i=i+1)
 		#10 ts_din_3=0;
 		#10 ts_din_3_en=0;
 		
	end
	endtask
 	
 	task ts_send_3();
 	begin
 	
 		#10 ts_din_3=8'h47;
 		ts_din_3_en=1;
 		#10 ts_din_3=8'h10;
 		#10 ts_din_3=8'h11;
 		#10 ts_din_3=8'h13;
 		
 		for(i=1;i<185;i=i+1)
 		begin
 			#10 ts_din_3=i;
 		end
 		
 		#10 ts_din_3	=0;
 		ts_din_3_en	=0;
 		#100;
 	end
 	endtask
 	
 	
 	task tsmf_send_4();
 	begin
 		#10 ts_din_4=8'h47;
 		ts_din_4_en=1;
 		#10 ts_din_4=8'h1f;
 		#10 ts_din_4=8'hfe;
 		#10 ts_din_4={4'h1,cnt};
 		#10 ts_din_4=8'h1a;
 		#10 ts_din_4=8'h86;
 		#10 ts_din_4=8'h00;
 		#10 ts_din_4=8'h00;
 		#10 ts_din_4=8'h00;
 		#10 ts_din_4=8'h00;
 		#10 ts_din_4=8'h00;
 		#10 ts_din_4=8'h00;
 		for(i=1;i<num;i=i+1)begin
 			sl1	={$random}%14+1;
 			sl2	={$random}%14+1;
 			#10 ts_din_4={sl1,sl2};
 		end
 		
 		for(i=1;i<185-num;i=i+1)
 		#10 ts_din_4=0;
 		#10 ts_din_4_en=0;
 		
	end
	endtask
 	
 	task ts_send_4();
 	begin
 	
 		#10 ts_din_4=8'h47;
 		ts_din_4_en=1;
 		#10 ts_din_4=8'h10;
 		#10 ts_din_4=8'h11;
 		#10 ts_din_4=8'h13;
 		
 		for(i=1;i<185;i=i+1)
 		begin
 			#10 ts_din_4=i;
 		end
 		
 		#10 ts_din_4	=0;
 		ts_din_4_en	=0;
 		#100;
 	end
 	endtask
	
      
endmodule

