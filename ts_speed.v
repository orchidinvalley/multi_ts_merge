`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:20:54 09/30/2019 
// Design Name: 
// Module Name:    ts_speed 
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
module ts_speed(

		clk,
		rst,
		
		ts_din,
		ts_din_en,
		
		rate_dout,
		rate_dout_en,
		
		rate_con_start,
		rate_con_end


    );
    
    
    input clk;
    input rst;
    
    input	[31:0]ts_din;
    input 	ts_din_en;
    
    input	rate_con_start;
    input rate_con_end;
    
    output [7:0]rate_dout;
    output	rate_dout_en;
    
    reg [7:0]rate_dout;
    reg	rate_dout_en;
    
    
    reg[23:0]rate_1;
    reg[23:0]rate_2;
    reg[23:0]rate_3;
    reg[23:0]rate_4;
    reg[23:0]rate_5;
    reg[23:0]rate_6;
    reg[23:0]rate_7;
    reg[23:0]rate_8;
    reg[23:0]rate_9;
    reg[23:0]rate_10;
    reg[23:0]rate_11;
    reg[23:0]rate_12;
    reg[23:0]rate_13;
    reg[23:0]rate_14;
    reg[23:0]rate_15;
    
    reg	ts_din_en_r;
    
//    parameter SECOND=24'h9E4F580;
		parameter SECOND=24'h400;
    
    reg	[23:0]second_cnt;
    
    reg	[7:0]send_cnt;
    
    reg	[1:0]rate_cstate;
    reg	[1:0]rate_nstate;
    
    parameter	IDLE=0,
    					RATE_START=1,
    					RATE_REC=2,
    					RATE_SEND=3;
    
    
    always@(posedge clk)begin
    	
    	ts_din_en_r		<=	ts_din_en;	
    	
    	if(rst)
    		rate_cstate	<=	IDLE;
    	else
    		rate_cstate	<=	rate_nstate;
    end
    
    
    
    always@(*)begin
    	case(rate_cstate)
    		IDLE:
    			if(rate_con_start)
    				rate_nstate	=	RATE_START;
    			else
    				rate_nstate	=	IDLE;
    		RATE_START:
    			if(rate_con_end)
    				rate_nstate	=	IDLE;
    			else
    				rate_nstate	=	RATE_REC;
    		RATE_REC:
    			if(rate_con_end)
    				rate_nstate	=	IDLE;
    			else if(second_cnt==SECOND)
    				rate_nstate	=	RATE_SEND;
    			else
    				rate_nstate	=	RATE_REC;
    		RATE_SEND:
    			if(rate_con_end)
    				rate_nstate	=	IDLE;
    			else if(send_cnt==52)
    				rate_nstate	=	RATE_START;
    			else
    				rate_nstate	=	RATE_SEND;
    		default:
    			rate_nstate	=	IDLE;    			
    	endcase
    end
    
    always@(posedge clk)begin
    	if(rst)
    		second_cnt	<=0;
    	else if(rate_cstate==RATE_REC)
    		second_cnt	<=second_cnt+1;
    	else
    		second_cnt	<=0;
   	end
   	
   	
   	always@(posedge clk)begin
   		if(rst)
   			send_cnt	<=	0;
   		else 	if(rate_cstate==RATE_SEND)
   			send_cnt	<=	send_cnt+1;
   		else
   			send_cnt	<=0;
   	end
   	
   	always@(posedge clk)begin
   		if(rst)
   			rate_1	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_1	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==1)
   				rate_1	<=rate_1+1;
   			else
   				rate_1	<=rate_1;
   		end
   		else
   			rate_1	<=rate_1;
   	end
   	
   	always@(posedge clk)begin
   		if(rst)
   			rate_2	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_2	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==2)
   				rate_2	<=rate_2+1;
   			else
   				rate_2	<=rate_2;
   		end
   		else
   			rate_2	<=rate_2;
   	end


		always@(posedge clk)begin
   		if(rst)
   			rate_3	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_3	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==3)
   				rate_3	<=rate_3+1;
   			else
   				rate_3	<=rate_3;
   		end
   		else
   			rate_3	<=rate_3;
   	end
   	
   	
   	always@(posedge clk)begin
   		if(rst)
   			rate_4	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_4	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==4)
   				rate_4	<=rate_4+1;
   			else
   				rate_4	<=rate_4;
   		end
   		else
   			rate_4	<=rate_4;
   	end
   	
   	
   	always@(posedge clk)begin
   		if(rst)
   			rate_5	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_5	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==5)
   				rate_5	<=rate_5+1;
   			else
   				rate_5	<=rate_5;
   		end
   		else
   			rate_5	<=rate_5;
   	end
		
		
		always@(posedge clk)begin
   		if(rst)
   			rate_6	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_6	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==6)
   				rate_6	<=rate_6+1;
   			else
   				rate_6	<=rate_6;
   		end
   		else
   			rate_6	<=rate_6;
   	end

		always@(posedge clk)begin
   		if(rst)
   			rate_7	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_7	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==7)
   				rate_7	<=rate_7+1;
   			else
   				rate_7	<=rate_7;
   		end
   		else
   			rate_7	<=rate_7;
   	end
   	
   	
   	always@(posedge clk)begin
   		if(rst)
   			rate_8	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_8	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==8)
   				rate_8	<=rate_8+1;
   			else
   				rate_8	<=rate_8;
   		end
   		else
   			rate_8	<=rate_8;
   	end
   	
   	always@(posedge clk)begin
   		if(rst)
   			rate_9	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_9	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==9)
   				rate_9	<=rate_9+1;
   			else
   				rate_9	<=rate_9;
   		end
   		else
   			rate_9	<=rate_9;
   	end
   	
   	
   	always@(posedge clk)begin
   		if(rst)
   			rate_10	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_10	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==10)
   				rate_10	<=rate_10+1;
   			else
   				rate_10	<=rate_10;
   		end
   		else
   			rate_10	<=rate_10;
   	end
   	
   	
   	always@(posedge clk)begin
   		if(rst)
   			rate_11	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_11	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==11)
   				rate_11	<=rate_11+1;
   			else
   				rate_11	<=rate_11;
   		end
   		else
   			rate_11	<=rate_11;
   	end
   	
   	always@(posedge clk)begin
   		if(rst)
   			rate_12	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_12	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==12)
   				rate_12	<=rate_12+1;
   			else
   				rate_12	<=rate_12;
   		end
   		else
   			rate_12	<=rate_12;
   	end
   	
   	
   	always@(posedge clk)begin
   		if(rst)
   			rate_13	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_13	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==13)
   				rate_13	<=rate_13+1;
   			else
   				rate_13	<=rate_13;
   		end
   		else
   			rate_13	<=rate_13;
   	end
   	
   	always@(posedge clk)begin
   		if(rst)
   			rate_14	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_14	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==14)
   				rate_14	<=rate_14+1;
   			else
   				rate_14	<=rate_14;
   		end
   		else
   			rate_14	<=rate_14;
   	end
   	
   	
   	always@(posedge clk)begin
   		if(rst)
   			rate_15	<=0;
   		else if(rate_cstate	==RATE_START)
   			rate_15	<=0;
   		else if(rate_cstate==RATE_REC)begin
   			if(ts_din_en&&~ts_din_en_r&&ts_din==15)
   				rate_15	<=rate_15+1;
   			else
   				rate_15	<=rate_15;
   		end
   		else
   			rate_15	<=rate_15;
   	end
   	
   	always@(posedge clk)begin
   		if(rst)begin
   			rate_dout			<=	0;
   			rate_dout_en	<=	0;
   		end	
   		else if(rate_cstate==RATE_SEND)begin
   				rate_dout_en	<=	1;
   			case(send_cnt)
   				0:rate_dout	<=8'h04;
   				1:rate_dout	<=8'h05;
   				2:rate_dout	<=8'h00;
   				3:rate_dout	<=8'h01;
   				4:rate_dout	<=8'h00;
   				5:rate_dout	<=8'h01;
   				6:rate_dout	<=8'h00;
   				7:rate_dout	<=8'h01;
   				8:rate_dout	<=rate_1[23:16];
   				9:rate_dout	<=rate_1[15:8];
   				10:rate_dout	<=rate_1[7:0];
   				11:rate_dout	<=rate_2[23:16];
   				12:rate_dout	<=rate_2[15:8];
   				13:rate_dout	<=rate_2[7:0];
   				14:rate_dout	<=rate_3[23:16];
   				15:rate_dout	<=rate_3[15:8];
   				16:rate_dout	<=rate_3[7:0];
   				17:rate_dout	<=rate_4[23:16];
   				18:rate_dout	<=rate_4[15:8];
   				19:rate_dout	<=rate_4[7:0];
   				20:rate_dout	<=rate_5[23:16];
   				21:rate_dout	<=rate_5[15:8];
   				22:rate_dout	<=rate_5[7:0];
   				23:rate_dout	<=rate_6[23:16];
   				24:rate_dout	<=rate_6[15:8];
   				25:rate_dout	<=rate_6[7:0];
   				26:rate_dout	<=rate_7[23:16];
   				27:rate_dout	<=rate_7[15:8];
   				28:rate_dout	<=rate_7[7:0];
   				29:rate_dout	<=rate_8[23:16];
   				30:rate_dout	<=rate_8[15:8];
   				31:rate_dout	<=rate_8[7:0];
   				32:rate_dout	<=rate_9[23:16];
   				33:rate_dout	<=rate_9[15:8];
   				34:rate_dout	<=rate_9[7:0];
   				35:rate_dout	<=rate_10[23:16];
   				36:rate_dout	<=rate_10[15:8];
   				37:rate_dout	<=rate_10[7:0];
   				38:rate_dout	<=rate_11[23:16];
   				39:rate_dout	<=rate_11[15:8];
   				40:rate_dout	<=rate_11[7:0];
   				41:rate_dout	<=rate_12[23:16];
   				42:rate_dout	<=rate_12[15:8];
   				43:rate_dout	<=rate_12[7:0];
   				44:rate_dout	<=rate_13[23:16];
   				45:rate_dout	<=rate_13[15:8];
   				46:rate_dout	<=rate_13[7:0];
   				47:rate_dout	<=rate_14[23:16];
   				48:rate_dout	<=rate_14[15:8];
   				49:rate_dout	<=rate_14[7:0];
   				50:rate_dout	<=rate_15[23:16];
   				51:rate_dout	<=rate_15[15:8];
   				52:rate_dout	<=rate_15[7:0];
   				default:begin
   					rate_dout			<=	0;
   					rate_dout_en	<=	0;
   				end
   			endcase
   		end
   		else begin
   			rate_dout			<=	0;
   			rate_dout_en	<=	0;
   		end   		
   	end
   	

endmodule
