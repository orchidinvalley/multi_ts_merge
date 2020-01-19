`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:27 09/10/2019 
// Design Name: 
// Module Name:    pcie_ts_rd 
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
module pcie_ts_rd(

		clk_ts,
		rst_ts,
		
		ts_ram_wr,
		ts_ram_wdata,




		clk,
		rst,

		
		dma_raddr_en,					//: in std_logic;
		dma_raddr,						// : in std_logic_vector(31 downto 0);
		dma_rdata_rdy,				// : out std_logic;
		dma_rdata_busy, 				//: out std_logic;
		dma_rdata	,					// : out std_logic_vector(63 downto 0);
		
		ott_ram_clear,
		ott_raddr,
		ott_doutb,
		dvb_raddr,
		dvb_doutb,

		ts_ram_valid,
		test_flag

    );
    
   input		clk;
   input		rst;
   
   input  	dma_raddr_en;
   input		[31:0]dma_raddr;
   
   
   output 	dma_rdata_rdy;
   output 	[63:0]dma_rdata;
   
   
	input							ott_ram_clear;
	output 	[13:0]		ott_raddr;
	input 	[63:0]		ott_doutb;
	output 	[5:0]			dvb_raddr;
	input 	[511:0]		dvb_doutb;

	input 	ts_ram_valid;


	output test_flag;
	   
	 reg	ts_ram_wr_r;  
   
   reg	[1:0]wcstate;
   reg	[1:0]wnstate;
   
   parameter	WR_IDLE=0,
   						WR_RAM_WAIT1=1;
   
   reg	ram1_full;
   reg	ram_wr1;
   reg	[13:0]ram_waddr1;
   reg	[63:0]ram_din1;
   reg	[13:0]ram_raddr1;
   wire	[63:0]ram_dout1;
   	
   
   reg	ram2_full;
   reg	ram_wr2;
   reg	[13:0]ram_waddr2;
   reg	[63:0]ram_din2;
   reg	[13:0]ram_raddr2;
   wire	[63:0]ram_dout2;
   						
   						
   always@(posedge clk_ts)begin
   	
   end						
   
   always@(posedge clk_ts)begin
   	if(rst_ts)	
   		wcstate	<=	WR_IDLE;
   	else
   		wcstate	<=	wnstate;	
   end
   
   
   always@(*)begin
   	case(wcstate)
   		WR_IDLE:
   			if(!ram1_full)
   				wnstate	=	WR_RAM_WAIT1;
   			else
   				wnstate	=	WR_IDLE;
   		WR_RAM_WAIT1:
   			if(ts_ram_wr&!ts_ram_wr_r)
   				wnstate	=	WR_RAM1;
   			else
   				wnstate	=	WR_RAM_WAIT1;   			
   		WR_RAM1:
   				wnstate	=	WR_RAM1;
   		default:
   			wnstate	=	WR_IDLE;
   	endcase
   end
   
   
   reg	[1:0]rcstate;
   reg	[1:0]rnstate;
   
   wire	addr_rd;
   wire	[13:0]addr_dout;
   wire empty;
   reg	[2:0]send_cnt;
   
   
   
   parameter	RD_IDLE=0,
   						RD_ADDR=1,
   						SEND_CMD=2,
   						SEND_TS=3;
   						
   		
   	
   	ts_ram_pcie ts_ram_1 (
		  .clka(clk_ts), // input clka
		  .wea(ram_wr1), // input [0 : 0] wea
		  .addra(ram_waddr1), // input [13 : 0] addra
		  .dina(ram_din1), // input [63 : 0] dina
		  .clkb(clk), // input clkb
		  .addrb(ram_raddr1), // input [13 : 0] addrb
		  .doutb(ram_dout1) // output [63 : 0] doutb
		);
		
		ts_ram_pcie ts_ram_2 (
		  .clka(clk_ts), // input clka
		  .wea(ram_wr2), // input [0 : 0] wea
		  .addra(ram_waddr2), // input [13 : 0] addra
		  .dina(ram_din2), // input [63 : 0] dina
		  .clkb(clk), // input clkb
		  .addrb(ram_raddr2), // input [13 : 0] addrb
		  .doutb(ram_dout2) // output [63 : 0] doutb
		);
   		
   		
   		
   						
   						
   	ts_addr_fifo addr_fifo (
		  .clk(clk), // input clk
		  .rst(rst), // input rst
		  .din(dma_raddr[17:3]), // input [14 : 0] din
		  .wr_en(dma_raddr_en), // input wr_en
		  .rd_en(addr_rd), // input rd_en
		  .dout(addr_dout), // output [31 : 0] dout
		  .full(), // output full
		  .empty(empty) // output empty
		);					
    
    
    
    always@(posedge clk)begin
    	if(rst)
    		rcstate	<=	RD_IDLE;
    	else
    		rcstate	<=	rnstate;
    end	


		always@(posedge clk)begin
			case(rcstate)
				RD_IDLE:
					if(!empty)
						rnstate	=	RD_ADDR;
					else
						rnstate	=	RD_IDLE;
				RD_ADDR:
					if(addr_dout[14])
						rnstate	=	SEND_CMD;
					else
						rnstate	=	SEND_TS;
				SEND_CMD:
					if(send_cnt==7)
						rnstate	=	RD_IDLE;
					else
						rnstate	=	SEND_CMD;
				SEND_TS:
					if(send_cnt==7)
						rnstate	=	RD_IDLE;
					else
						rnstate	=	SEND_TS;
			endcase
		end

		assign addr_rd	=	rnstate	== RD_ADDR?1'b1:1'b0;
		
		always@(posedge clk)begin
			if(rcstate==SEND_CMD || rcstate==SEND_TS)
				send_cnt	<=	send_cnt+1;
			else
				send_cnt	<=0;
		end
		
		always@(posedge clk)begin
			if(rcstate==RD_ADDR && !addr_dout[14])
				ott_raddr	<=	addr_dout[13:0];
			else if(rcstate	==	SEND_TS)
				ott_raddr	<=	ott_raddr+1;
			else
				ott_raddr	<=	ott_raddr;
		end
		
		always@(posedge clk)begin
			if(rcstate==RD_ADDR	&& addr_dout[14])
				dvb_raddr	<=	addr_dout[8:3];
			else 
				dvb_raddr	<=	dvb_raddr;
		end
		
		
		always@(posedge clk)begin
			if(rcstate==SEND_TS)
				dma_rdata	<=	{ott_doutb[31:0],ott_doutb[63:32]};
			else if(rcstate==SEND_CMD)begin
				case(send_cnt)
					0:dma_rdata	<=	{dvb_doutb[479:448],dvb_doutb[511:480]};
					1:dma_rdata	<=	{dvb_doutb[415:384],dvb_doutb[447:416]};
					2:dma_rdata	<=	{dvb_doutb[351:320],dvb_doutb[383:352]};
					3:dma_rdata	<=	{dvb_doutb[287:256],dvb_doutb[319:288]};
					4:dma_rdata	<=	{dvb_doutb[223:192],dvb_doutb[255:224]};
					5:dma_rdata	<=	{dvb_doutb[159:128],dvb_doutb[191:160]};
					6:dma_rdata	<=	{dvb_doutb[95:64],dvb_doutb[127:96]};
					7:dma_rdata	<=	{dvb_doutb[31:0],dvb_doutb[63:32]};
				endcase
			end
			else
				dma_rdata	<=	0;				
		end
		
		always@(posedge clk)begin
			if(rnstate	==	SEND_CMD ||rnstate	==	SEND_TS)
				dma_rdata_rdy	<=1;
			else
				dma_rdata_rdy	<=0;
		end
endmodule
