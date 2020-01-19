`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:12:36 08/23/2019 
// Design Name: 
// Module Name:    si_get 
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
module si_get(

	clk,
	rst,
	
	ts_din,
	ts_din_en,
	
	con_din,
	con_din_en,
	
	si_dout,
	si_dout_en

    );
    
   input	clk;
   input	rst;
   
   input	[32:0]ts_din;
   input 	ts_din_en;
   
   input 	[7:0]con_din;
   input 	con_din_en;
   
   output [7:0]si_dout;
   output 	si_dout_en;
   
   reg	[7:0]si_dout;
   reg	si_dout_en;
   
   
   
   reg	[7:0]sfp_num;
   reg	[31:0]ip;
   reg	[15:0]port;
   
   reg	[12:0]pid;
   reg	[7:0]table_id;
   
   reg	[7:0]section_num;
   reg	[7:0]over_time;
   
   parameter	ONE_SECOND=27'h7735940;
   parameter	TIME_SET_INIT=8'd10;
   reg	[26:0]second_cnt;
   reg	[8:0]second_num;
   
   reg	[3:0]con_cnt;
   
   reg	si_getting;
   reg	over_en;
   
   reg	[31:0]fifo_din;
   reg	fifo_wr;
   wire	fifo_rd;
   wire	[7:0]fifo_dout;
	 wire	empty;
	 reg 	[7:0]si_cnt;
	 reg	[3:0]si_cc_reg;
	 
	
	 reg	[3:0]si_cstate;
	 reg	[3:0]si_nstate;
	 reg	fifo_dout_en;
	 reg	section_start;
	 reg	nxt_en;	
	
	always@(posedge clk)begin
		fifo_dout_en	<=	fifo_rd;
	end
	
	
	parameter	SI_IDLE	=	4'd0,
						SI_PID_CHK1	=	4'd1,
						SI_PID_CHK2	=	4'd2,
						SI_CNT_CHK	=	4'd3,
						SI_ADPAT_JUDE	=	4'd4,
						SI_ADAP_LEN		= 4'd5,
						SI_ADAP_WAIT	= 4'd6,
						SI_POINT_LEN	= 4'd7,
						SI_POINT_WAIT	= 4'd8,
						SI_TABLEID_CK	= 4'd9,
						SI_WRITE		= 4'd10,
						SI_WAIT			= 4'd11,
						SI_SEND			= 4'd12;
						
	 	reg		[7:0] si_ram_din;
    reg     si_ram_wr;
    reg		[11:0] si_ram_addra;
    reg		[11:0] si_ram_addrb;
    wire	[7:0] si_ram_dout;
    
    reg		[11:0]section_len;
   
   
  reg		[2:0] rd_cstate;
	reg		[2:0] rd_nstate;		
	
	reg		null_en;
	
	parameter	RD_IDLE  = 3'd0,
				RD_HEAD1 = 3'd1,
				RD_HEAD2 = 3'd2,
				RD_DATA  = 3'd3,
				RD_NOP   = 3'd4,
				RD_NULL  = 3'd5;
	
	//添加udp包长度判断			
  parameter   UDP_SEC1 = 1450;
  parameter   UDP_SEC2 = 2490;
  
  reg	[11:0]	rd_len;
  reg	[1:0] head_cnt;
	reg [2:0] nop_cnt;
	reg	[7:0] wait_cnt;
	reg	[7:0] wait_len;
   
   always@(posedge clk)begin
   	if(con_din_en)
   		con_cnt	<=con_cnt+1;
   	else
   		con_cnt	<=0;	
   end 
   
   
   always@(posedge clk)begin
   		if(con_din_en && con_cnt==0)
   			sfp_num	<=	con_din;
   		else
   			sfp_num	<=	sfp_num;
   end
   
   always@(posedge clk)begin
   		if(con_cnt>0&&con_cnt<5)
   			ip	<=	{ip[23:0],con_din};
   		else
   			ip	<=	ip;   		
   end
   
   always@(posedge clk)begin
   	if(con_cnt==5||con_cnt==6)
   		port	<=	{port[7:0],con_din};
   	else
   		port	<=	port;	
   end
   
   always@(posedge clk)begin
   	if(con_cnt==7)
   		pid	<=	{8'b0,con_din[4:0]};
   	else if(con_cnt==8)
   		pid	<=	{pid[4:0],con_din};
   	else
   		pid	<=	pid;	
   end
   
   always@(posedge clk)begin
   		if(con_cnt==9)
   			table_id	<=	con_din;
   		else
   			table_id	<=	table_id;
 	 end
   
   always@(posedge clk)begin
   	if(rst)
   		section_num	<=	8'd0;
   	else	if(con_cnt==10)
   		section_num	<=	con_din;
   	else
   		section_num	<=	section_num;
   end
   
   always@(posedge clk)begin
   	if(rst)
   		second_cnt	<=	0;
   	else if(si_getting)begin
   		if(second_cnt==ONE_SECOND)
   			second_cnt	<=	0;
   		else
   			second_cnt	<=	second_cnt+1;
   	end
   	else
   		second_cnt	<=	0; 	
   end
   always@(posedge clk)begin
   	if(rst)
   		second_num	<=0;
   	else if(si_getting)begin
   			if(second_cnt==ONE_SECOND	)
   				second_num	<=	second_num+1;
   			else
   				second_num	<=	second_num;
   	end
   	else
   		second_num	<=0;
   end
   
   always@(posedge clk)begin 
   	if(rst)
   		over_time	<=	TIME_SET_INIT;
   	else if(con_cnt==11)
   		over_time	<=	con_din;
   	else
   		over_time	<=	over_time;
   end
   
   
   always@(posedge clk)begin
   	if(second_num==over_time && si_getting)
   		over_en	<=	1;
   	else
   		over_en	<=	0;
   end
   
   always@(posedge clk)begin
   	if(rst)
   		si_getting	<=	1'b0;
   	else if(con_cnt==11)
   		si_getting	<=	1'b1;
   	else if(si_cstate==SI_SEND || over_en)
   		si_getting	<=	1'b0;
   	else 
   		si_getting	<=	si_getting;
   end
   
   
   
   parameter	FIFO_IDLE=0,
   						FIFO_IP=1,
   						FIFO_PORT=2,
   						FIFO_WR=3;
   						
   
   reg	[1:0]fifo_cstate;
   reg	[1:0]fifo_nstate;
   
   
   always@(posedge clk)begin
   	if(rst)
   		fifo_cstate	<=	FIFO_IDLE;
   	else
   		fifo_cstate	<=	fifo_nstate;	
   end						
   
   always@(*)begin
   	case(fifo_cstate)
  		FIFO_IDLE:
  			if(ts_din_en && ts_din[7:0]==sfp_num && ts_din[32])
  				fifo_nstate	=	FIFO_IP;
  			else
  				fifo_nstate	=	FIFO_IDLE;
  		FIFO_IP:
  			if(ts_din[31:0]==ip)
  				fifo_nstate	=	FIFO_PORT;
  			else
  				fifo_nstate	=	FIFO_IDLE;
  		FIFO_PORT:
  			if(ts_din[15:0]==port)
  				fifo_nstate	=	FIFO_WR;
  			else
  				fifo_nstate	=	FIFO_IDLE;
  		FIFO_WR:
  			if(!ts_din_en)
  				fifo_nstate	=	FIFO_IDLE;
  			else
  				fifo_nstate	=	FIFO_WR;
  		default:
  			fifo_nstate	=	FIFO_IDLE;
  	endcase
   end
   
   always@(posedge clk)begin
   	if(fifo_cstate==FIFO_WR)begin
   			fifo_din	<=	ts_din[31:0];
   			fifo_wr		<=	ts_din_en;
   	end
   	else	begin
   			fifo_din	<=	0;
   			fifo_wr		<=	0;
   	end
   end
   
   
   

	ts_fifo ip_port_filter (
	  .rst(rst), // input rst
	  .wr_clk(clk), // input wr_clk
	  .rd_clk(clk), // input rd_clk
	  .din(fifo_din), // input [31 : 0] din
	  .wr_en(fifo_wr), // input wr_en
	  .rd_en(fifo_rd), // input rd_en
	  .dout(fifo_dout), // output [7 : 0] dout
	  .full(), // output full
	  .empty(empty) // output empty
	);

	assign	fifo_rd=!empty&&si_cnt!=8'd187;
	
	always@(posedge clk)begin
		if(si_cstate==SI_PID_CHK1)
			section_start	<=	fifo_dout[6];
		else
			section_start	<=	0;
	end
	
	always@(posedge clk)begin
		if(si_cstate==SI_PID_CHK2	&& section_start)
			nxt_en	<=	0;
		else if(si_cstate==SI_WAIT)
			nxt_en	<=	1;
		else
			nxt_en	<=	nxt_en;
	end
						
						
	always@(posedge clk)begin
		if(rst)
			si_cstate	<=	SI_IDLE;
		else if(con_din_en)
			si_cstate	<=	SI_IDLE;
		else if(over_en)
			si_cstate	<=	SI_IDLE;
		else
			si_cstate	<=	si_nstate;
	end
	
	always@(*)begin
		case(si_cstate)
			SI_IDLE:
				if(si_cnt==0 && fifo_dout_en && fifo_dout==8'h47 && si_getting)
					si_nstate	=	SI_PID_CHK1;
				else
					si_nstate	=	SI_IDLE;
			SI_PID_CHK1:
				if(fifo_dout[4:0]==pid[12:8])
					si_nstate	=	SI_PID_CHK2;
				else if(nxt_en)
					si_nstate	=	SI_WAIT;
				else
					si_nstate	=	SI_IDLE;
			SI_PID_CHK2:
				if(fifo_dout==pid[7:0])
					if(section_start)
						si_nstate	=	SI_ADPAT_JUDE;
					else if(nxt_en)
						si_nstate	=	SI_CNT_CHK;
					else
						si_nstate	=	SI_IDLE;
				else if(nxt_en)
					si_nstate	=	SI_WAIT;
				else
					si_nstate	=	SI_IDLE;
			SI_CNT_CHK:
				if(si_cc_reg==fifo_dout[3:0])
					si_nstate	=	SI_WRITE;
				else
					si_nstate	=	SI_WAIT;
			SI_ADPAT_JUDE:
				if(fifo_dout[5:4]==2'b01)
					si_nstate	=	SI_POINT_LEN;
				else if(fifo_dout==2'b11)
					si_nstate	=	SI_ADAP_LEN;
				else if(fifo_dout[5:4]==2'b10)
					si_nstate	=	SI_WAIT;
				else
					si_nstate	=	SI_IDLE;
			SI_ADAP_LEN:
				if(fifo_dout==0)
					si_nstate	=	SI_POINT_LEN;
				else
					si_nstate	=	SI_ADAP_WAIT;
			SI_ADAP_WAIT:
				if(wait_cnt==wait_len)
					si_nstate	=	SI_POINT_LEN;
				else
					si_nstate	=	SI_ADAP_WAIT;
			SI_POINT_LEN:
				if(fifo_dout==0)
					si_nstate	=	SI_TABLEID_CK;
				else
					si_nstate	=	SI_POINT_WAIT;
			SI_POINT_WAIT:
				if(wait_cnt	==	wait_len)
					si_nstate	=	SI_TABLEID_CK;
				else
					si_nstate	=	SI_POINT_WAIT;
			SI_TABLEID_CK:
				if(fifo_dout==table_id)
					si_nstate	=	SI_WRITE;
				else 
					si_nstate	=	SI_IDLE;
			SI_WRITE:begin
				if(si_ram_addra == 5 && fifo_dout != section_num)//==5
    				si_nstate = SI_IDLE;
    		else if(si_ram_addra == section_len && si_ram_addra > 3)//section全部写完
					si_nstate = SI_SEND;
				else if(fifo_dout_en)//正在写section
					si_nstate = SI_WRITE;
				else
					si_nstate = SI_WAIT;
			end
			SI_WAIT:
				if(fifo_dout_en && si_getting && si_cnt==0 && fifo_dout==8'h47)
					si_nstate	=	SI_PID_CHK1;
				else
					si_nstate	=	SI_WAIT;
			SI_SEND:
					si_nstate	=	SI_IDLE;
			default:
				si_nstate	=	SI_IDLE;
		endcase
	end
	
	
	always@(posedge clk)begin
		if(fifo_dout_en)begin
			if(si_cnt	==	8'd187)
				si_cnt	<=	0;
			else
				si_cnt	<=	si_cnt+1;
		end
		else
			si_cnt	<=	0;
	end
	
	always@(posedge clk)begin
		if(rst)
			si_cc_reg	<=	0;
		else if(SI_ADPAT_JUDE==si_cstate)
			si_cc_reg	<=	fifo_dout[3:0];
		else if(si_cstate==SI_PID_CHK2 && si_nstate==SI_CNT_CHK)
			si_cc_reg	<=	si_cc_reg	+1;
		else
			si_cc_reg	<=	si_cc_reg;
	end

	always@(posedge clk)begin
		if(si_cstate	==SI_IDLE)
			wait_len	<=0;
		else if(si_cstate==SI_ADAP_LEN||si_cstate==SI_POINT_LEN)
			wait_len	<=	fifo_dout;
		else
			wait_len	<=	wait_len;
	end
	
	
	always@(posedge clk)begin
	if(SI_ADAP_LEN==si_cstate||SI_POINT_LEN==si_cstate)
		wait_cnt	<=1;
	else if(si_cstate==SI_ADAP_WAIT||si_cstate==SI_POINT_WAIT)
		wait_cnt	<=	wait_cnt+1;
	else
		wait_cnt	<=0;		
	end

	always@(posedge clk)begin
		if(si_cstate==SI_TABLEID_CK||si_cstate==SI_WRITE)
			si_ram_wr	<=1;
		else
			si_ram_wr	<=0;
	end

	always@(posedge clk)begin
		if(rst)begin
			si_ram_addra	<=	0;		
		end
		else if(si_cstate==SI_TABLEID_CK)
			si_ram_addra	<=	12'b0;
		else if(si_ram_wr)
			si_ram_addra	<=	si_ram_addra+1;
		else
			si_ram_addra	<=	si_ram_addra;
	end
	
	always@(posedge clk)begin
		si_ram_din	<=	fifo_dout;
	end
	
	always@(posedge clk)begin
		if(rst)
			section_len	<=	0;
		else if(si_ram_addra==1)
			section_len	<={8'h0,si_ram_din[3:0]};
		else if(si_ram_addra==2)
			section_len	<={section_len[3:0],si_ram_din};
		else
			section_len	<=section_len;
	end

	
  
  always@(posedge clk)begin
  	if(rst)
  		null_en	<=	0;
  	else if(over_en)
  		null_en	<=	1;
  	else if(rd_cstate==RD_NULL)
  		null_en	<=	0;
  	else
  		null_en	<=	null_en;
  end
  
  
  always@(posedge clk)begin
  	if(rst)
  		rd_len	<=0;
  	else if(si_cstate==SI_SEND)
  		rd_len	<=	section_len;
  	else if(rd_cstate	==RD_IDLE)
  		rd_len	<=	0;
  	else	
  		rd_len	<=	rd_len;
  end
  
  
  always@(posedge clk)begin
  	if(rst)
  		rd_cstate	<=	RD_IDLE;
  	else
  		rd_cstate	<=	rd_nstate;
  end
	
	always@(*)begin
		case(rd_cstate)
			RD_IDLE:
				if(si_cstate==SI_SEND || null_en)
					rd_nstate	=	RD_HEAD1;
				else
					rd_nstate	=	RD_IDLE;
			RD_HEAD1:	
			begin
				if(head_cnt == 2'd3)
					rd_nstate	= RD_HEAD2;
				else
					rd_nstate	= RD_HEAD1;	
			end
			
			RD_HEAD2:
			begin
				if(head_cnt == 2'd3)
					begin
						if(null_en)
							rd_nstate	= RD_NULL;
						else
							rd_nstate	= RD_DATA;
					end
				else
					rd_nstate	= RD_HEAD2;
			end
			
			RD_DATA:	
			begin
				if(si_ram_addrb == rd_len)	
					rd_nstate	= RD_IDLE;
				else if(si_ram_addrb == UDP_SEC1 || si_ram_addrb == UDP_SEC2)
					rd_nstate	= RD_NOP;
				else
					rd_nstate	= RD_DATA;
			end
			
			RD_NOP://假如表的长度大于一个udp包，则分开发送，中间加间隔
			begin
				if(nop_cnt == 3'd7)
					rd_nstate	= RD_HEAD1;
				else
					rd_nstate	= RD_NOP;
			end
			
			RD_NULL:	
			begin
				if(head_cnt == 2'd3)
					rd_nstate	= RD_IDLE;
				else
					rd_nstate	= RD_NULL;
			end
			
			default:	
			begin
				rd_nstate	= RD_IDLE;
			end
		endcase
	end

	always @ (posedge clk)
    begin
    	if(rd_cstate == RD_HEAD1 || rd_cstate == RD_HEAD2 || rd_cstate == RD_NULL)
    		head_cnt <= head_cnt + 2'd1;
    	else
    		head_cnt <= 2'd0;
    end
    
    always @ (posedge clk)
    begin
    	if(rd_cstate == RD_NOP)
    		nop_cnt <= nop_cnt + 3'd1;
    	else
    		nop_cnt <= 3'd0;
    end
	
	always @ (posedge clk)
    begin
    	case(rd_cstate)
    		RD_HEAD1:	
    		begin
				case(head_cnt)
	            2'd0: si_dout <= 8'h04;
	            2'd1: si_dout <= 8'h01;
	            2'd2: si_dout <= 8'h00;
	            2'd3: si_dout <= 8'h00;
        		endcase
			end
			
			RD_HEAD2://考虑udp包长度的问题	
			begin
				case(head_cnt)
	            2'd0: si_dout <= 8'h00;//reply_head2[31:24];
	            2'd1:
	            begin
	            	if(si_ram_addrb < UDP_SEC1)
	            		si_dout <= 8'd1;
	            	else if(si_ram_addrb > UDP_SEC2)
	            		si_dout <= 8'd3;
	            	else
	            		si_dout <= 8'd2;
	            end
	            2'd2: si_dout <= 8'h00;
	            2'd3:
	            begin
	            	if(rd_len <= UDP_SEC1)
	            		si_dout <= 8'd1;
	            	else if(rd_len > UDP_SEC2)
	            		si_dout <= 8'd3;
	            	else
	            		si_dout <= 8'd2;
	            end
        		endcase
			end
			
			RD_DATA:	
			begin
				si_dout <= si_ram_dout;
			end			
			
			RD_NULL:	
			begin
				si_dout <= 8'hff;
			end
			
			default:
			    si_dout <= 8'h0;
        endcase
    end
	
	always @ (posedge clk)
	begin
		if(rd_cstate == RD_IDLE)
			si_ram_addrb <= 12'd0;
		else if(rd_cstate == RD_NULL)
			si_ram_addrb <= 12'd0;
		else if(rd_cstate == RD_HEAD2)
			begin
				if(head_cnt == 2'd3)
					si_ram_addrb <= si_ram_addrb + 12'd1;
				else
					si_ram_addrb <= si_ram_addrb;
			end
		else if(rd_cstate == RD_DATA)
			si_ram_addrb <= si_ram_addrb + 12'd1;
		else
			si_ram_addrb <= si_ram_addrb;
	end
	
	always @ (posedge clk)
	begin
		if(rd_cstate == RD_IDLE || rd_cstate == RD_NOP)
			si_dout_en <= 1'b0;
		else
			si_dout_en <= 1'b1;
	end
						

	si_ram si_ram_uut (
	  .clka(clk), // input clka
	  .wea(si_ram_wr), // input [0 : 0] wea
	  .addra(si_ram_addra), // input [11 : 0] addra
	  .dina(si_ram_din), // input [7 : 0] dina
	  .clkb(clk), // input clkb
	  .addrb(si_ram_addrb), // input [11 : 0] addrb
	  .doutb(si_ram_dout) // output [7 : 0] doutb
	);

endmodule
