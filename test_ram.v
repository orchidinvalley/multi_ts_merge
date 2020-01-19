`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:40:26 08/22/2019
// Design Name:   ts_split_ram
// Module Name:   E:/FPGA_pro/multi_ts_merge/test_ram.v
// Project Name:  multi_ts_merge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ts_split_ram
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_ram;

	// Inputs
	reg clk;
	reg [0:0] wea;
	reg [14:0] addra;
	reg [31:0] dina;

	reg [12:0] addrb;

	// Outputs
	wire [127:0] doutb;
	
	reg [127:0] pcie;

	// Instantiate the Unit Under Test (UUT)
	ts_split_ram uut (
		.clka(clk), 
		.wea(wea), 
		.addra(addra), 
		.dina(dina), 
		.clkb(clk), 
		.addrb(addrb), 
		.doutb(doutb)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		wea = 0;
		addra = 0;
		dina = 0;

		addrb = 0;

		// Wait 100 ns for global reset to finish
		#100;
    #2 wea=1;
    addra=0;
    dina=32'h11223344;
    #10   addra=1;    
    dina=32'h55667788;
     #10   addra=2;    
    dina=32'h99aabbcc;
     #10   addra=3;    
    dina=32'hddeeff00;
    #10 wea=0;
     
  
		// Add stimulus here

	end
  always #5 clk=!clk;
  
  always #10 pcie={doutb[103:96],doutb[111:104],doutb[119:112],doutb[127:120],
												doutb[71:64],doutb[79:72],doutb[87:80],doutb[95:88],
												doutb[39:32],doutb[47:40],doutb[55:48],doutb[63:56],
												doutb[7:0],doutb[15:8],doutb[23:16],doutb[31:24]};
 
endmodule

