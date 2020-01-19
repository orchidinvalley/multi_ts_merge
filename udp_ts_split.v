`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:22 08/15/2019 
// Design Name: 
// Module Name:    udp_ts_split 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 将光口解析出来的UDP ts包拆分成ip+port+ts的格式。
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module udp_ts_split #(
	parameter SFP_NUM=8'd1
	)
(
	clk,
	rst,
	
	udp_din,
	udp_din_en,
	
	ts_dout,
	ts_dout_en


    );
    
    input		clk;
    input 	rst;
    
    input	[7:0]udp_din;
    input			udp_din_en;
    
    
    output [32:0]ts_dout;
    output 		ts_dout_en;
    
    reg		[32:0]ts_dout;
    reg				ts_dout_en;
    
    
    
    
    reg [1:0]wcstate;
    reg	[1:0]wnstate;
    
    parameter W_IDLE=2'b00,
    					W_DATA=2'b01,
    					W_OVER=2'b10;
    					
    reg 	sof;
    reg		eof;
    reg		udp_din_en_r;
    reg		udp_din_en_rr;
    
    wire 	prog_full;
    wire 	empty;
    
    reg	[31:0]fifo_wdata;
    reg		fifo_wr;
    wire	[32:0]fifo_rdata;
    wire		fifo_rd;
    
    
    reg	[7:0]udp_din_r,udp_din_rr;
    reg	[1:0]round_cnt;
    reg	[10:0]wr_cnt;
    
    
    reg	[2:0]frame_cnt;
    reg	frame_inc;
    reg	frame_dec;
    
    reg	[3:0]rcstate;
    reg	[3:0]rnstate;
    
    parameter R_IDLE=0,
    					R_SFP=1,
    					R_IP=2,
    					R_PORT=3,
    					R_SEND_SFP=4,
    					R_SEND_IP=5,
    					R_SEND_PORT=6,
    					R_SEND_TS=7,
    					R_INTERVAL=8,
    					R_FRAME_INTERVAL=9;
    					
    reg	[7:0]	sfp_num;
    reg	[31:0]ip;
    reg	[15:0]port;					
    reg	[7:0]interval_cnt;//32位 TS包间隔
    parameter	INTERVAL=70;
    reg	[5:0]ts_cnt;
    
    
    always@(posedge clk)begin
    	udp_din_en_r	<=udp_din_en;
    	udp_din_en_rr	<=udp_din_en_r;
    	sof		<=udp_din_en&!udp_din_en_r;
    	eof		<=!udp_din_en_r&udp_din_en_rr;
    	
    	udp_din_r	<=	udp_din;
    	udp_din_rr	<=	udp_din_r;
    end
    
    always@(posedge clk)begin
    	if(eof&&wcstate==W_DATA)
    		frame_inc	<=1;
    	else
    		frame_inc	<=0;
    end
    
    always@(posedge clk)begin
    	if(rcstate==R_SFP)
    		frame_dec	<=1;
    	else
    		frame_dec	<=0;
    end
    
    
    always@(posedge clk)begin
    	if(empty)
    		frame_cnt	<=0;
    	else if(frame_inc && !frame_dec)
    		frame_cnt	<=frame_cnt+1;
    	else if(!frame_inc&& frame_dec)
    		frame_cnt	<=frame_cnt-1;
    	else
    		frame_cnt	<=frame_cnt;
    end

    					
    always@(posedge clk)begin
    	if(rst)
    		wcstate	<=W_IDLE;
    	else
    		wcstate	<=wnstate;
    end					
    
    always@(*)begin
    	case(wcstate)
    	W_IDLE:
    		if(sof)
    			if(prog_full)
    				wnstate	= W_OVER;
    			else
    				wnstate	=	W_DATA;
    		else
    			wnstate	=	W_IDLE;
    	W_DATA:
    		if(eof)
    			wnstate	=	W_IDLE;
    		else
    			wnstate	=	W_DATA;
    	W_OVER:
    		if(eof)
    			wnstate	=	W_IDLE;
    		else
    			wnstate	=	W_OVER;
    	default:
    		wnstate	=W_IDLE;
    	endcase    
    end
    
    always@(posedge clk)begin
    	if(wnstate==W_DATA)
    		if(wr_cnt==0)
    			fifo_wdata	<={23'b0,SFP_NUM};
    		else
    			fifo_wdata	<=	{fifo_wdata[23:0],udp_din_rr};
    	else
    		fifo_wdata	<=	32'b0;
    end
    
    always@(posedge clk)begin
    	if(wnstate==W_DATA&&(wr_cnt==0||wr_cnt==4||wr_cnt==6||round_cnt==2'b11))
    		fifo_wr	<=1;
    	else
    		fifo_wr	<=0;
    	
    end
    
    				
    				
    always@(posedge clk)begin
    	if(rst)
    		wr_cnt	<=0;
    	else if(wnstate==W_DATA)
    		wr_cnt	<=wr_cnt+1;
    	else
    		wr_cnt	<=0;
    end
    
    always@(posedge clk)begin
    	if(wr_cnt>6)
    		round_cnt<=round_cnt+1;
    	else
    		round_cnt	<=0;
    end
    
    
    always@(posedge clk)begin
    if(rst)
    	rcstate	<=	R_IDLE;
    else
    	rcstate	<=	rnstate;
    end
    
    always@(*)begin
    	case(rcstate)
    	R_IDLE:
    		if(frame_cnt>0)
    			rnstate	=	R_SFP;
    		else 
    			rnstate	= R_IDLE;
    	R_SFP:
    		rnstate	=	R_IP;
    	R_IP:
    		rnstate	=	R_PORT;
    	R_PORT:
    		rnstate	=	R_SEND_SFP;
    	R_SEND_SFP:
    		rnstate	=	R_SEND_IP;
    	R_SEND_IP:
    		rnstate	=	R_SEND_PORT;
    	R_SEND_PORT:
    		rnstate	=	R_SEND_TS;
    	R_SEND_TS:
    		if(fifo_rdata[32])
    			rnstate	= R_FRAME_INTERVAL;
    		else if(ts_cnt==46)
    			rnstate	=	R_INTERVAL;
    		else
    			rnstate	=	R_SEND_TS;
    	R_INTERVAL:
    		if(interval_cnt	==INTERVAL)
    			rnstate	=	R_SEND_SFP;
    		else
    			rnstate	=	R_INTERVAL;
    	default:
    		rnstate	= R_IDLE;
    	endcase
    end
    				
		assign fifo_rd	=	(rnstate==R_SFP)||(rnstate==R_IP)||(rnstate==R_PORT)||(rnstate==R_SEND_TS);
    				
    always@(posedge clk)begin
    	if(rcstate==R_SFP)
    		sfp_num	<=	fifo_rdata[7:0];
    	else
    		sfp_num	<=	sfp_num;
    end
    
    always@(posedge clk)begin
    	if(rcstate==R_IP)
    		ip	<=	fifo_rdata[31:0];
    	else
    		ip	<=	ip;
    end
    
    always@(posedge clk)begin
    	if(rcstate	==R_PORT)
    		port	<=	fifo_rdata[15:0];
    	else
    		port	<=	port;
    end
    
    always@(posedge clk)begin
    if(rcstate==R_SEND_TS)
    	ts_cnt	<=ts_cnt+1;
    else
    	ts_cnt	<=0;
    end
		
		always@(posedge clk)begin
			if(rcstate==R_INTERVAL || rcstate==R_FRAME_INTERVAL)
				interval_cnt	<= interval_cnt+1;
			else
				interval_cnt	<= 0;
		end
		
		always@(posedge clk)begin
			if(rcstate==R_SEND_SFP)begin
				ts_dout	<={1'b1,24'b0,sfp_num};
				ts_dout_en	<=1;
			end
			else if(rcstate==R_SEND_IP)begin
				ts_dout	<={1'b0,ip};
				ts_dout_en	<=1;
			end
			else if(rcstate==R_SEND_PORT)begin
				ts_dout	<={1'b0,16'b0,port};
				ts_dout_en	<=1;
			end
			else	if(rcstate==R_SEND_TS)begin
				ts_dout	<={1'b0,fifo_rdata[31:0]};
				ts_dout_en	<=1;
			end
			else begin
				ts_dout	<=0;
				ts_dout_en	<=0;
			end
		end
    				
    udp_ts_spilt_fifo udp_ts_split_uut (
		  .clk(clk), // input clk
		  .rst(rst), // input rst
		  .din({eof,fifo_wdata}), // input [32 : 0] din
		  .wr_en(fifo_wr), // input wr_en
		  .rd_en(fifo_rd), // input rd_en
		  .dout(fifo_rdata), // output [32 : 0] dout
		  .full(), // output full
		  .empty(empty), // output empty
		  .prog_full(prog_full) // output prog_full
		);				
    					
    


endmodule
