`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:35:18 07/05/2019 
// Design Name: 
// Module Name:    ts_input_pre 
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
module ts_input_pre(
	clk,
	rst,

	ts_din_1,
	ts_din_1_en,
	
	ts_din_2,
	ts_din_2_en,
	
	ts_din_3,
	ts_din_3_en,
	
	ts_din_4,
	ts_din_4_en,
	
	
	ts_dout,
	ts_dout_en,
	
	con_din,
	con_din_en
	
	
    );
    	input clk;
    	input rst;
    
    	input	[31:0]ts_din_1;
	input	ts_din_1_en;
	
	input	[31:0]ts_din_2;
	input	ts_din_2_en;
		
	input	[31:0]ts_din_3;
	input	ts_din_3_en;
	
	input	[31:0]ts_din_4;
	input	ts_din_4_en;
	
	
	output[7:0]ts_dout;
	output	ts_dout_en;
	
	reg	[7:0]ts_dout;
	reg 		ts_dout_en;
	
	
	input	[7:0]con_din;
	input 	con_din_en;
	
	
	parameter IDLE=4'b0000,
			SYNC_TS_C1=4'b0001,
			TS_WR_C1=4'b0010,
			TS_WAIT_C1=4'b0011,
			SYNC_TS_C2=4'b0100,
			TS_WR_C2=4'b0101,
			TS_WAIT_C2=4'b0110,
			SYNC_TS_C3=4'b0111,
			TS_WR_C3=4'b1000,
			TS_WAIT_C3=4'b1001,
			SYNC_TS_C4=4'b1010,
			TS_WR_C4=4'b1011,
			TS_WAIT_C4=4'b1100;
	
	reg [3:0] wcstate_c1;
	reg [3:0]wnstate_c1;
	
	reg [3:0] wcstate_c2;
	reg [3:0]wnstate_c2;
	
	reg [3:0] wcstate_c3;
	reg [3:0]wnstate_c3;
	
	reg [3:0] wcstate_c4;
	reg [3:0]wnstate_c4;
	
	
	reg ts_din_1_en_r;
	reg[31:0]ts_din_1_r;
	
	reg ts_din_2_en_r;
	reg[31:0]ts_din_2_r;
	
	reg ts_din_3_en_r;
	reg[31:0]ts_din_3_r;
	
	reg ts_din_4_en_r;
	reg[31:0]ts_din_4_r;
	
	reg				ts1_ram_wr;
	reg		[31:0]	ts1_ram_din;
	reg		[11:0]	ts1_ram_addra;
	reg		[11:0]	ts1_ram_addrb;
	wire		[31:0]		ts1_ram_dout;
	
	reg				ts2_ram_wr;
	reg		[31:0]	ts2_ram_din;
	reg		[11:0]	ts2_ram_addra;
	reg		[11:0]	ts2_ram_addrb;
	wire		[31:0]		ts2_ram_dout;
	
	reg				ts3_ram_wr;
	reg		[31:0]	ts3_ram_din;
	reg		[11:0]	ts3_ram_addra;
	reg		[11:0]	ts3_ram_addrb;
	wire		[31:0]		ts3_ram_dout;
	
	reg				ts4_ram_wr;
	reg		[31:0]	ts4_ram_din;
	reg		[11:0]	ts4_ram_addra;
	reg		[11:0]	ts4_ram_addrb;
	wire		[31:0]		ts4_ram_dout;
	
	
	
	reg[5:0]	ts_cnt_1;
	reg[5:0]	ts_cnt_2;
	reg[5:0]	ts_cnt_3;
	reg[5:0]	ts_cnt_4;
	
	reg[3:0] ts1_ram_flag;
	reg[3:0] ts2_ram_flag;
	reg[3:0] ts3_ram_flag;
	reg[3:0] ts4_ram_flag;
	
	reg [3:0]cstate;
	reg [3:0]nstate;
	
	parameter 
			TS_WAIT_1=4'b0001,
			TS_READ_1=4'b0010,
			TS_WAIT_2=4'b0011,
			TS_READ_2=4'b0100,
			TS_WAIT_3=4'b0101,
			TS_READ_3=4'b0110,
			TS_WAIT_4=4'b0111,
			TS_READ_4=4'b1000;
	
	
	reg[1:0]pre_count;
	reg[1:0]count;
	reg[1:0]nxt_count; 
	reg[9:0]rd_cnt;
	
	parameter READ_COUNT=706;
	
	
	reg [32:0]fifo_din;
	reg 			fifo_rd;
	
	reg 			fifo_wr;
	wire [32:0]fifo_dout;
	
	wire 	prog_full;
	wire 	prog_empty;
	
	
	always@(posedge clk)begin
		ts_din_1_en_r<=ts_din_1_en;
		ts_din_1_r<=ts_din_1;
		
		ts_din_2_en_r<=ts_din_2_en;
		ts_din_2_r<=ts_din_2;
		
		ts_din_3_en_r<=ts_din_3_en;
		ts_din_3_r<=ts_din_3;
		
		ts_din_4_en_r<=ts_din_4_en;
		ts_din_4_r<=ts_din_4;
	end
	
	always@(posedge clk )begin
		if(rst)
		wcstate_c1<=IDLE;
		else
		wcstate_c1<=wnstate_c1;
	end
			
	always@(*)begin
		case(wcstate_c1)
		IDLE:
			if(ts_din_1_en && ts_din_1[31:8]==24'h479fff && ts_cnt_1==0)
				wnstate_c1=SYNC_TS_C1;
			else	
				wnstate_c1=IDLE;
		SYNC_TS_C1:
			wnstate_c1=TS_WAIT_C1;
		TS_WAIT_C1:
			if(ts_din_1_en && !ts_din_1_en_r )
				if(ts_din_1[31:8]==24'h479fff)
					wnstate_c1=SYNC_TS_C1;
				else
					wnstate_c1=TS_WR_C1;
			else	
				wnstate_c1=TS_WAIT_C1;
		TS_WR_C1:
			if(!ts_din_1_en)
			wnstate_c1=TS_WAIT_C1;
			else
			wnstate_c1=TS_WR_C1;
			
		endcase
	end
	
	
	always@(posedge clk)begin
	if(wcstate_c1==SYNC_TS_C1)
			case(ts_din_1_r[1:0])
				2'd0:ts1_ram_flag[0]<=1;
				2'd1:ts1_ram_flag[1]<=1;
				2'd2:ts1_ram_flag[2]<=1;
				2'd3:ts1_ram_flag[3]<=1;
			endcase
	else if(cstate==TS_READ_1)
		ts1_ram_flag[pre_count]<=1'b0;
	else
		ts1_ram_flag<=ts1_ram_flag;
	end
	
	
	
	 
	
	always@(posedge clk)begin
	if(wcstate_c1==SYNC_TS_C1)begin
		ts1_ram_addra<={ts_din_1_r[1:0],10'b0};
		ts1_ram_wr<=0;
	end
	else if(wcstate_c1==TS_WAIT_C1 && wnstate_c1==TS_WR_C1 )begin
		ts1_ram_din<=ts_din_1;
		ts1_ram_wr<=1;
	end
	else if(wcstate_c1==TS_WR_C1)begin
		ts1_ram_din<=ts_din_1;
		if(ts1_ram_addra[9:0]!=10'h3ff)
			ts1_ram_addra<=ts1_ram_addra+1;
		else
			ts1_ram_addra<=ts1_ram_addra;
		ts1_ram_wr<=ts_din_1_en;
	end
	else begin
		ts1_ram_din<=32'b0;
		ts1_ram_addra<=ts1_ram_addra;
		ts1_ram_wr<=0;
	end		
	end
	
	
	
	
	always@(posedge clk )begin
		if(rst)
		wcstate_c2<=IDLE;
		else
		wcstate_c2<=wnstate_c2;
	end
			
	always@(*)begin
		case(wcstate_c2)
		IDLE:
			if(ts_din_2_en && ts_din_2[31:8]==24'h479fff && ts_cnt_2==0)
				wnstate_c2=SYNC_TS_C2;
			else	
				wnstate_c2=IDLE;
		SYNC_TS_C2:
			wnstate_c2=TS_WAIT_C2;
		TS_WAIT_C2:
			if(ts_din_2_en && !ts_din_2_en_r )
				if(ts_din_2[31:8]==24'h479fff)
					wnstate_c2=SYNC_TS_C2;
				else
					wnstate_c2=TS_WR_C2;
			else	
				wnstate_c2=TS_WAIT_C2;
		TS_WR_C2:
			if(!ts_din_2_en)
			wnstate_c2=TS_WAIT_C2;
			else
			wnstate_c2=TS_WR_C2;
			
		endcase
	end
	
	
	always@(posedge clk)begin
	if(wcstate_c2==SYNC_TS_C2)
			case(ts_din_2_r[1:0])
				2'd0:ts2_ram_flag[0]<=1;
				2'd1:ts2_ram_flag[1]<=1;
				2'd2:ts2_ram_flag[2]<=1;
				2'd3:ts2_ram_flag[3]<=1;
			endcase
	else if(cstate==TS_READ_2)
		ts2_ram_flag[pre_count]<=1'b0;
	else
		ts2_ram_flag<=ts2_ram_flag;
	end
	
	
	
	 
	
	always@(posedge clk)begin
	if(wcstate_c2==SYNC_TS_C2)begin
		ts2_ram_addra<={ts_din_2_r[1:0],10'b0};
		ts2_ram_wr<=0;
	end
	else if(wcstate_c2==TS_WAIT_C2 && wnstate_c2==TS_WR_C2 )begin
		ts2_ram_din<=ts_din_2;
		ts2_ram_wr<=1;
	end
	else if(wcstate_c2==TS_WR_C2)begin
		ts2_ram_din<=ts_din_2;
		if(ts2_ram_addra[9:0]!=10'h3ff)
			ts2_ram_addra<=ts2_ram_addra+1;
		else
			ts2_ram_addra<=ts2_ram_addra;
		ts2_ram_wr<=ts_din_2_en;
	end
	else begin
		ts2_ram_din<=32'b0;
		ts2_ram_addra<=ts2_ram_addra;
		ts2_ram_wr<=0;
	end		
	end
	
	
	
	
	always@(posedge clk )begin
		if(rst)
		wcstate_c3<=IDLE;
		else
		wcstate_c3<=wnstate_c3;
	end
			
	always@(*)begin
		case(wcstate_c3)
		IDLE:
			if(ts_din_3_en && ts_din_3[31:8]==24'h479fff && ts_cnt_3==0)
				wnstate_c3=SYNC_TS_C3;
			else	
				wnstate_c3=IDLE;
		SYNC_TS_C3:
			wnstate_c3=TS_WAIT_C3;
		TS_WAIT_C3:
			if(ts_din_3_en && !ts_din_3_en_r )
				if(ts_din_3[31:8]==24'h479fff)
					wnstate_c3=SYNC_TS_C3;
				else
					wnstate_c3=TS_WR_C3;
			else	
				wnstate_c3=TS_WAIT_C3;
		TS_WR_C3:
			if(!ts_din_3_en)
			wnstate_c3=TS_WAIT_C3;
			else
			wnstate_c3=TS_WR_C3;
			
		endcase
	end
	
	
	
	always@(posedge clk)begin
	if(wcstate_c3==SYNC_TS_C3)
			case(ts_din_3_r[1:0])
				2'd0:ts3_ram_flag[0]<=1;
				2'd1:ts3_ram_flag[1]<=1;
				2'd2:ts3_ram_flag[2]<=1;
				2'd3:ts3_ram_flag[3]<=1;
			endcase
	else if(cstate==TS_READ_3)
		ts3_ram_flag[pre_count]<=1'b0;
	else
		ts3_ram_flag<=ts3_ram_flag;
	end
	
	
	
	 
	
	always@(posedge clk)begin
	if(wcstate_c3==SYNC_TS_C3)begin
		ts3_ram_addra<={ts_din_3_r[3:0],10'b0};
		ts3_ram_wr<=0;
	end
	else if(wcstate_c3==TS_WAIT_C3 && wnstate_c3==TS_WR_C3 )begin
		ts3_ram_din<=ts_din_3;
		ts3_ram_wr<=1;
	end
	else if(wcstate_c3==TS_WR_C3)begin
		ts3_ram_din<=ts_din_3;
		if(ts3_ram_addra[9:0]!=10'h3ff)
			ts3_ram_addra<=ts3_ram_addra+1;
		else
			ts3_ram_addra<=ts3_ram_addra;
		ts3_ram_wr<=ts_din_3_en;
	end
	else begin
		ts3_ram_din<=32'b0;
		ts3_ram_addra<=ts3_ram_addra;
		ts3_ram_wr<=0;
	end		
	end
	
	
	
	
	always@(posedge clk )begin
		if(rst)
		wcstate_c4<=IDLE;
		else
		wcstate_c4<=wnstate_c4;
	end
			
	always@(*)begin
		case(wcstate_c4)
		IDLE:
			if(ts_din_4_en && ts_din_4[31:8]==24'h479fff && ts_cnt_4==0)
				wnstate_c4=SYNC_TS_C4;
			else	
				wnstate_c4=IDLE;
		SYNC_TS_C4:
			wnstate_c4=TS_WAIT_C4;
		TS_WAIT_C4:
			if(ts_din_4_en && !ts_din_4_en_r )
				if(ts_din_4[31:8]==24'h479fff)
					wnstate_c4=SYNC_TS_C4;
				else
					wnstate_c4=TS_WR_C4;
			else	
				wnstate_c4=TS_WAIT_C4;
		TS_WR_C4:
			if(!ts_din_4_en)
			wnstate_c4=TS_WAIT_C4;
			else
			wnstate_c4=TS_WR_C4;
			
		endcase
	end
	
	always@(posedge clk)begin
	if(wcstate_c4==SYNC_TS_C4)
			case(ts_din_4_r[1:0])
				2'd0:ts4_ram_flag[0]<=1;
				2'd1:ts4_ram_flag[1]<=1;
				2'd2:ts4_ram_flag[2]<=1;
				2'd3:ts4_ram_flag[3]<=1;
			endcase
	else if(cstate==TS_READ_4)
		ts4_ram_flag[pre_count]<=1'b0;
	else
		ts4_ram_flag<=ts4_ram_flag;
	end
	
	
	
	 
	
	always@(posedge clk)begin
	if(wcstate_c4==SYNC_TS_C4)begin
		ts4_ram_addra<={ts_din_4_r[1:0],10'b0};
		ts4_ram_wr<=0;
	end
	else if(wcstate_c4==TS_WAIT_C4 && wnstate_c4==TS_WR_C4 )begin
		ts4_ram_din<=ts_din_4;
		ts4_ram_wr<=1;
	end
	else if(wcstate_c4==TS_WR_C4)begin
		ts4_ram_din<=ts_din_4;
		if(ts4_ram_addra[9:0]!=10'h3ff)
			ts4_ram_addra<=ts4_ram_addra+1;
		else
			ts4_ram_addra<=ts4_ram_addra;
		ts4_ram_wr<=ts_din_4_en;
	end
	else begin
		ts4_ram_din<=32'b0;
		ts4_ram_addra<=ts4_ram_addra;
		ts4_ram_wr<=0;
	end		
	end
	
	
	
	
	
	
	
	
	//////////READ  TS
	always@(posedge clk)begin
	if(rst)
		cstate<=IDLE;
	else	
		cstate<=nstate;
	end
	
	always@(*)begin
		case(cstate)
		IDLE:
			nstate=TS_WAIT_1;
		TS_WAIT_1:
			if(ts1_ram_flag[nxt_count]==1 && !prog_full)
				nstate=TS_READ_1;
			else
				nstate=TS_WAIT_1;
		TS_READ_1: 
			if(rd_cnt==READ_COUNT )
				nstate=TS_WAIT_2;
			else
				nstate=TS_READ_1;
		TS_WAIT_2:
			if(ts2_ram_flag[nxt_count]==1 && !prog_full)
				nstate=TS_READ_2;
			else
				nstate=TS_WAIT_2;
		TS_READ_2: 
			if(rd_cnt==READ_COUNT )
				nstate=TS_WAIT_3;
			else
				nstate=TS_READ_2;
		TS_WAIT_3:
			if(ts3_ram_flag[nxt_count]==1 && !prog_full)
				nstate=TS_READ_3;
			else
				nstate=TS_WAIT_3;
		TS_READ_3: 
			if(rd_cnt==READ_COUNT)
				nstate=TS_WAIT_4;
			else
				nstate=TS_READ_3;
		TS_WAIT_4:
			if(ts4_ram_flag[nxt_count]==1 && !prog_full)
				nstate=TS_READ_4;
			else
				nstate=TS_WAIT_4;
		TS_READ_4: 
			if(rd_cnt==READ_COUNT)
				nstate=IDLE;
			else
				nstate=TS_READ_4;
				
		default:
			nstate=IDLE;	
		endcase
	
	end
	
	
	always@(posedge clk)begin
	if(cstate==TS_READ_1 ||cstate==TS_READ_2 ||cstate==TS_READ_3 ||cstate==TS_READ_4)
		rd_cnt<=rd_cnt+1;
	else
		rd_cnt<=0;
	end
	
	
	
	always@(posedge clk)begin
	if(ts_din_1_en)
		ts_cnt_1<=ts_cnt_1+1;
	else
		ts_cnt_1<=0;
	end
	
	always@(posedge clk)begin
	if(ts_din_2_en)
		ts_cnt_2<=ts_cnt_2+1;
	else
		ts_cnt_2<=0;
	end
	
	always@(posedge clk)begin
	if(ts_din_3_en)
		ts_cnt_3<=ts_cnt_3+1;
	else
		ts_cnt_3<=0;
	end
		
	always@(posedge clk)begin
	if(ts_din_4_en)
		ts_cnt_4<=ts_cnt_4+1;
	else
		ts_cnt_4<=0;
	end
	
	always@(posedge clk)begin
	if(rst)
	pre_count<=0;
	else if(cstate==TS_READ_4 && rd_cnt==READ_COUNT)
			pre_count<=count;
		else
			pre_count<=pre_count;
	end
	
	
	always@(posedge clk)begin
	if(rst)
		count<=0;
	else if(cstate==TS_READ_4 && rd_cnt==READ_COUNT)
		count<=count+1;
	else
		count<=count;
	end
	
	always@(posedge clk)begin
	if(rst)
		nxt_count<=0;
	else if(cstate==IDLE)
		nxt_count<=nxt_count+1;
	else
		nxt_count<=nxt_count;
	end
	
	
	always @(posedge clk)
	begin
		if(cstate == TS_READ_1)
		begin
			if(rd_cnt == 0)
			begin
				ts1_ram_addrb	<= {count,6'b0};
			end
			else 
			begin
				ts1_ram_addrb	<= ts1_ram_addrb + 6'b1;
			end
		end
		else
		begin
			ts1_ram_addrb	<= 0;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(cstate == TS_READ_2)
		begin
			if(rd_cnt == 0)
			begin
				ts2_ram_addrb	<= {count,6'b0};
			end
			else 
			begin
				ts2_ram_addrb	<= ts2_ram_addrb + 6'b1;
			end
		end
		else
		begin
			ts2_ram_addrb	<= 0;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(cstate == TS_READ_3)
		begin
			if(rd_cnt == 0)
			begin
				ts3_ram_addrb	<= {count,6'b0};
			end
			else 
			begin
				ts3_ram_addrb	<= ts3_ram_addrb + 6'b1;
			end
		end
		else
		begin
			ts3_ram_addrb	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(cstate == TS_READ_4)
		begin
			if(rd_cnt == 0)
			begin
				ts4_ram_addrb	<= {count,6'b0};
			end
			else 
			begin
				ts4_ram_addrb	<= ts4_ram_addrb + 6'b1;
			end
		end
		else
		begin
			ts4_ram_addrb	<= 0;
		end
	end
	
	
	
	
	always@(posedge clk)begin
	if(rst)begin
		fifo_din<=0;
		fifo_wr<=0;
	end
	else if(cstate==TS_READ_1)begin
		if(rd_cnt>1)begin
		fifo_wr<=1;
		case(rd_cnt)
		2,49,96,143,190,
		237,284,331,378,
		425,472,519,566,
		613,660:begin
		fifo_din<={1'b1,ts1_ram_dout};		
		end
		default:begin
		fifo_din<={1'b0,ts1_ram_dout};
		end
		endcase		
		end
		else begin
			fifo_din<=0;
			fifo_wr<=0;
		end	
	end
	else if(cstate==TS_READ_2)begin
		if(rd_cnt>1)begin
		fifo_wr<=1;
		case(rd_cnt)
		2,49,96,143,190,
		237,284,331,378,
		425,472,519,566,
		613,660:begin
		fifo_din<={1'b1,ts2_ram_dout};		
		end
		default:begin
		fifo_din<={1'b0,ts2_ram_dout};
		end
		endcase		
		end
		else begin
			fifo_din<=0;
			fifo_wr<=0;
		end	
	end
	else if(cstate==TS_READ_3)begin
		if(rd_cnt>1)begin
		fifo_wr<=1;
		case(rd_cnt)
		2,49,96,143,190,
		237,284,331,378,
		425,472,519,566,
		613,660:begin
		fifo_din<={1'b1,ts3_ram_dout};		
		end
		default:begin
		fifo_din<={1'b0,ts3_ram_dout};
		end
		endcase		
		end
		else begin
			fifo_din<=0;
			fifo_wr<=0;
		end	
	end
	else if(cstate==TS_READ_4)begin
		if(rd_cnt>1)begin
		fifo_wr<=1;
		case(rd_cnt)
		2,49,96,143,190,
		237,284,331,378,
		425,472,519,566,
		613,660:begin
		fifo_din<={1'b1,ts4_ram_dout};		
		end
		default:begin
		fifo_din<={1'b0,ts4_ram_dout};
		end
		endcase		
		end
		else begin
			fifo_din<=0;
			fifo_wr<=0;
		end	
	end
	
	else begin
		fifo_din<=0;
		fifo_wr<=0;
	end
	
	end
	
	
	reg [1:0]rcstate;
	reg	[1:0]rnstate;
	reg [5:0]fifo_cnt;
	reg	[1:0]round_cnt;
	reg	[3:0]interval;
	
	
	reg 		envalid;
	parameter	TS_READ_COUNT	=47;
	
	
	parameter READ_FIFO_WAIT=1,
						READ_FIFO_DATA=2,
						READ_FIFO_INTERVAL=3;
	
	always@(posedge clk)begin
		if(rst)
			rcstate	<=IDLE;
		else
			rcstate	<=rnstate;
	end
	
	
	always@(*)begin
		case(rcstate)
		IDLE:
			rnstate	=READ_FIFO_WAIT;
		READ_FIFO_WAIT:
			if(!prog_empty)
				rnstate	=	READ_FIFO_DATA;
			else
				rnstate	=	READ_FIFO_WAIT;
		READ_FIFO_DATA:
			if(fifo_cnt==TS_READ_COUNT)
				rnstate	=	READ_FIFO_INTERVAL;
			else
				rnstate	=	READ_FIFO_DATA;
		READ_FIFO_INTERVAL:
			if(interval==15)
				rnstate	=	READ_FIFO_WAIT;
			else
				rnstate	= READ_FIFO_INTERVAL;
		default:
				rnstate	=	IDLE;
		endcase
	end
	
	always@(*)begin
		if(rcstate==READ_FIFO_DATA )begin
		if(!envalid)begin
			if(fifo_dout[32:24]==9'h147 )
				fifo_rd	=0;
			else
				fifo_rd	=1;
		end
		else if(round_cnt==3)
			fifo_rd	=1;
		else
			fifo_rd	=0;
	end
		else
			fifo_rd	=0;
	end
	
	always@(posedge clk)begin
		if( rcstate==READ_FIFO_DATA)
			if(fifo_dout[32:24]==9'h147 )
				envalid	<=1;
			else
				envalid	<=envalid;
		else	
			envalid	<=0;
	end
	
	
	always@(posedge clk)begin
		if(envalid)begin			
			round_cnt	<=round_cnt+1;
		end
		else begin
			round_cnt	<=0;
		end
	end
	
	always@(posedge clk)begin
		if(envalid)
			if( round_cnt==1)
				fifo_cnt	<=fifo_cnt+1;
			else
				fifo_cnt	<=fifo_cnt;
		else
			fifo_cnt		<=0;
	end
	
	
	always@(posedge clk)begin
		if(envalid)begin
			ts_dout_en	<=1;
			case(round_cnt)
			0:
				ts_dout	<=fifo_dout[31:24];
			1:
				ts_dout	<=fifo_dout[23:16];
			2:
				ts_dout	<=fifo_dout[15:8];
			3:
				ts_dout	<=fifo_dout[7:0];		
			endcase
		end
		else	begin
			ts_dout	<=0;
			ts_dout_en	<=0;
		end
	end
	
	
	always@(posedge clk)begin
		if(rst)
			interval	<=0;
		else if(rcstate==READ_FIFO_INTERVAL)
			interval	<=interval+1;
		else
			interval	<=0;
	end
	
	
	
	ts_ram_buffer ram_uut_1 (
	  .clka(clk), // input clka
	  .wea(ts1_ram_wr), // input [0 : 0] wea
	  .addra(ts1_ram_addra), // input [13 : 0] addra
	  .dina(ts1_ram_din), // input [31 : 0] dina
	  .clkb(clk), // input clkb
	  .addrb(ts1_ram_addrb), // input [13 : 0] addrb
	  .doutb(ts1_ram_dout) // output [31 : 0] doutb
	);
	
	ts_ram_buffer ram_uut_2 (
	  .clka(clk), // input clka
	  .wea(ts2_ram_wr), // input [0 : 0] wea
	  .addra(ts2_ram_addra), // input [13 : 0] addra
	  .dina(ts2_ram_din), // input [31 : 0] dina
	  .clkb(clk), // input clkb
	  .addrb(ts2_ram_addrb), // input [13 : 0] addrb
	  .doutb(ts2_ram_dout) // output [31 : 0] doutb
	);
	
	ts_ram_buffer ram_uut_3 (
	  .clka(clk), // input clka
	  .wea(ts3_ram_wr), // input [0 : 0] wea
	  .addra(ts3_ram_addra), // input [13 : 0] addra
	  .dina(ts3_ram_din), // input [31 : 0] dina
	  .clkb(clk), // input clkb
	  .addrb(ts3_ram_addrb), // input [13 : 0] addrb
	  .doutb(ts3_ram_dout) // output [31 : 0] doutb
	);
	
	ts_ram_buffer ram_uut_4(
	  .clka(clk), // input clka
	  .wea(ts4_ram_wr), // input [0 : 0] wea
	  .addra(ts4_ram_addra), // input [13 : 0] addra
	  .dina(ts4_ram_din), // input [31 : 0] dina
	  .clkb(clk), // input clkb
	  .addrb(ts4_ram_addrb), // input [13 : 0] addrb
	  .doutb(ts4_ram_dout) // output [31 : 0] doutb
	);
		
		
	ts_buffer buffer_uut (
	  .rst(rst), // input rst
	  .wr_clk(clk), // input wr_clk
	  .rd_clk(clk), // input rd_clk
	  .din(fifo_din), // input [31 : 0] din
	  .wr_en(fifo_wr), // input wr_en
	  .rd_en(fifo_rd), // input rd_en
	  .dout(fifo_dout), // output [31 : 0] dout
	  .full(), // output full
	  .empty(), // output empty
	  .prog_full(prog_full), // output prog_full
	  .prog_empty(prog_empty) // output prog_empty
	);	
		


endmodule
