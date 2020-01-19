`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:27:35 09/27/2019 
// Design Name: 
// Module Name:    nit_replace 
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
module nit_replace(

	clk,
	rst,
	
	ts_din,
	ts_din_en,
	
	nit_con,
	nit_con_en,
	
	ts_dout,
	ts_dout_en


    );


	input 	clk;
	input 	rst;
	
	input		[31:0]ts_din;
	input		ts_din_en;
	
	input 	[7:0]nit_con;
	input		nit_con_en;
	
	output 	[31:0]ts_dout;
	output 	ts_dout_en;
		
	reg 	[31:0]ts_dout;
	reg 	ts_dout_en;
	
	
	reg		[31:0]ts_din_r;
	reg		ts_din_en_r;
	
	
	reg	[5:0]ts_cnt;
	
	reg	[3:0]nit_num;
	
	reg	nit_enable;
	
	reg	wr;
	reg	[11:0]wr_addr;
	reg	[7:0]wr_data;
	wire	[9:0]rd_addr;
	wire [31:0]rd_data;
	
	reg	[7:0]nit_cnt;
	reg	[3:0]nit_w_pack;
	
	reg	wcstate;
	reg	wnstate;
	
	
	parameter	W_IDLE=0,
						W_NIT=1;
	
	
	reg	[2:0]	rcstate;
	reg	[2:0]	rnstate;
	reg	[5:0]	send_cnt;	
	reg	[3:0]	nit_cc;
	reg	[3:0]	nit_r_pack;
	
	parameter	R_IDLE=0,
						R_ENABLE=1,
						R_NIT=2,
						R_INTERVAL=3;
						
						
	
	always@(posedge clk)begin
		ts_din_r		<=ts_din;
		ts_din_en_r	<=ts_din_en;
	end
	
	always@(posedge clk)begin
		if(rst)
			wcstate		<=	W_IDLE;
		else
			wcstate		<=	wnstate;
	end
	
	always@(*)begin
		case(wcstate)
			W_IDLE:
				if(nit_con_en)
					wnstate	=	W_NIT;
				else
					wnstate	=	W_IDLE;
			W_NIT:
				if(!nit_con_en)
					wnstate	=	W_IDLE;
				else
					wnstate	=	W_NIT;
		endcase
	end
	
	always@(posedge clk)begin
		if(wcstate	==	W_NIT)begin
			if(nit_cnt==187)
				nit_cnt	<=0;
			else
				nit_cnt	<=nit_cnt+1;
		end
		else 
			nit_cnt		<=0;			
	end
	
	always@(posedge clk)begin
		if(rst)
			nit_w_pack	<=0;
		else if(wcstate	==	W_NIT && nit_cnt==187)
			nit_w_pack	<=nit_w_pack+1;
		else
			nit_w_pack	<=nit_w_pack;
	end
	
	always@(posedge clk)begin
		if(wcstate==W_NIT&& nit_con_en)begin
			wr			<=1;
			wr_data	<=nit_con;
			wr_addr	<={nit_w_pack,nit_cnt};
		end
//		else if(rcstate==R_NIT && send_cnt==3)begin
//			wr			<=1;
//			wr_data	<={rd_data[7:4],nit_cc};
//			wr_addr	<=3;
//		end
		else begin
			wr			<=0;
			wr_data	<=0;
			wr_addr	<=0;
		end
	end
		
		
	always@(posedge clk)begin
		if(rst)
			nit_num		<=0;
		else if(wcstate==W_IDLE	&&nit_con_en)
			nit_num		<=nit_con[3:0];
	end
	
	always@(posedge clk)begin
		if(wcstate	==W_IDLE && wnstate	==W_NIT)
			nit_enable	<=0;
		else if(wcstate	==W_NIT && wnstate	==	W_IDLE)
			nit_enable	<=1;
		else
			nit_enable	<=nit_enable;
	end
	
	always@(posedge clk)begin
		if(rst)
			ts_cnt	<=0;
		else if(ts_din_en)
			ts_cnt	<=ts_cnt+1;
		else
			ts_cnt	<=0;
	end
	
	
	
	
	
	always@(posedge clk)begin
		if(rst)
			rcstate		<=	R_IDLE;
		else
			rcstate		<=	rnstate;	
	end
	
	
	always@(*)begin
		case(rcstate)
			R_IDLE:
				if(nit_enable)
					rnstate	=	R_ENABLE;
				else
					rnstate	=	R_IDLE;
			R_ENABLE:
				if(!nit_enable)
					rnstate	=	R_IDLE;
				else if(ts_cnt==1 && ts_din[31:24]==8'h47&& ts_din[20:8]==13'h001)
					rnstate	=	R_NIT;
				else
					rnstate	=	R_ENABLE;
			R_NIT:
				if(send_cnt==47)
					rnstate	=	R_INTERVAL;
				else
					rnstate	=	R_NIT;
			R_INTERVAL:
				if(nit_enable)
					rnstate	=	R_ENABLE;
				else
					rnstate	=	R_IDLE;
			default:
				rnstate	=	R_IDLE;
		endcase
	end
	
	
	always@(posedge clk)begin
		if(rnstate==R_NIT)
			send_cnt	<=	send_cnt	+1;
		else
			send_cnt	<=0;
	end
	
	always@(posedge clk)begin
		if(rst)
			nit_r_pack	<=0;
		else if(rcstate	==	R_NIT && send_cnt==47)
			if(nit_r_pack+1==nit_num)
				nit_r_pack	<=0;
			else
				nit_r_pack	<=	nit_r_pack	+1;
		else
			nit_r_pack	<=	nit_r_pack;
	end
	
	assign rd_addr={nit_r_pack,send_cnt};
	
	always@(posedge clk)begin
		if(rcstate==R_NIT)begin
			if(send_cnt==1)
				ts_dout			<={rd_data[7:0], rd_data[15:8],rd_data[23:16],rd_data[31:28],nit_cc};
			else
				ts_dout		<={rd_data[7:0],rd_data[15:8],rd_data[23:16],rd_data[31:24]};
			ts_dout_en	<=1;
		end
		else begin
			ts_dout			<=	ts_din_r;
			ts_dout_en	<=	ts_din_en_r;
		end
	end
	
	always@(posedge clk)begin
		if(rst)
			nit_cc		<=0;
		else if(rcstate==R_NIT &&ts_cnt==47)
			nit_cc		<=nit_cc+1;
		else
			nit_cc		<=nit_cc;
	end
	
	nit_ram nit_ram_uut (
  .clka(clk), // input clka
  .wea(wr), // input [0 : 0] wea
  .addra(wr_addr), // input [11 : 0] addra
  .dina(wr_data), // input [7 : 0] dina
  .clkb(clk), // input clkb
  .addrb(rd_addr), // input [9 : 0] addrb
  .doutb(rd_data) // output [31 : 0] doutb
);
	
	
	
	
	

endmodule
