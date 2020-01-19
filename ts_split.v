`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:01:02 08/19/2019 
// Design Name: 
// Module Name:    ts_split 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ts_split(
	clk,
	rst,
	
	ts_din,
	ts_din_en

    );
    
  input		clk;
  input   rst;
  input [31:0]ts_din;
  input 	ts_din_en;


endmodule
