`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:54:14 07/27/2019 
// Design Name: 
// Module Name:    clk_div 
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
module clk_div(
		clk,
		
		rst,
		
		clk_div

    );
    
    
    input clk;
    input rst;
    output clk_div;
    

    
    reg clk_div;
    
    reg [2:0]cnt;
    
    
    always@(posedge clk)begin
    	if(rst)
    		cnt	<=0;
    	else if(cnt==6)
    		cnt <=0;
    	else
    		cnt	<=cnt+1;
    end
    
    always@(posedge clk)begin
    	if(rst)
    		clk_div	=0;
    	else begin
    		case(cnt)
    			0,1,2,3:
    				clk_div	=1;
    		
    			4,5,6:
    				clk_div	=0;
    			endcase
    	end
    end
    


endmodule
