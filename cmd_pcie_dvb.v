`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:32:05 02/11/2014 
// Design Name: 
// Module Name:    cmd_512_8 
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
module cmd_pcie_dvb(
trn_clk,
clk_main,

rst,

cmd_dma_din,//第一字节输入里面包含命令的有效长度，大端模式，先低后高
cmd_dma_sof,
cmd_dma_eof,
cmd_dma_din_en,

cmd_dma_dout,
cmd_dma_dout_en,
cmd_dma_addr,

cmd_dvb_din,
cmd_dvb_din_en,

cmd_dvb_dout,
cmd_dvb_dout_en


    );

input 				trn_clk;
input 				clk_main;
				
input 				rst;
			
input 	[63:0]			cmd_dma_din;
input 						cmd_dma_sof;
input 						cmd_dma_eof;
input 						cmd_dma_din_en;
		
output 	[63:0]			cmd_dma_dout;
output 						cmd_dma_dout_en;
output 	[8:0]				cmd_dma_addr;

		
input 	[7:0]			cmd_dvb_din;
input 					cmd_dvb_din_en;
		
output 	[7:0]			cmd_dvb_dout;
output 					cmd_dvb_dout_en;

reg 	[63:0]			cmd_dma_dout;
reg 						cmd_dma_dout_en;
reg 	[8:0]				cmd_dma_addr;

reg 	[7:0]			cmd_dvb_dout;
reg 					cmd_dvb_dout_en;

reg					cmd_inc;
reg					cmd_dec;
reg					cmd_in_fifo;
reg	[3:0]			cmd_cnt;


reg					rd_en;
wire 	[65:0]		dout;
wire 					empty;
reg 	[63:0]		cmd_valid;
reg 					cmd_valid_en;


////////////////////////////////DMA 命令转换为DVB命令
reg 		[1:0]		rd_cstate;
reg		[1:0]		rd_nstate;

reg 		[15:0]	rd_cnt;
reg		[2:0]		rd_cnt_blk;
//reg 		[8:0]		index;		
reg 		[15:0]	rd_length;//命令有效数据的长度不包含 长度字节
//reg 					rd_valid;

parameter		RD_IDLE=0,
					RD_CMD=1,
					RD_CMD_OUT=2;

reg 	[4:0]	start_enable;
reg 	[4:0] end_enable;
reg 			sof_oc;
reg			sof_oc_r;
reg			sof_oc_rr;
reg			sof_oc_rrr;
reg			sof;
reg			eof_oc;
reg			eof_oc_r;
reg			eof_oc_rr;
reg			eof_oc_rrr;
reg			eof;


always@(posedge trn_clk)
begin
if(rst)
sof_oc	<=0;
else if(cmd_dma_sof)
sof_oc	<=~sof_oc;
else 
sof_oc	<=sof_oc;
end

always@(posedge clk_main)
begin
if(rst)
begin
sof_oc_r	<=0;
sof_oc_rr	<=0;
sof_oc_rrr	<=0;
end
else
begin
sof_oc_r	<=sof_oc;
sof_oc_rr	<=sof_oc_r;
sof_oc_rrr	<=sof_oc_rr; 
end
end

always@(posedge clk_main)
begin
if(rst)
sof	<=0;
else if(sof_oc_rrr!=sof_oc_rr)
sof	<=1;
else 
sof<=0;
end



always@(posedge trn_clk)
begin
if(rst)
eof_oc	<=0;
else if(cmd_dma_eof)
eof_oc	<=~eof_oc;
else 
eof_oc	<=eof_oc;
end

always@(posedge clk_main)
begin
if(rst)
begin
eof_oc_r	<=0;
eof_oc_rr	<=0;
eof_oc_rrr	<=0;
end
else
begin
eof_oc_r	<=eof_oc;
eof_oc_rr	<=eof_oc_r;
eof_oc_rrr	<=eof_oc_rr; 
end
end

always@(posedge clk_main)
begin
if(rst)
eof	<=0;
else if(eof_oc_rrr!=eof_oc_rr)
eof	<=1;
else 
eof<=0;
end

//always@(posedge trn_clk)
//begin
//if(rst)
//	start_enable	<=0;
//else if(cmd_dma_sof)
//	start_enable	<=5'b00001;
//else 
//	start_enable	<={start_enable[3:0],1'b0};
//end
//
//always@(posedge trn_clk)
//begin
//if(rst)
//	end_enable	<=0;
//else if(cmd_dma_eof)
//	end_enable	<=5'b00001;
//else 
//	end_enable	<={end_enable[3:0],1'b0};
//end
//
//assign	sof_oc=(start_enable==0)?1'b0:1'b1;
//assign	eof_oc=(end_enable==0)?1'b0:1'b1;
//	
//always@(posedge clk_main)
//begin
//if(rst)
//begin
//sof_oc_r	<=0;
//sof			<=0;
//eof_oc_r	<=0;
//eof			<=0;
//end
//else 
//begin
//sof_oc_r	<=sof_oc;
//sof			<=sof_oc&& !sof_oc_r;
//eof_oc_r	<=eof_oc;
//eof			<=eof_oc&& !eof_oc_r;
//end
//end	
					
					
always@(posedge clk_main)					
begin
	if(rst)
	cmd_dec	<=0;
	else if(rd_cstate==RD_IDLE && rd_nstate==RD_CMD)
	cmd_dec	<=1;
	else	
	cmd_dec	<=0;
end
					
always@(posedge clk_main)
	cmd_inc	<=eof;					
					
					
always@(posedge clk_main)
begin
if(rst)
	cmd_cnt	<=0;
else if(cmd_inc)
	cmd_cnt	<=cmd_cnt+1;
else if(cmd_dec)
	cmd_cnt	<=cmd_cnt-1;
else 
	cmd_cnt	<=cmd_cnt;
end				

always@(posedge	clk_main)
begin
	if(rst)
	cmd_in_fifo	<=0;
	else if(cmd_cnt!=0)
	cmd_in_fifo	<=1;
	else 
	cmd_in_fifo	<=0;
	
end	
					
always@(posedge clk_main)
begin
	if(rst)
	rd_cstate		<=RD_IDLE;
	else 
	rd_cstate		<=rd_nstate;
end

always@(rd_cstate or cmd_in_fifo or dout or rd_cnt or rd_length or empty or rd_cnt_blk)
begin
	case(rd_cstate)
	RD_IDLE:
	if(cmd_in_fifo && !empty)
	rd_nstate		=RD_CMD;
	else 
	rd_nstate		=RD_IDLE;
	RD_CMD:
	if(dout[64] && rd_cnt_blk>1)
	rd_nstate		=RD_CMD_OUT;
	else	
	rd_nstate		=RD_CMD;
	RD_CMD_OUT:
	if(rd_cnt==rd_length+3)
	rd_nstate		=RD_IDLE;
	else	
	rd_nstate		=RD_CMD_OUT;
	default:	
	rd_nstate		=RD_IDLE;
	endcase
end

always@(posedge clk_main)
begin
	if(rst)
		rd_length	<=0;
	else if(dout[65])
		rd_length	<={dout[7:0],dout[15:8]};//是实际命令的长度 不包含长度字节本身
	else 
		rd_length	<=rd_length;
end



always@(posedge clk_main)
begin
	if(rst)
	cmd_valid_en		<=0;
	else if(rd_cstate==RD_CMD  || rd_cstate==RD_CMD_OUT)
	begin
		if(dout[65] )
		cmd_valid_en	<=1;
		else 
		cmd_valid_en	<=cmd_valid_en;
	end
	else 
	cmd_valid_en		<=0;
end

always@(posedge clk_main)
begin
	if(rst)
	rd_cnt_blk	<=0;
	else if(rd_cstate==RD_CMD || rd_cstate==RD_CMD_OUT)
	rd_cnt_blk	<=rd_cnt_blk+1;
	else 
	rd_cnt_blk	<=0;
end

always@(posedge clk_main)
begin
	if(rst)
	rd_cnt	<=0;
	else if(cmd_valid_en)
	rd_cnt	<=rd_cnt+1;
	else 
	rd_cnt	<=0;
end


//always@(posedge clk_main)
// index<=rd_cnt_blk<<3;

always@(posedge clk_main)
begin
	if(rst)
	rd_en	<=0;
	else if(rd_cstate==RD_CMD && rd_cnt_blk==0)
	rd_en	<=1;
	else
	rd_en	<=0;
end

always@(posedge clk_main)
begin
	cmd_valid	<=dout;
end
always@(posedge clk_main)
begin
	if(rst)	
	cmd_dvb_dout_en	<=0;	
	else if(cmd_valid_en && rd_cnt>1 && rd_cnt<rd_length+2)
	cmd_dvb_dout_en	<=1;
	else 
	cmd_dvb_dout_en<=0;	
end

always@(posedge clk_main)
begin
	if(rst)
	cmd_dvb_dout		<=0;
	else if(rd_cstate==RD_CMD || rd_cstate==RD_CMD_OUT)
	begin
		case(rd_cnt_blk)
	
		1:
		cmd_dvb_dout	<=cmd_valid[55:48];
		2:
		cmd_dvb_dout	<=cmd_valid[63:56];
		3:
		cmd_dvb_dout	<=cmd_valid[7:0];
		4:
		cmd_dvb_dout	<=cmd_valid[15:8];
		5:
		cmd_dvb_dout	<=cmd_valid[23:16];
		6:
		cmd_dvb_dout	<=cmd_valid[31:24];
		7:
		cmd_dvb_dout	<=cmd_valid[39:32];
		0:
		cmd_dvb_dout	<=cmd_valid[47:40];
		default:
		cmd_dvb_dout	<=0;
		endcase		
	end
	else 
	cmd_dvb_dout	<=0;	
end


////////////////////////////////DVB命令转换为DMA命令
reg 		[15:0]		wr_cnt;
reg		[2:0]			wr_cnt_blk;
reg		[7:0]			cmd_dvb_din_r1;
reg		[7:0]			cmd_dvb_din_r2;
reg		[7:0]			cmd_dvb_din_r3;
reg 						cmd_dvb_din_en_r1;
reg 						cmd_dvb_din_en_r2;
//reg 						cmd_dvb_din_en_r3;
//reg						cmd_dvb_din_en_r4;

reg 		[63:0]		length_dvb;
reg 		[6:0]			length_cnt;
reg		[15:0]		length;

reg 		[2:0]			wr_cstate;
reg 		[2:0]			wr_nstate;
parameter				WR_IDLE=0,
							WR_CMD=1,
							WR_CMD_OUT=2,
							WR_LENGTH=3,
							WR_VALID=4;

always@(posedge	clk_main)
begin
	if(rst)
	wr_cstate		<=	WR_IDLE;
	else 
	wr_cstate		<=	wr_nstate;
end

always@(wr_cstate or cmd_dvb_din_en_r2  or wr_cnt_blk or cmd_dvb_din_en)
begin
case(wr_cstate)
WR_IDLE:
	if(cmd_dvb_din_en)
	wr_nstate	=	WR_CMD;
	else
	wr_nstate	=	WR_IDLE;
WR_CMD:
	if(!cmd_dvb_din_en_r2 && !cmd_dvb_din_en)
	wr_nstate	=	WR_CMD_OUT;
	else 
	wr_nstate	=	WR_CMD;
WR_CMD_OUT:	
	if(wr_cnt_blk==7)
	wr_nstate	=	WR_LENGTH;
	else
	wr_nstate	=	WR_CMD_OUT;
WR_LENGTH:
	wr_nstate	=	WR_VALID;
WR_VALID:
	wr_nstate	=WR_IDLE;
default:
	wr_nstate	=	WR_IDLE;
endcase		
end



always@(posedge clk_main)
begin
	cmd_dvb_din_en_r1	<=cmd_dvb_din_en;
	cmd_dvb_din_en_r2	<=cmd_dvb_din_en_r1;
////	cmd_dvb_din_en_r3	<=cmd_dvb_din_en_r2;
//	cmd_dvb_din_en_r4	<=cmd_dvb_din_en_r3;
	
	cmd_dvb_din_r1	<=cmd_dvb_din;
	cmd_dvb_din_r2	<=cmd_dvb_din_r1;
	cmd_dvb_din_r3	<=cmd_dvb_din_r2;
end

always@(posedge clk_main)
begin
	if(rst)
	wr_cnt	<=0;
	else if(wr_cstate==WR_CMD)
	wr_cnt	<=wr_cnt+1;
	else 
	wr_cnt	<=0;
end

always@(posedge clk_main)
begin
	if(rst)
	wr_cnt_blk	<=0;
	else if(wr_cstate==WR_CMD || wr_cstate==WR_CMD_OUT)
	wr_cnt_blk	<=wr_cnt_blk+1;
	else 
	wr_cnt_blk	<=0;
end

always@(posedge clk_main)
begin
	if(rst)
	length_cnt	<=0;
	else if(wr_cstate==WR_IDLE)
	length_cnt	<=0;
	else if(wr_cnt_blk==7)
	length_cnt	<=length_cnt+1;
	else 
	length_cnt	<=length_cnt;
end


always@(posedge clk_main)
begin
	if(rst)
	length	<=0;
	else if(wr_cstate==WR_CMD && wr_nstate==WR_CMD_OUT)
	length	<=wr_cnt-1;
	else 
	length	<=length;
end

always@(posedge clk_main)
begin
	if(rst)
	length_dvb	<=0;
	else if(wr_cnt_blk==0 && length_cnt==1)	
	length_dvb	<=cmd_dma_dout;
	else 
	length_dvb	<=length_dvb;
end

always@(posedge clk_main)
begin
	if(rst)
	cmd_dma_dout	<=0;
	else if(sof)//在接收到dvb命令后，先清除DVB 4Kram中的数据有效指示
	cmd_dma_dout	<=0;
	else if(wr_cstate==WR_CMD)		//写入 回复的命令
	begin
		if(wr_cnt==0)
		cmd_dma_dout	<={cmd_dma_dout[55:0],length[15:8]};
		else if(wr_cnt==1)
		cmd_dma_dout	<={cmd_dma_dout[55:0],length[7:0]};
		else 
		cmd_dma_dout	<={cmd_dvb_din_r3,cmd_dma_dout[63:8]};
	end
	else if(wr_cstate==WR_CMD_OUT)		//写入 回复的命令
	begin	
		cmd_dma_dout	<={cmd_dvb_din_r3,cmd_dma_dout[63:8]};
	end
	else if(wr_cstate==WR_LENGTH)
	cmd_dma_dout	<={length_dvb[63:16],length[7:0],length[15:8]};
	else if(wr_cstate==WR_VALID)//  写入命令有效时能
	cmd_dma_dout	<=64'h1;
	else 
	cmd_dma_dout	<=0;
end

always@(posedge clk_main)
begin
	if(rst)
	cmd_dma_dout_en	<=0;
	else if(sof)//在接收到dvb命令后，先清除DVB 4Kram中的数据有效指示
	cmd_dma_dout_en	<=1;
	else if(wr_cnt_blk==7)
	cmd_dma_dout_en	<=1;
	else if(wr_cstate==WR_LENGTH)
	cmd_dma_dout_en	<=1;
	else if(wr_cstate==WR_VALID)//  写入命令有效时能
	cmd_dma_dout_en	<=1;
	else 
	cmd_dma_dout_en	<=0;
end

always@(posedge clk_main)
begin
	if(rst)
	cmd_dma_addr	<=0;
	else if(sof)//在接收到dvb命令后，先清除DVB 4Kram中的数据有效指示
	cmd_dma_addr	<=0;
	else if(wr_cnt_blk==7)
	cmd_dma_addr	<=cmd_dma_addr+1;
	else if(wr_cstate==WR_LENGTH)
	cmd_dma_addr	<=1;
	else if(wr_cstate==WR_VALID)//  写入命令有效时能
	cmd_dma_addr	<=0;
	else 
	cmd_dma_addr	<=cmd_dma_addr;
end





///////////////////////////////////////

 cmd_fifo	uut
   (
    .rst			 (rst),
    .wr_clk	 	(trn_clk),
    .rd_clk 		(clk_main),
    .din 			({cmd_dma_sof,cmd_dma_eof,cmd_dma_din}),
    .wr_en 		(cmd_dma_din_en),
    .rd_en 		(rd_en),
    .dout 		(dout),
    .full 			(),
    .empty 		(empty)
  );



endmodule
