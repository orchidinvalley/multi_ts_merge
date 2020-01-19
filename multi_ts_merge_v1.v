`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:50:53 10/31/2019 
// Design Name: 
// Module Name:    multi_ts_merge_v1 
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
module multi_ts_merge_v1(

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
		
		ts_din_5,
		ts_din_5_en,
		
		ts_din_6,
		ts_din_6_en,		
		
		ts_din_7,
		ts_din_7_en,
		
		ts_din_8,
		ts_din_8_en,
		
		
		con_din,
		con_din_en,
		
		ts_dout,
		ts_dout_syn,
		ts_dout_en
	
    );
    
    input 	clk;
    input		rst;
    
    input 	[7:0]ts_din_1;
    input 	ts_din_1_en;

		input 	[7:0]ts_din_2;
    input 	ts_din_2_en;
    
    input 	[7:0]ts_din_3;
    input 	ts_din_3_en;
    
    input 	[7:0]ts_din_4;
    input 	ts_din_4_en;
    
    input 	[7:0]ts_din_5;
    input 	ts_din_5_en;

		input 	[7:0]ts_din_6;
    input 	ts_din_6_en;
    
    input 	[7:0]ts_din_7;
    input 	ts_din_7_en;
    
    input 	[7:0]ts_din_8;
    input 	ts_din_8_en;
    
    input 	[7:0]con_din;
		input		con_din_en;
		
		output 	[7:0]ts_dout;
		output	ts_dout_syn;
		output	ts_dout_en;
		
		reg 		[7:0]ts_dout;
		reg			ts_dout_syn;
		reg			ts_dout_en;
		
		parameter	TIME_OUT=188000;//188*8*125
    reg		[7:0]ch_enable;
    
    reg		[3:0]ch1_no;
    reg		[3:0]ch2_no;
    reg		[3:0]ch3_no;
    reg		[3:0]ch4_no;
    reg		[3:0]ch5_no;
    reg		[3:0]ch6_no;
    reg		[3:0]ch7_no;
    reg		[3:0]ch8_no;
    
		
		reg	[7:0]con_cnt;
    
    always@(posedge clk)begin
    	if(con_din_en)
    		con_cnt	<=	con_cnt	+1;
    	else
    		con_cnt	<=	0;
    end
		////bit 4: 使能，1 启用 bit 3:0：对应启用通道需要过滤的通道号 1-15
		always@(posedge clk)begin
			if(con_din_en)begin
				case(con_cnt)
					0:begin
						ch_enable	<={con_din[4],ch_enable[7:1]};
						ch1_no		<=con_din[3:0];
					end
					1:begin
						ch_enable	<={con_din[4],ch_enable[7:1]};
						ch2_no		<=con_din[3:0];
					end
					2:begin
						ch_enable	<={con_din[4],ch_enable[7:1]};
						ch3_no		<=con_din[3:0];
					end
					3:begin
						ch_enable	<={con_din[4],ch_enable[7:1]};
						ch4_no		<=con_din[3:0];
					end
					4:begin
						ch_enable	<={con_din[4],ch_enable[7:1]};
						ch5_no		<=con_din[3:0];
					end
					5:begin
						ch_enable	<={con_din[4],ch_enable[7:1]};
						ch6_no		<=con_din[3:0];
					end
					6:begin
						ch_enable	<={con_din[4],ch_enable[7:1]};
						ch7_no		<=con_din[3:0];
					end
					7:begin
						ch_enable	<={con_din[4],ch_enable[7:1]};
						ch8_no		<=con_din[3:0];
					end
					
				endcase
			end
			else begin
				ch_enable	<=ch_enable;
				ch1_no		<=ch1_no;
				ch2_no		<=ch2_no;
				ch3_no		<=ch3_no;
				ch4_no		<=ch4_no;
				ch5_no		<=ch5_no;
				ch6_no		<=ch6_no;
				ch7_no		<=ch7_no;
				ch8_no		<=ch8_no;
			end
		end
		
    
    reg	[7:0]ts_din_1_r1;
		reg	[7:0]ts_din_1_r2;
		reg	[7:0]ts_din_1_r3;
		reg	ts_din_1_en_r1,ts_din_1_en_r2,ts_din_1_en_r3,ts_din_1_en_r4;
		reg	[7:0]ts_cnt_1;
		reg	tsmf_flag_1;
		reg	tsmf_enable_1;
		reg	[7:0]tsmf_cnt_1;
		reg	[7:0]tsmf_num_1;
		reg	[17:0]time_cnt_1;
		reg	[3:0]tsmf_head_cnt_1;
		
//		reg	[31:0]s1_info_1;//1-8
//		reg	[31:0]s1_info_2;//1-8
//		reg	[31:0]s1_info_3;//1-8
//		reg	[31:0]s1_info_4;//1-8
//		reg	[31:0]s1_info_5;//1-8
//		reg	[31:0]s1_info_6;//1-8
//		reg	[31:0]s1_info_7;//1-8
//		reg	[31:0]s1_info_8;//1-8
//		reg	[31:0]s1_info_9;//1-8
//		reg	[31:0]s1_info_10;//1-8
//		reg	[31:0]s1_info_11;//1-8
//		reg	[31:0]s1_info_12;//1-8
//		reg	[31:0]s1_info_13;//1-8
//		reg	[31:0]s1_info_14;//1-8
//		reg	[31:0]s1_info_15;//1-8
//		reg	[31:0]s1_info_16;//1-8
			
		reg	ch1_wr_enable;
		reg	slot_1_wr;
		reg	[7:0]slot_1_waddr;
		reg	[7:0]slot_1_wdata;
		wire[7:0]slot_1_rdata;

    reg	 	ch1_wr;
		reg		[9:0]ch1_din;
		wire	ch1_rd;
		wire	[9:0]ch1_dout;
		wire 	ch1_empty;
    
    
    
    
    
    
    reg	[1:0]ch1_cstate;
		reg	[1:0]ch1_nstate;
		
		parameter CH1_IDLE=0,
							CH1_HEAD=1,
							CH1_TS	=2;		
		
		
		reg	[3:0]tsmf_cnt;
		
		
		
		
		always@(posedge clk)begin
			if(ts_din_1_en)
				ts_cnt_1	<=	ts_cnt_1+1;
			else
				ts_cnt_1	<=0;
		end
		
		
		always@(posedge clk)begin
			ts_din_1_r1	<=	ts_din_1;
			ts_din_1_r2	<=	ts_din_1_r1;
			ts_din_1_r3	<=	ts_din_1_r2;
			
			ts_din_1_en_r1	<=	ts_din_1_en;
			ts_din_1_en_r2	<=	ts_din_1_en_r1;
			ts_din_1_en_r3	<=	ts_din_1_en_r2;
			ts_din_1_en_r4	<=	ts_din_1_en_r3;
		end
    
    always@(posedge clk)begin
			if(rst)
				tsmf_flag_1	<=0;
			else if(ts_cnt_1==2)
				if(ts_din_1_r2==8'h47 && ts_din_1_r1==8'h1f&& ts_din_1==8'hfe)
					tsmf_flag_1	<=1;
				else
					tsmf_flag_1	<=0;
			else
				tsmf_flag_1	<=0;				
		end
    
    
    always@(posedge clk)begin
			if(rst)
				ch1_cstate	<=	CH1_IDLE;
			else	
				ch1_cstate	<=	ch1_nstate;
		end	
		
		always@(*)begin
			case(ch1_cstate)
				CH1_IDLE:
					if(tsmf_flag_1)	
						ch1_nstate	=	CH1_HEAD;
					else
						ch1_nstate	=	CH1_IDLE;
				CH1_HEAD:
					if(!ts_din_1_en_r3)
						ch1_nstate	=	CH1_TS;
					else
						ch1_nstate	=	CH1_HEAD;			
				CH1_TS:
					if(tsmf_flag_1)
						ch1_nstate	=	CH1_HEAD;
					else if(!ts_din_1_en_r3&&ts_din_1_en_r4)
						if(tsmf_cnt_1==tsmf_num_1)
							ch1_nstate	=	CH1_IDLE;
						else
							ch1_nstate	=	CH1_TS;
					else if(time_cnt_1==TIME_OUT)
						ch1_nstate	=	CH1_IDLE;
					else
						ch1_nstate	=	CH1_TS;
				default:
					ch1_nstate	=	CH1_IDLE;	
			endcase
		end
		
		always@(posedge clk)begin
			if(rst)
				tsmf_head_cnt_1	<=0;
			else	if(tsmf_flag_1)
				tsmf_head_cnt_1	<=ts_din_1[3:0];
			else
				tsmf_head_cnt_1	<=tsmf_head_cnt_1;
		end
		
		always@(posedge clk)begin
			if(ch1_cstate==CH1_IDLE)
				tsmf_cnt_1	<=	0;
			else if(CH1_TS ==ch1_cstate && ts_din_1_en_r3&& !ts_din_1_en_r4)begin
				tsmf_cnt_1	<=	tsmf_cnt_1+1;					
			end
			else
				tsmf_cnt_1	<=	tsmf_cnt_1;
		end
		
		always@(posedge clk)begin
			if(ch1_cstate==CH1_HEAD ||ch1_cstate==CH1_TS)
				time_cnt_1	<=	time_cnt_1+1;
			else
				time_cnt_1	<=	0;			
		end
    
    
    always@(posedge clk)begin
    	if(ch1_cstate==CH1_TS)begin
    		if(ts_din_1_en&&!ts_din_1_en_r1)begin
    			if(tsmf_cnt_1[0]==0)begin
	    			if(slot_1_rdata[7:4]==ch1_no)
	    				ch1_wr_enable	<=1;
	    			else
	    				ch1_wr_enable	<=0;
    			end
    			else	begin
	    			if(slot_1_rdata[3:0]==ch1_no)
	    				ch1_wr_enable	<=1;
	    			else
	    				ch1_wr_enable	<=0;
    			end    			
    		end
    		else
    			ch1_wr_enable	<=	ch1_wr_enable;    		
    	end
    	else
    		ch1_wr_enable	<=0;
    end
    
    
//    always@(posedge clk)begin
//    	if(ch1_cstate==CH1_TS)begin
//    		if(ts_din_1_en&&!ts_din_1_en_r1)begin
//    			case(tsmf_cnt_1)
//    				0:
//    					if(s1_info_1[31:28]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				1:
//    					if(s1_info_1[27:24]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				2:
//    					if(s1_info_1[23:20]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				3:
//    					if(s1_info_1[19:16]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				4:
//    					if(s1_info_1[15:12]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				5:
//    					if(s1_info_1[11:8]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				6:
//    					if(s1_info_1[7:4]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				7:
//    					if(s1_info_1[3:0]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;	
//    				8:
//    					if(s1_info_2[31:28]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				9:
//    					if(s1_info_2[27:24]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				10:
//    					if(s1_info_2[23:20]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				11:
//    					if(s1_info_2[19:16]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				12:
//    					if(s1_info_2[15:12]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				13:
//    					if(s1_info_2[11:8]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				14:
//    					if(s1_info_2[7:4]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				15:
//    					if(s1_info_2[3:0]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;	
//    				16:
//    					if(s1_info_3[31:28]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				17:
//    					if(s1_info_3[27:24]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				18:
//    					if(s1_info_3[23:20]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				19:
//    					if(s1_info_3[19:16]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				20:
//    					if(s1_info_3[15:12]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				21:
//    					if(s1_info_3[11:8]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				22:
//    					if(s1_info_3[7:4]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    				23:
//    					if(s1_info_3[3:0]==ch1_no)
//    						ch1_wr_enable	<=1;
//    					else
//    						ch1_wr_enable	<=0;
//    			endcase
//    		end
//    		else
//    			ch1_wr_enable	<=	ch1_wr_enable;
//    	end
//    	else
//    		ch1_wr_enable	<=	0;
//    end
    
    always@(posedge clk)begin
			if(ch1_cstate==CH1_TS)begin
				if(ch1_nstate==CH1_IDLE ||ch1_nstate==CH1_HEAD)begin
					ch1_wr	<=1;
					ch1_din	<=10'h200;	
				end
				else if(ts_din_1_en_r3)begin
					if(!ts_din_1_en_r4)begin
						ch1_wr	<=ch1_wr_enable;
						ch1_din	<={2'b01,ts_din_1_r3};				
					end
					else begin
						ch1_wr	<=ch1_wr_enable;
						ch1_din	<={2'b00,ts_din_1_r3};					
					end
				end								
				else begin
					ch1_wr	<=0;
					ch1_din	<=0;
				end
			end
			else begin
				ch1_wr	<=0;
				ch1_din	<=0;
			end
				
		end
		
		
		slot_buf slot_buf_1 (
		  .clka(clk), // input clka
		  .wea(slot_1_wr), // input [0 : 0] wea
		  .addra(slot_1_waddr), // input [7 : 0] addra
		  .dina(slot_1_wdata), // input [7 : 0] dina
		  .clkb(clk), // input clkb
		  .addrb({1'b0,tsmf_cnt_1[7:1]}), // input [7 : 0] addrb
		  .doutb(slot_1_rdata) // output [7 : 0] doutb
		);
		
		
		always@(posedge clk)begin
			if(ch1_cstate==CH1_IDLE)
				tsmf_num_1	<=0;
			else if(ch1_cstate==CH1_HEAD)
				if(ts_cnt_1>11&&ts_cnt_1<76)
					if(ts_din_1	!=0)
						tsmf_num_1	<=tsmf_num_1+1;
					else
						tsmf_num_1	<=tsmf_num_1;
				else
					tsmf_num_1	<=tsmf_num_1;
			else
				tsmf_num_1	<=tsmf_num_1;
		end
		
		always@(posedge clk)begin
			if(rst)begin
				slot_1_wr			<=0;
				slot_1_waddr	<=0;
				slot_1_wdata	<=0;
			end
			else if(ch1_cstate==CH1_HEAD)begin
				if(ts_cnt_1==12)begin
					slot_1_wr			<=1;
					slot_1_waddr	<=0;
					slot_1_wdata	<=ts_din_1;
				end
				else	if(ts_cnt_1>12&&ts_cnt_1<76)begin
					slot_1_wr			<=1;
					slot_1_waddr	<=slot_1_waddr+1;
					slot_1_wdata	<=ts_din_1;
				end
				else begin
					slot_1_wr			<=0;
					slot_1_waddr	<=0;
					slot_1_wdata	<=0;
				end
			end
			else begin
				slot_1_wr			<=0;
				slot_1_waddr	<=0;
				slot_1_wdata	<=0;
			end
		end
		
//		always@(posedge clk)begin
//			if(CH1_IDLE==ch1_cstate)begin
//				tsmf_num_1	<=	0;
//				s1_info_1		<=	0; 				
//				s1_info_2		<=  0;
//				s1_info_3		<=  0;
//				s1_info_4		<=  0;
//				s1_info_5		<=  0;
//				s1_info_6		<=  0;
//				s1_info_7		<=  0;
//				s1_info_8		<=  0;
//				s1_info_9		<=  0;
//				s1_info_10	<=  0;
//				s1_info_11	<=  0;
//				s1_info_12	<=  0;
//				s1_info_13	<=  0;
//				s1_info_14	<=  0;
//				s1_info_15	<=	0;
//				s1_info_16	<=	0;
//			end
//			else if(CH1_HEAD==ch1_cstate)begin
//				case(ts_cnt_1)
//					7'd12,
//					7'd13,
//					7'd14,
//					7'd15:begin
//						s1_info_1	<={s1_info_1[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd16,
//					7'd17,
//					7'd18,
//					7'd19:begin
//						s1_info_2	<={s1_info_1[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd20,
//					7'd21,
//					7'd22,
//					7'd23:begin
//						s1_info_3	<={s1_info_3[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd24,
//					7'd25,
//					7'd26,
//					7'd27:begin
//						s1_info_4	<={s1_info_4[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd28,
//					7'd29,
//					7'd30,
//					7'd31:begin
//						s1_info_5	<={s1_info_5[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd32,
//					7'd33,
//					7'd34,
//					7'd35:begin
//						s1_info_6	<={s1_info_6[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd36,
//					7'd37,
//					7'd38,
//					7'd39:begin
//						s1_info_7	<={s1_info_7[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd40,
//					7'd41,
//					7'd42,
//					7'd43:begin
//						s1_info_8	<={s1_info_8[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd44,
//					7'd45,
//					7'd46,
//					7'd47:begin
//						s1_info_9	<={s1_info_9[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd48,
//					7'd49,
//					7'd50,
//					7'd51:begin
//						s1_info_10	<={s1_info_10[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd52,
//					7'd53,
//					7'd54,
//					7'd55:begin
//						s1_info_11	<={s1_info_11[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd56,
//					7'd57,
//					7'd58,
//					7'd59:begin
//						s1_info_12	<={s1_info_12[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd60,
//					7'd61,
//					7'd62,
//					7'd63:begin
//						s1_info_13	<={s1_info_13[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd64,
//					7'd65,
//					7'd66,
//					7'd67:begin
//						s1_info_14	<={s1_info_14[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd68,
//					7'd69,
//					7'd70,
//					7'd71:begin
//						s1_info_15	<={s1_info_15[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					7'd72,
//					7'd73,
//					7'd74,
//					7'd75:begin
//						s1_info_16	<={s1_info_16[23:0],ts_din_1};
//						if(ts_din_1!==0)
//							tsmf_num_1	<=tsmf_num_1+1;
//						else
//							tsmf_num_1	<=tsmf_num_1;
//					end
//					default:begin				
//						tsmf_num_1	<=	tsmf_num_1;
//						s1_info_1		<=	s1_info_1; 				
//						s1_info_2		<=  s1_info_2;
//						s1_info_3		<=  s1_info_3;
//						s1_info_4		<=  s1_info_4;
//						s1_info_5		<=  s1_info_5;
//						s1_info_6		<=  s1_info_6;
//						s1_info_7		<=  s1_info_7;
//						s1_info_8		<=  s1_info_8;
//						s1_info_9		<=  s1_info_9;
//						s1_info_10		<=  s1_info_10;
//						s1_info_11		<=  s1_info_11;
//						s1_info_12		<=  s1_info_12;
//						s1_info_13		<=  s1_info_13;
//						s1_info_14		<=  s1_info_14;
//						s1_info_15		<=	s1_info_15;
//						s1_info_16		<=	s1_info_16;
//					end
//				endcase	
//			end
//			else begin
//				s1_info_1		<=	s1_info_1; 				
//				s1_info_2		<=  s1_info_2;
//				s1_info_3		<=  s1_info_3;
//				s1_info_4		<=  s1_info_4;
//				s1_info_5		<=  s1_info_5;
//				s1_info_6		<=  s1_info_6;
//				s1_info_7		<=  s1_info_7;
//				s1_info_8		<=  s1_info_8;
//				s1_info_9		<=  s1_info_9;
//				s1_info_10		<=  s1_info_10;
//				s1_info_11		<=  s1_info_11;
//				s1_info_12		<=  s1_info_12;
//				s1_info_13		<=  s1_info_13;
//				s1_info_14		<=  s1_info_14;
//				s1_info_15		<=	s1_info_15;
//				s1_info_16		<=	s1_info_16;
//			end
//		end
    
    
    reg	[7:0]ts_din_2_r1;
		reg	[7:0]ts_din_2_r2;
		reg	[7:0]ts_din_2_r3;
		reg	ts_din_2_en_r1,ts_din_2_en_r2,ts_din_2_en_r3,ts_din_2_en_r4;
		reg	[7:0]ts_cnt_2;
		reg	tsmf_flag_2;
		reg	tsmf_enable_2;
		reg	[7:0]tsmf_cnt_2;
		reg	[7:0]tsmf_num_2;
		reg	[17:0]time_cnt_2;
		reg	[3:0]tsmf_head_cnt_2;
				
		reg	ch2_wr_enable;
		reg	slot_2_wr;
		reg	[7:0]slot_2_waddr;
		reg	[7:0]slot_2_wdata;
		wire[7:0]slot_2_rdata;
		

    reg	 	ch2_wr;
		reg		[9:0]ch2_din;
		wire	ch2_rd;
		wire	[9:0]ch2_dout;
		wire 	ch2_empty;
   
    
    reg	[1:0]ch2_cstate;
		reg	[1:0]ch2_nstate;
		
		parameter CH2_IDLE=0,
							CH2_HEAD=1,
							CH2_TS	=2;		
	
		
		always@(posedge clk)begin
			if(ts_din_2_en)
				ts_cnt_2	<=	ts_cnt_2+1;
			else
				ts_cnt_2	<=0;
		end
		
		
		always@(posedge clk)begin
			ts_din_2_r1	<=	ts_din_2;
			ts_din_2_r2	<=	ts_din_2_r1;
			ts_din_2_r3	<=	ts_din_2_r2;
			
			ts_din_2_en_r1	<=	ts_din_2_en;
			ts_din_2_en_r2	<=	ts_din_2_en_r1;
			ts_din_2_en_r3	<=	ts_din_2_en_r2;
			ts_din_2_en_r4	<=	ts_din_2_en_r3;
		end
		
		always@(posedge clk)begin
			if(rst)
				tsmf_head_cnt_2	<=0;
			else if(tsmf_flag_2)
				tsmf_head_cnt_2	<=ts_din_2[3:0];
			else
				tsmf_head_cnt_2	<=tsmf_head_cnt_2;
		end
    
    always@(posedge clk)begin
			if(rst)
				tsmf_flag_2	<=0;
			else if(ts_cnt_2==2)
				if(ts_din_2_r2==8'h47 && ts_din_2_r1==8'h1f&& ts_din_2==8'hfe)
					tsmf_flag_2	<=1;
				else
					tsmf_flag_2	<=0;
			else
				tsmf_flag_2	<=0;				
		end
    
    
    always@(posedge clk)begin
			if(rst)
				ch2_cstate	<=	CH2_IDLE;
			else	
				ch2_cstate	<=	ch2_nstate;
		end	
		
		always@(*)begin
			case(ch2_cstate)
				CH2_IDLE:
					if(tsmf_flag_2)	
						ch2_nstate	=	CH2_HEAD;
					else
						ch2_nstate	=	CH2_IDLE;
				CH2_HEAD:
					if(!ts_din_2_en_r3)
						ch2_nstate	=	CH2_TS;
					else
						ch2_nstate	=	CH2_HEAD;			
				CH2_TS:
					if(tsmf_flag_2)
						ch2_nstate	=	CH2_HEAD;
					else if(!ts_din_2_en_r3&&ts_din_2_en_r4)
						if(tsmf_cnt_2==tsmf_num_2)
							ch2_nstate	=	CH2_IDLE;
						else
							ch2_nstate	=	CH2_TS;
					else if(time_cnt_2==TIME_OUT)
						ch2_nstate	=	CH2_IDLE;
					else
						ch2_nstate	=	CH2_TS;
				default:
					ch2_nstate	=	CH2_IDLE;	
			endcase
		end
		
		always@(posedge clk)begin
			if(ch2_cstate==CH2_IDLE)
				tsmf_cnt_2	<=	0;
			else if(CH2_TS ==ch2_cstate && ts_din_2_en&& !ts_din_2_en_r1)begin
				tsmf_cnt_2	<=	tsmf_cnt_2+1;					
			end
			else
				tsmf_cnt_2	<=	tsmf_cnt_2;
		end
    
    
    always@(posedge clk)begin
			if(ch2_cstate==CH2_TS)begin
				if(ch2_nstate==CH2_IDLE ||ch2_nstate==CH2_HEAD)begin
					ch2_wr	<=1;
					ch2_din	<=10'h200;	
				end
				else if(ts_din_2_en_r3)begin
					if(!ts_din_2_en_r4)begin
						ch2_wr	<=ch2_wr_enable;
						ch2_din	<={2'b01,ts_din_2_r3};				
					end
					else begin
						ch2_wr	<=ch2_wr_enable;
						ch2_din	<={2'b00,ts_din_2_r3};					
					end
				end		
				else begin
					ch2_wr	<=0;
					ch2_din	<=0;
				end
			end
			else begin
				ch2_wr	<=0;
				ch2_din	<=0;
			end
				
		end
    
    
    always@(posedge clk)begin
			if(ch2_cstate==CH2_HEAD ||ch2_cstate==CH2_TS)
				time_cnt_2	<=	time_cnt_2+1;
			else
				time_cnt_2	<=	0;			
		end
    
    
    always@(posedge clk)begin
    	if(ch2_cstate==CH2_TS)begin
    		if(ts_din_2_en&&!ts_din_2_en_r1)begin
    			if(tsmf_cnt_2[0]==0)begin
	    			if(slot_2_rdata[7:4]==ch2_no)
	    				ch2_wr_enable	<=1;
	    			else
	    				ch2_wr_enable	<=0;
    			end
    			else	begin
	    			if(slot_2_rdata[3:0]==ch2_no)
	    				ch2_wr_enable	<=1;
	    			else
	    				ch2_wr_enable	<=0;
    			end    			
    		end
    		else
    			ch2_wr_enable	<=	ch2_wr_enable;    		
    	end
    	else
    		ch2_wr_enable	<=0;
    end
    
    slot_buf slot_buf_2 (
		  .clka(clk), // input clka
		  .wea(slot_2_wr), // input [0 : 0] wea
		  .addra(slot_2_waddr), // input [7 : 0] addra
		  .dina(slot_2_wdata), // input [7 : 0] dina
		  .clkb(clk), // input clkb
		  .addrb({1'b0,tsmf_cnt_2[7:1]}), // input [7 : 0] addrb
		  .doutb(slot_2_rdata) // output [7 : 0] doutb
		);
		
		
		always@(posedge clk)begin
			if(ch2_cstate==CH2_IDLE)
				tsmf_num_2	<=0;
			else if(ch2_cstate==CH2_HEAD)
				if(ts_cnt_2>11&&ts_cnt_2<76)
					if(ts_din_2	!=0)
						tsmf_num_2	<=tsmf_num_2+1;
					else
						tsmf_num_2	<=tsmf_num_2;
				else
					tsmf_num_2	<=tsmf_num_2;
			else
				tsmf_num_2	<=tsmf_num_2;
		end
		
		always@(posedge clk)begin
			if(rst)begin
				slot_2_wr			<=0;
				slot_2_waddr	<=0;
				slot_2_wdata	<=0;
			end
			else if(ch2_cstate==CH2_HEAD)begin
				if(ts_cnt_2==12)begin
					slot_2_wr			<=1;
					slot_2_waddr	<=0;
					slot_2_wdata	<=ts_din_2;
				end
				else	if(ts_cnt_2>12&&ts_cnt_2<76)begin
					slot_2_wr			<=1;
					slot_2_waddr	<=slot_2_waddr+1;
					slot_2_wdata	<=ts_din_2;
				end
				else begin
					slot_2_wr			<=0;
					slot_2_waddr	<=0;
					slot_2_wdata	<=0;
				end
			end
			else begin
				slot_2_wr			<=0;
				slot_2_waddr	<=0;
				slot_2_wdata	<=0;
			end
		end
    
    
    
    reg	[7:0]ts_din_3_r1;
		reg	[7:0]ts_din_3_r2;
		reg	[7:0]ts_din_3_r3;
		reg	ts_din_3_en_r1,ts_din_3_en_r2,ts_din_3_en_r3,ts_din_3_en_r4;
		reg	[7:0]ts_cnt_3;
		reg	tsmf_flag_3;
		reg	tsmf_enable_3;
		reg	[7:0]tsmf_cnt_3;
		reg	[7:0]tsmf_num_3;
		reg	[17:0]time_cnt_3;	
		reg	[3:0]tsmf_head_cnt_3;	
		
		reg	ch3_wr_enable;
		reg	slot_3_wr;
		reg	[7:0]slot_3_waddr;
		reg	[7:0]slot_3_wdata;
		wire[7:0]slot_3_rdata;
		
		

    reg	 	ch3_wr;
		reg		[9:0]ch3_din;
		wire	ch3_rd;
		wire	[9:0]ch3_dout;
		wire 	ch3_empty;
   
    
    reg	[1:0]ch3_cstate;
		reg	[1:0]ch3_nstate;
		
		parameter CH3_IDLE=0,
							CH3_HEAD=1,
							CH3_TS	=2;		
	
		
		always@(posedge clk)begin
			if(ts_din_3_en)
				ts_cnt_3	<=	ts_cnt_3+1;
			else
				ts_cnt_3	<=0;
		end
		
		
		always@(posedge clk)begin
			ts_din_3_r1	<=	ts_din_3;
			ts_din_3_r2	<=	ts_din_3_r1;
			ts_din_3_r3	<=	ts_din_3_r2;
			
			ts_din_3_en_r1	<=	ts_din_3_en;
			ts_din_3_en_r2	<=	ts_din_3_en_r1;
			ts_din_3_en_r3	<=	ts_din_3_en_r2;
			ts_din_3_en_r4	<=	ts_din_3_en_r3;
		end
		
		
    
    always@(posedge clk)begin
			if(rst)
				tsmf_flag_3	<=0;
			else if(ts_cnt_3==2)
				if(ts_din_3_r2==8'h47 && ts_din_3_r1==8'h1f&& ts_din_3==8'hfe)
					tsmf_flag_3	<=1;
				else
					tsmf_flag_3	<=0;
			else
				tsmf_flag_3	<=0;				
		end
    
    always@(posedge clk)begin
			if(rst)
				tsmf_head_cnt_3	<=0;
			else if(tsmf_flag_3)
				tsmf_head_cnt_3	<=ts_din_3[3:0];
			else
				tsmf_head_cnt_3	<=tsmf_head_cnt_3;
		end
    
    
    always@(posedge clk)begin
			if(rst)
				ch3_cstate	<=	CH3_IDLE;
			else	
				ch3_cstate	<=	ch3_nstate;
		end	
		
		always@(*)begin
			case(ch3_cstate)
				CH3_IDLE:
					if(tsmf_flag_3)	
						ch3_nstate	=	CH3_HEAD;
					else
						ch3_nstate	=	CH3_IDLE;
				CH3_HEAD:
					if(!ts_din_3_en_r3)
						ch3_nstate	=	CH3_TS;
					else
						ch3_nstate	=	CH3_HEAD;			
				CH3_TS:
					if(tsmf_flag_3)
						ch3_nstate	=	CH3_HEAD;
					else if(!ts_din_3_en_r3&&ts_din_3_en_r4)
						if(tsmf_cnt_3==tsmf_num_3)
							ch3_nstate	=	CH3_IDLE;
						else
							ch3_nstate	=	CH3_TS;
					else if(time_cnt_3==TIME_OUT)
						ch3_nstate	=	CH3_IDLE;
					else
						ch3_nstate	=	CH3_TS;
				default:
					ch3_nstate	=	CH3_IDLE;	
			endcase
		end
		
		always@(posedge clk)begin
			if(ch3_cstate==CH3_IDLE)
				tsmf_cnt_3	<=	0;
			else if(CH3_TS ==ch3_cstate && ts_din_3_en&& !ts_din_3_en_r1)begin
				tsmf_cnt_3	<=	tsmf_cnt_3+1;					
			end
			else
				tsmf_cnt_3	<=	tsmf_cnt_3;
		end
    
    
    always@(posedge clk)begin
			if(ch3_cstate==CH3_TS)begin
				if(ch3_nstate==CH3_IDLE ||ch3_nstate==CH3_HEAD)begin
					ch3_wr	<=1;
					ch3_din	<=10'h200;	
				end
				else if(ts_din_3_en_r3)begin
					if(!ts_din_3_en_r4)begin
						ch3_wr	<=ch3_wr_enable;
						ch3_din	<={2'b01,ts_din_3_r3};				
					end
					else begin
						ch3_wr	<=ch3_wr_enable;
						ch3_din	<={2'b00,ts_din_3_r3};					
					end
				end									
				else begin
					ch3_wr	<=0;
					ch3_din	<=0;
				end
			end
			else begin
				ch3_wr	<=0;
				ch3_din	<=0;
			end
				
		end
    
    
    
    always@(posedge clk)begin
			if(ch3_cstate==CH3_HEAD ||ch3_cstate==CH3_TS)
				time_cnt_3	<=	time_cnt_3+1;
			else
				time_cnt_3	<=	0;			
		end
    
    
    always@(posedge clk)begin
    	if(ch3_cstate==CH3_TS)begin
    		if(ts_din_3_en&&!ts_din_3_en_r1)begin
    			if(tsmf_cnt_3[0]==0)begin
	    			if(slot_3_rdata[7:4]==ch3_no)
	    				ch3_wr_enable	<=1;
	    			else
	    				ch3_wr_enable	<=0;
    			end
    			else	begin
	    			if(slot_3_rdata[3:0]==ch3_no)
	    				ch3_wr_enable	<=1;
	    			else
	    				ch3_wr_enable	<=0;
    			end    			
    		end
    		else
    			ch3_wr_enable	<=	ch3_wr_enable;    		
    	end
    	else
    		ch3_wr_enable	<=0;
    end
    
    slot_buf slot_buf_3 (
		  .clka(clk), // input clka
		  .wea(slot_3_wr), // input [0 : 0] wea
		  .addra(slot_3_waddr), // input [7 : 0] addra
		  .dina(slot_3_wdata), // input [7 : 0] dina
		  .clkb(clk), // input clkb
		  .addrb({1'b0,tsmf_cnt_3[7:1]}), // input [7 : 0] addrb
		  .doutb(slot_3_rdata) // output [7 : 0] doutb
		);
		
		
		always@(posedge clk)begin
			if(ch3_cstate==CH3_IDLE)
				tsmf_num_3	<=0;
			else if(ch3_cstate==CH3_HEAD)
				if(ts_cnt_3>11&&ts_cnt_3<76)
					if(ts_din_3	!=0)
						tsmf_num_3	<=tsmf_num_3+1;
					else
						tsmf_num_3	<=tsmf_num_3;
				else
					tsmf_num_3	<=tsmf_num_3;
			else
				tsmf_num_3	<=tsmf_num_3;
		end
		
		always@(posedge clk)begin
			if(rst)begin
				slot_3_wr			<=0;
				slot_3_waddr	<=0;
				slot_3_wdata	<=0;
			end
			else if(ch3_cstate==CH3_HEAD)begin
				if(ts_cnt_3==12)begin
					slot_3_wr			<=1;
					slot_3_waddr	<=0;
					slot_3_wdata	<=ts_din_3;
				end
				else	if(ts_cnt_3>12&&ts_cnt_3<76)begin
					slot_3_wr			<=1;
					slot_3_waddr	<=slot_3_waddr+1;
					slot_3_wdata	<=ts_din_3;
				end
				else begin
					slot_3_wr			<=0;
					slot_3_waddr	<=0;
					slot_3_wdata	<=0;
				end
			end
			else begin
				slot_3_wr			<=0;
				slot_3_waddr	<=0;
				slot_3_wdata	<=0;
			end
		end
    
    
    
    reg	[7:0]ts_din_4_r1;
		reg	[7:0]ts_din_4_r2;
		reg	[7:0]ts_din_4_r3;
		reg	ts_din_4_en_r1,ts_din_4_en_r2,ts_din_4_en_r3,ts_din_4_en_r4;
		reg	[7:0]ts_cnt_4;
		reg	tsmf_flag_4;
		reg	tsmf_enable_4;
		reg	[7:0]tsmf_cnt_4;
		reg	[7:0]tsmf_num_4;
		reg	[17:0]time_cnt_4;
		reg	[3:0]tsmf_head_cnt_4;
		
		
		reg	ch4_wr_enable;
		reg	slot_4_wr;
		reg	[7:0]slot_4_waddr;
		reg	[7:0]slot_4_wdata;
		wire[7:0]slot_4_rdata;
		
	

    reg	 	ch4_wr;
		reg		[9:0]ch4_din;
		wire	ch4_rd;
		wire	[9:0]ch4_dout;
		wire 	ch4_empty;
   
    
    reg	[1:0]ch4_cstate;
		reg	[1:0]ch4_nstate;
		
		parameter CH4_IDLE=0,
							CH4_HEAD=1,
							CH4_TS	=2;		
	
		
		always@(posedge clk)begin
			if(ts_din_4_en)
				ts_cnt_4	<=	ts_cnt_4+1;
			else
				ts_cnt_4	<=0;
		end
		
		
		always@(posedge clk)begin
			ts_din_4_r1	<=	ts_din_4;
			ts_din_4_r2	<=	ts_din_4_r1;
			ts_din_4_r3	<=	ts_din_4_r2;
			
			ts_din_4_en_r1	<=	ts_din_4_en;
			ts_din_4_en_r2	<=	ts_din_4_en_r1;
			ts_din_4_en_r3	<=	ts_din_4_en_r2;
			ts_din_4_en_r4	<=	ts_din_4_en_r3;
		end
    
    always@(posedge clk)begin
			if(rst)
				tsmf_flag_4	<=0;
			else if(ts_cnt_4==2)
				if(ts_din_4_r2==8'h47 && ts_din_4_r1==8'h1f&& ts_din_4==8'hfe)
					tsmf_flag_4	<=1;
				else
					tsmf_flag_4	<=0;
			else
				tsmf_flag_4	<=0;				
		end
    
    always@(posedge clk)begin
			if(rst)
				tsmf_head_cnt_4	<=0;
			else if(tsmf_flag_4)
				tsmf_head_cnt_4	<=ts_din_4[3:0];
			else
				tsmf_head_cnt_4	<=tsmf_head_cnt_4;
		end
    
    always@(posedge clk)begin
			if(rst)
				ch4_cstate	<=	CH4_IDLE;
			else	
				ch4_cstate	<=	ch4_nstate;
		end	
		
		always@(*)begin
			case(ch4_cstate)
				CH4_IDLE:
					if(tsmf_flag_4)	
						ch4_nstate	=	CH4_HEAD;
					else
						ch4_nstate	=	CH4_IDLE;
				CH4_HEAD:
					if(!ts_din_4_en_r3)
						ch4_nstate	=	CH4_TS;
					else
						ch4_nstate	=	CH4_HEAD;			
				CH4_TS:
					if(tsmf_flag_4)
						ch4_nstate	=	CH4_HEAD;
					else if(!ts_din_4_en_r3&&ts_din_4_en_r4)
						if(tsmf_cnt_4==tsmf_num_4)
							ch4_nstate	=	CH4_IDLE;
						else
							ch4_nstate	=	CH4_TS;
					else if(time_cnt_4==TIME_OUT)
						ch4_nstate	=	CH4_IDLE;
					else
						ch4_nstate	=	CH4_TS;
				default:
					ch4_nstate	=	CH4_IDLE;	
			endcase
		end
		
		always@(posedge clk)begin
			if(ch4_cstate==CH4_IDLE)
				tsmf_cnt_4	<=	0;
			else if(CH4_TS ==ch4_cstate && ts_din_4_en&& !ts_din_4_en_r1)begin
				tsmf_cnt_4	<=	tsmf_cnt_4+1;					
			end
			else
				tsmf_cnt_4	<=	tsmf_cnt_4;
		end
    
    
    always@(posedge clk)begin
			if(ch4_cstate==CH4_TS)begin
				if(ch4_nstate==CH4_IDLE ||ch4_nstate==CH4_HEAD)begin
					ch4_wr	<=1;
					ch4_din	<=10'h200;	
				end
				else if(ts_din_4_en_r3)begin
					if(!ts_din_4_en_r4)begin
						ch4_wr	<=ch4_wr_enable;
						ch4_din	<={2'b01,ts_din_4_r3};				
					end
					else begin
						ch4_wr	<=ch4_wr_enable;
						ch4_din	<={2'b00,ts_din_4_r3};					
					end
				end									
				else begin
					ch4_wr	<=0;
					ch4_din	<=0;
				end
			end
			else begin
				ch4_wr	<=0;
				ch4_din	<=0;
			end
				
		end
    
    
    
    always@(posedge clk)begin
			if(ch4_cstate==CH4_HEAD ||ch4_cstate==CH4_TS)
				time_cnt_4	<=	time_cnt_4+1;
			else
				time_cnt_4	<=	0;			
		end
    
    
    always@(posedge clk)begin
    	if(ch4_cstate==CH4_TS)begin
    		if(ts_din_4_en&&!ts_din_4_en_r1)begin
    			if(tsmf_cnt_4[0]==0)begin
	    			if(slot_4_rdata[7:4]==ch4_no)
	    				ch4_wr_enable	<=1;
	    			else
	    				ch4_wr_enable	<=0;
    			end
    			else	begin
	    			if(slot_4_rdata[3:0]==ch4_no)
	    				ch4_wr_enable	<=1;
	    			else
	    				ch4_wr_enable	<=0;
    			end    			
    		end
    		else
    			ch4_wr_enable	<=	ch4_wr_enable;    		
    	end
    	else
    		ch4_wr_enable	<=0;
    end
    
    slot_buf slot_buf_4 (
		  .clka(clk), // input clka
		  .wea(slot_4_wr), // input [0 : 0] wea
		  .addra(slot_4_waddr), // input [7 : 0] addra
		  .dina(slot_4_wdata), // input [7 : 0] dina
		  .clkb(clk), // input clkb
		  .addrb({1'b0,tsmf_cnt_4[7:1]}), // input [7 : 0] addrb
		  .doutb(slot_4_rdata) // output [7 : 0] doutb
		);
		
		
		always@(posedge clk)begin
			if(ch4_cstate==CH4_IDLE)
				tsmf_num_4	<=0;
			else if(ch4_cstate==CH4_HEAD)
				if(ts_cnt_4>11&&ts_cnt_4<76)
					if(ts_din_4	!=0)
						tsmf_num_4	<=tsmf_num_4+1;
					else
						tsmf_num_4	<=tsmf_num_4;
				else
					tsmf_num_4	<=tsmf_num_4;
			else
				tsmf_num_4	<=tsmf_num_4;
		end
		
		always@(posedge clk)begin
			if(rst)begin
				slot_4_wr			<=0;
				slot_4_waddr	<=0;
				slot_4_wdata	<=0;
			end
			else if(ch4_cstate==CH4_HEAD)begin
				if(ts_cnt_4==12)begin
					slot_4_wr			<=1;
					slot_4_waddr	<=0;
					slot_4_wdata	<=ts_din_4;
				end
				else	if(ts_cnt_4>12&&ts_cnt_4<76)begin
					slot_4_wr			<=1;
					slot_4_waddr	<=slot_4_waddr+1;
					slot_4_wdata	<=ts_din_4;
				end
				else begin
					slot_4_wr			<=0;
					slot_4_waddr	<=0;
					slot_4_wdata	<=0;
				end
			end
			else begin
				slot_4_wr			<=0;
				slot_4_waddr	<=0;
				slot_4_wdata	<=0;
			end
		end
		
		reg	[7:0]ts_din_5_r1;
		reg	[7:0]ts_din_5_r2;
		reg	[7:0]ts_din_5_r3;
		reg	ts_din_5_en_r1,ts_din_5_en_r2,ts_din_5_en_r3,ts_din_5_en_r4;
		reg	[7:0]ts_cnt_5;
		reg	tsmf_flag_5;
		reg	tsmf_enable_5;
		reg	[7:0]tsmf_cnt_5;
		reg	[7:0]tsmf_num_5;
		reg	[17:0]time_cnt_5;
		reg	[3:0]tsmf_head_cnt_5;
		
		
	
		reg	ch5_wr_enable;
		reg	slot_5_wr;
		reg	[7:0]slot_5_waddr;
		reg	[7:0]slot_5_wdata;
		wire[7:0]slot_5_rdata;
		

    reg	 	ch5_wr;
		reg		[9:0]ch5_din;
		wire	ch5_rd;
		wire	[9:0]ch5_dout;
		wire 	ch5_empty;
   
    
    reg	[1:0]ch5_cstate;
		reg	[1:0]ch5_nstate;
		
		parameter CH5_IDLE=0,
							CH5_HEAD=1,
							CH5_TS	=2;		
	
		
		always@(posedge clk)begin
			if(ts_din_5_en)
				ts_cnt_5	<=	ts_cnt_5+1;
			else
				ts_cnt_5	<=0;
		end
		
		
		always@(posedge clk)begin
			ts_din_5_r1	<=	ts_din_5;
			ts_din_5_r2	<=	ts_din_5_r1;
			ts_din_5_r3	<=	ts_din_5_r2;
			
			ts_din_5_en_r1	<=	ts_din_5_en;
			ts_din_5_en_r2	<=	ts_din_5_en_r1;
			ts_din_5_en_r3	<=	ts_din_5_en_r2;
			ts_din_5_en_r4	<=	ts_din_5_en_r3;
		end
    
    always@(posedge clk)begin
			if(rst)
				tsmf_flag_5	<=0;
			else if(ts_cnt_5==2)
				if(ts_din_5_r2==8'h47 && ts_din_5_r1==8'h1f&& ts_din_5==8'hfe)
					tsmf_flag_5	<=1;
				else
					tsmf_flag_5	<=0;
			else
				tsmf_flag_5	<=0;				
		end
    
    
    always@(posedge clk)begin
			if(rst)
				tsmf_head_cnt_5	<=0;
			else if(tsmf_flag_5)
				tsmf_head_cnt_5	<=ts_din_5[3:0];
			else
				tsmf_head_cnt_5	<=tsmf_head_cnt_5;
		end
    
    always@(posedge clk)begin
			if(rst)
				ch5_cstate	<=	CH5_IDLE;
			else	
				ch5_cstate	<=	ch5_nstate;
		end	
		
		always@(*)begin
			case(ch5_cstate)
				CH5_IDLE:
					if(tsmf_flag_5)	
						ch5_nstate	=	CH5_HEAD;
					else
						ch5_nstate	=	CH5_IDLE;
				CH5_HEAD:
					if(!ts_din_5_en_r3)
						ch5_nstate	=	CH5_TS;
					else
						ch5_nstate	=	CH5_HEAD;			
				CH5_TS:
					if(tsmf_flag_5)
						ch5_nstate	=	CH5_HEAD;
					else if(!ts_din_5_en_r3&&ts_din_5_en_r4)
						if(tsmf_cnt_5==tsmf_num_5)
							ch5_nstate	=	CH5_IDLE;
						else
							ch5_nstate	=	CH5_TS;
					else if(time_cnt_5==TIME_OUT)
						ch5_nstate	=	CH5_IDLE;
					else
						ch5_nstate	=	CH5_TS;
				default:
					ch5_nstate	=	CH5_IDLE;	
			endcase
		end
		
		always@(posedge clk)begin
			if(ch5_cstate==CH5_IDLE)
				tsmf_cnt_5	<=	0;
			else if(CH5_TS ==ch5_cstate && ts_din_5_en&& !ts_din_5_en_r1)begin
				tsmf_cnt_5	<=	tsmf_cnt_5+1;					
			end
			else
				tsmf_cnt_5	<=	tsmf_cnt_5;
		end
    
    
    always@(posedge clk)begin
			if(ch5_cstate==CH5_TS)begin
				if(ch5_nstate==CH5_IDLE ||ch5_nstate==CH5_HEAD)begin
					ch5_wr	<=1;
					ch5_din	<=10'h200;	
				end
				else if(ts_din_5_en_r3)begin
					if(!ts_din_5_en_r4)begin
						ch5_wr	<=ch5_wr_enable;
						ch5_din	<={2'b01,ts_din_5_r3};				
					end
					else begin
						ch5_wr	<=ch5_wr_enable;
						ch5_din	<={2'b00,ts_din_5_r3};					
					end
				end						
				else begin
					ch5_wr	<=0;
					ch5_din	<=0;
				end
			end
			else begin
				ch5_wr	<=0;
				ch5_din	<=0;
			end
				
		end
    
    
    
    always@(posedge clk)begin
			if(ch5_cstate==CH5_HEAD ||ch5_cstate==CH5_TS)
				time_cnt_5	<=	time_cnt_5+1;
			else
				time_cnt_5	<=	0;			
		end
    
    
    always@(posedge clk)begin
    	if(ch5_cstate==CH5_TS)begin
    		if(ts_din_5_en&&!ts_din_5_en_r1)begin
    			if(tsmf_cnt_5[0]==0)begin
	    			if(slot_5_rdata[7:4]==ch5_no)
	    				ch5_wr_enable	<=1;
	    			else
	    				ch5_wr_enable	<=0;
    			end
    			else	begin
	    			if(slot_5_rdata[3:0]==ch5_no)
	    				ch5_wr_enable	<=1;
	    			else
	    				ch5_wr_enable	<=0;
    			end    			
    		end
    		else
    			ch5_wr_enable	<=	ch5_wr_enable;    		
    	end
    	else
    		ch5_wr_enable	<=0;
    end
    
    slot_buf slot_buf_5 (
		  .clka(clk), // input clka
		  .wea(slot_5_wr), // input [0 : 0] wea
		  .addra(slot_5_waddr), // input [7 : 0] addra
		  .dina(slot_5_wdata), // input [7 : 0] dina
		  .clkb(clk), // input clkb
		  .addrb({1'b0,tsmf_cnt_5[7:1]}), // input [7 : 0] addrb
		  .doutb(slot_5_rdata) // output [7 : 0] doutb
		);
		
		
		always@(posedge clk)begin
			if(ch5_cstate==CH5_IDLE)
				tsmf_num_5	<=0;
			else if(ch5_cstate==CH5_HEAD)
				if(ts_cnt_5>11&&ts_cnt_5<76)
					if(ts_din_5	!=0)
						tsmf_num_5	<=tsmf_num_5+1;
					else
						tsmf_num_5	<=tsmf_num_5;
				else
					tsmf_num_5	<=tsmf_num_5;
			else
				tsmf_num_5	<=tsmf_num_5;
		end
		
		always@(posedge clk)begin
			if(rst)begin
				slot_5_wr			<=0;
				slot_5_waddr	<=0;
				slot_5_wdata	<=0;
			end
			else if(ch5_cstate==CH5_HEAD)begin
				if(ts_cnt_5==12)begin
					slot_5_wr			<=1;
					slot_5_waddr	<=0;
					slot_5_wdata	<=ts_din_5;
				end
				else	if(ts_cnt_5>12&&ts_cnt_5<76)begin
					slot_5_wr			<=1;
					slot_5_waddr	<=slot_5_waddr+1;
					slot_5_wdata	<=ts_din_5;
				end
				else begin
					slot_5_wr			<=0;
					slot_5_waddr	<=0;
					slot_5_wdata	<=0;
				end
			end
			else begin
				slot_5_wr			<=0;
				slot_5_waddr	<=0;
				slot_5_wdata	<=0;
			end
		end
		
		
		reg	[7:0]ts_din_6_r1;
		reg	[7:0]ts_din_6_r2;
		reg	[7:0]ts_din_6_r3;
		reg	ts_din_6_en_r1,ts_din_6_en_r2,ts_din_6_en_r3,ts_din_6_en_r4;
		reg	[7:0]ts_cnt_6;
		reg	tsmf_flag_6;
		reg	tsmf_enable_6;
		reg	[7:0]tsmf_cnt_6;
		reg	[7:0]tsmf_num_6;
		reg	[17:0]time_cnt_6;
		reg	[3:0]tsmf_head_cnt_6;
		
		
		reg	ch6_wr_enable;
		reg	slot_6_wr;
		reg	[7:0]slot_6_waddr;
		reg	[7:0]slot_6_wdata;
		wire[7:0]slot_6_rdata;

    reg	 	ch6_wr;
		reg		[9:0]ch6_din;
		wire	ch6_rd;
		wire	[9:0]ch6_dout;
		wire 	ch6_empty;
   
    
    reg	[1:0]ch6_cstate;
		reg	[1:0]ch6_nstate;
		
		parameter CH6_IDLE=0,
							CH6_HEAD=1,
							CH6_TS	=2;		
	
		
		always@(posedge clk)begin
			if(ts_din_6_en)
				ts_cnt_6	<=	ts_cnt_6+1;
			else
				ts_cnt_6	<=0;
		end
		
		
		always@(posedge clk)begin
			ts_din_6_r1	<=	ts_din_6;
			ts_din_6_r2	<=	ts_din_6_r1;
			ts_din_6_r3	<=	ts_din_6_r2;
			
			ts_din_6_en_r1	<=	ts_din_6_en;
			ts_din_6_en_r2	<=	ts_din_6_en_r1;
			ts_din_6_en_r3	<=	ts_din_6_en_r2;
			ts_din_6_en_r4	<=	ts_din_6_en_r3;
		end
    
    always@(posedge clk)begin
			if(rst)
				tsmf_flag_6	<=0;
			else if(ts_cnt_6==2)
				if(ts_din_6_r2==8'h47 && ts_din_6_r1==8'h1f&& ts_din_6==8'hfe)
					tsmf_flag_6	<=1;
				else
					tsmf_flag_6	<=0;
			else
				tsmf_flag_6	<=0;				
		end
		
		always@(posedge clk)begin
			if(rst)
				tsmf_head_cnt_6	<=0;
			else if(tsmf_flag_6)
				tsmf_head_cnt_6	<=ts_din_6[3:0];
			else
				tsmf_head_cnt_6	<=tsmf_head_cnt_6;
		end
    
    
    always@(posedge clk)begin
			if(rst)
				ch6_cstate	<=	CH6_IDLE;
			else	
				ch6_cstate	<=	ch6_nstate;
		end	
		
		always@(*)begin
			case(ch6_cstate)
				CH6_IDLE:
					if(tsmf_flag_6)	
						ch6_nstate	=	CH6_HEAD;
					else
						ch6_nstate	=	CH6_IDLE;
				CH6_HEAD:
					if(!ts_din_6_en_r3)
						ch6_nstate	=	CH6_TS;
					else
						ch6_nstate	=	CH6_HEAD;			
				CH6_TS:
					if(tsmf_flag_6)
						ch6_nstate	=	CH6_HEAD;
					else if(!ts_din_6_en_r3&&ts_din_6_en_r4)
						if(tsmf_cnt_6==tsmf_num_6)
							ch6_nstate	=	CH6_IDLE;
						else
							ch6_nstate	=	CH6_TS;
					else if(time_cnt_6==TIME_OUT)
						ch6_nstate	=	CH6_IDLE;
					else
						ch6_nstate	=	CH6_TS;
				default:
					ch6_nstate	=	CH6_IDLE;	
			endcase
		end
		
		always@(posedge clk)begin
			if(ch6_cstate==CH6_IDLE)
				tsmf_cnt_6	<=	0;
			else if(CH6_TS ==ch6_cstate && ts_din_6_en&& !ts_din_6_en_r1)begin
				tsmf_cnt_6	<=	tsmf_cnt_6+1;					
			end
			else
				tsmf_cnt_6	<=	tsmf_cnt_6;
		end
    
  
    always@(posedge clk)begin
			if(ch6_cstate==CH6_TS)begin
				if(ch6_nstate==CH6_IDLE ||ch6_nstate==CH6_HEAD)begin
					ch6_wr	<=1;
					ch6_din	<=10'h200;	
				end
				else if(ts_din_6_en_r3)begin
					if(!ts_din_6_en_r4)begin
						ch6_wr	<=ch6_wr_enable;
						ch6_din	<={2'b01,ts_din_6_r3};				
					end
					else begin
						ch6_wr	<=ch6_wr_enable;
						ch6_din	<={2'b00,ts_din_6_r3};					
					end
				end							
				else begin
					ch6_wr	<=0;
					ch6_din	<=0;
				end
			end
			else begin
				ch6_wr	<=0;
				ch6_din	<=0;
			end
				
		end
    
    
    
    always@(posedge clk)begin
			if(ch6_cstate==CH6_HEAD ||ch6_cstate==CH6_TS)
				time_cnt_6	<=	time_cnt_6+1;
			else
				time_cnt_6	<=	0;			
		end
    
    
    always@(posedge clk)begin
    	if(ch6_cstate==CH6_TS)begin
    		if(ts_din_6_en&&!ts_din_6_en_r1)begin
    			if(tsmf_cnt_6[0]==0)begin
	    			if(slot_6_rdata[7:4]==ch6_no)
	    				ch6_wr_enable	<=1;
	    			else
	    				ch6_wr_enable	<=0;
    			end
    			else	begin
	    			if(slot_6_rdata[3:0]==ch6_no)
	    				ch6_wr_enable	<=1;
	    			else
	    				ch6_wr_enable	<=0;
    			end    			
    		end
    		else
    			ch6_wr_enable	<=	ch6_wr_enable;    		
    	end
    	else
    		ch6_wr_enable	<=0;
    end
    
    slot_buf slot_buf_6 (
		  .clka(clk), // input clka
		  .wea(slot_6_wr), // input [0 : 0] wea
		  .addra(slot_6_waddr), // input [7 : 0] addra
		  .dina(slot_6_wdata), // input [7 : 0] dina
		  .clkb(clk), // input clkb
		  .addrb({1'b0,tsmf_cnt_6[7:1]}), // input [7 : 0] addrb
		  .doutb(slot_6_rdata) // output [7 : 0] doutb
		);
		
		
		always@(posedge clk)begin
			if(ch6_cstate==CH6_IDLE)
				tsmf_num_6	<=0;
			else if(ch6_cstate==CH6_HEAD)
				if(ts_cnt_6>11&&ts_cnt_6<76)
					if(ts_din_6	!=0)
						tsmf_num_6	<=tsmf_num_6+1;
					else
						tsmf_num_6	<=tsmf_num_6;
				else
					tsmf_num_6	<=tsmf_num_6;
			else
				tsmf_num_6	<=tsmf_num_6;
		end
		
		always@(posedge clk)begin
			if(rst)begin
				slot_6_wr			<=0;
				slot_6_waddr	<=0;
				slot_6_wdata	<=0;
			end
			else if(ch6_cstate==CH6_HEAD)begin
				if(ts_cnt_6==12)begin
					slot_6_wr			<=1;
					slot_6_waddr	<=0;
					slot_6_wdata	<=ts_din_6;
				end
				else	if(ts_cnt_6>12&&ts_cnt_6<76)begin
					slot_6_wr			<=1;
					slot_6_waddr	<=slot_6_waddr+1;
					slot_6_wdata	<=ts_din_6;
				end
				else begin
					slot_6_wr			<=0;
					slot_6_waddr	<=0;
					slot_6_wdata	<=0;
				end
			end
			else begin
				slot_6_wr			<=0;
				slot_6_waddr	<=0;
				slot_6_wdata	<=0;
			end
		end
		
		
		
		reg	[7:0]ts_din_7_r1;
		reg	[7:0]ts_din_7_r2;
		reg	[7:0]ts_din_7_r3;
		reg	ts_din_7_en_r1,ts_din_7_en_r2,ts_din_7_en_r3,ts_din_7_en_r4;
		reg	[7:0]ts_cnt_7;
		reg	tsmf_flag_7;
		reg	tsmf_enable_7;
		reg	[7:0]tsmf_cnt_7;
		reg	[7:0]tsmf_num_7;
		reg	[17:0]time_cnt_7;
		reg	[3:0]tsmf_head_cnt_7;
		
		reg	ch7_wr_enable;
		reg	slot_7_wr;
		reg	[7:0]slot_7_waddr;
		reg	[7:0]slot_7_wdata;
		wire[7:0]slot_7_rdata;
		

    reg	 	ch7_wr;
		reg		[9:0]ch7_din;
		wire	ch7_rd;
		wire	[9:0]ch7_dout;
		wire 	ch7_empty;
   
    
    reg	[1:0]ch7_cstate;
		reg	[1:0]ch7_nstate;
		
		parameter CH7_IDLE=0,
							CH7_HEAD=1,
							CH7_TS	=2;		
	
		
		always@(posedge clk)begin
			if(ts_din_7_en)
				ts_cnt_7	<=	ts_cnt_7+1;
			else
				ts_cnt_7	<=0;
		end
		
		
		always@(posedge clk)begin
			ts_din_7_r1	<=	ts_din_7;
			ts_din_7_r2	<=	ts_din_7_r1;
			ts_din_7_r3	<=	ts_din_7_r2;
			
			ts_din_7_en_r1	<=	ts_din_7_en;
			ts_din_7_en_r2	<=	ts_din_7_en_r1;
			ts_din_7_en_r3	<=	ts_din_7_en_r2;
			ts_din_7_en_r4	<=	ts_din_7_en_r3;
		end
    
    always@(posedge clk)begin
			if(rst)
				tsmf_flag_7	<=0;
			else if(ts_cnt_7==2)
				if(ts_din_7_r2==8'h47 && ts_din_7_r1==8'h1f&& ts_din_7==8'hfe)
					tsmf_flag_7	<=1;
				else
					tsmf_flag_7	<=0;
			else
				tsmf_flag_7	<=0;				
		end
    
    always@(posedge clk)begin
			if(rst)
				tsmf_head_cnt_7	<=0;
			else if(tsmf_flag_7)
				tsmf_head_cnt_7	<=ts_din_7[3:0];
			else
				tsmf_head_cnt_7	<=tsmf_head_cnt_7;
		end
    
    always@(posedge clk)begin
			if(rst)
				ch7_cstate	<=	CH7_IDLE;
			else	
				ch7_cstate	<=	ch7_nstate;
		end	
		
		always@(*)begin
			case(ch7_cstate)
				CH7_IDLE:
					if(tsmf_flag_7)	
						ch7_nstate	=	CH7_HEAD;
					else
						ch7_nstate	=	CH7_IDLE;
				CH7_HEAD:
					if(!ts_din_7_en_r3)
						ch7_nstate	=	CH7_TS;
					else
						ch7_nstate	=	CH7_HEAD;			
				CH7_TS:
					if(tsmf_flag_7)
						ch7_nstate	=	CH7_HEAD;
					else if(!ts_din_7_en_r3&&ts_din_7_en_r4)
						if(tsmf_cnt_7==tsmf_num_7)
							ch7_nstate	=	CH7_IDLE;
						else
							ch7_nstate	=	CH7_TS;
					else if(time_cnt_7==TIME_OUT)
						ch7_nstate	=	CH7_IDLE;
					else
						ch7_nstate	=	CH7_TS;
				default:
					ch7_nstate	=	CH7_IDLE;	
			endcase
		end
		
		always@(posedge clk)begin
			if(ch7_cstate==CH7_IDLE)
				tsmf_cnt_7	<=	0;
			else if(CH7_TS ==ch7_cstate && ts_din_7_en&& !ts_din_7_en_r1)begin
				tsmf_cnt_7	<=	tsmf_cnt_7+1;					
			end
			else
				tsmf_cnt_7	<=	tsmf_cnt_7;
		end
    
    
     always@(posedge clk)begin
			if(ch7_cstate==CH7_TS)begin
				if(ch7_nstate==CH7_IDLE ||ch7_nstate==CH7_HEAD)begin
					ch7_wr	<=1;
					ch7_din	<=10'h200;	
				end
				else if(ts_din_7_en_r3)begin
					if(!ts_din_7_en_r4)begin
						ch7_wr	<=ch7_wr_enable;
						ch7_din	<={2'b01,ts_din_7_r3};				
					end
					else begin
						ch7_wr	<=ch7_wr_enable;
						ch7_din	<={2'b00,ts_din_7_r3};					
					end
				end						
				else begin
					ch7_wr	<=0;
					ch7_din	<=0;
				end
			end
			else begin
				ch7_wr	<=0;
				ch7_din	<=0;
			end
				
		end
    
    
    
    always@(posedge clk)begin
			if(ch7_cstate==CH7_HEAD ||ch7_cstate==CH7_TS)
				time_cnt_7	<=	time_cnt_7+1;
			else
				time_cnt_7	<=	0;			
		end
    
    
    always@(posedge clk)begin
    	if(ch7_cstate==CH7_TS)begin
    		if(ts_din_7_en&&!ts_din_7_en_r1)begin
    			if(tsmf_cnt_7[0]==0)begin
	    			if(slot_7_rdata[7:4]==ch7_no)
	    				ch7_wr_enable	<=1;
	    			else
	    				ch7_wr_enable	<=0;
    			end
    			else	begin
	    			if(slot_7_rdata[3:0]==ch7_no)
	    				ch7_wr_enable	<=1;
	    			else
	    				ch7_wr_enable	<=0;
    			end    			
    		end
    		else
    			ch7_wr_enable	<=	ch7_wr_enable;    		
    	end
    	else
    		ch7_wr_enable	<=0;
    end
    
    slot_buf slot_buf_7 (
		  .clka(clk), // input clka
		  .wea(slot_7_wr), // input [0 : 0] wea
		  .addra(slot_7_waddr), // input [7 : 0] addra
		  .dina(slot_7_wdata), // input [7 : 0] dina
		  .clkb(clk), // input clkb
		  .addrb({1'b0,tsmf_cnt_7[7:1]}), // input [7 : 0] addrb
		  .doutb(slot_7_rdata) // output [7 : 0] doutb
		);
		
		
		always@(posedge clk)begin
			if(ch7_cstate==CH7_IDLE)
				tsmf_num_7	<=0;
			else if(ch7_cstate==CH7_HEAD)
				if(ts_cnt_7>11&&ts_cnt_7<76)
					if(ts_din_7	!=0)
						tsmf_num_7	<=tsmf_num_7+1;
					else
						tsmf_num_7	<=tsmf_num_7;
				else
					tsmf_num_7	<=tsmf_num_7;
			else
				tsmf_num_7	<=tsmf_num_7;
		end
		
		always@(posedge clk)begin
			if(rst)begin
				slot_7_wr			<=0;
				slot_7_waddr	<=0;
				slot_7_wdata	<=0;
			end
			else if(ch7_cstate==CH7_HEAD)begin
				if(ts_cnt_7==12)begin
					slot_7_wr			<=1;
					slot_7_waddr	<=0;
					slot_7_wdata	<=ts_din_7;
				end
				else	if(ts_cnt_7>12&&ts_cnt_7<76)begin
					slot_7_wr			<=1;
					slot_7_waddr	<=slot_7_waddr+1;
					slot_7_wdata	<=ts_din_7;
				end
				else begin
					slot_7_wr			<=0;
					slot_7_waddr	<=0;
					slot_7_wdata	<=0;
				end
			end
			else begin
				slot_7_wr			<=0;
				slot_7_waddr	<=0;
				slot_7_wdata	<=0;
			end
		end
		
		reg	[7:0]ts_din_8_r1;
		reg	[7:0]ts_din_8_r2;
		reg	[7:0]ts_din_8_r3;
		reg	ts_din_8_en_r1,ts_din_8_en_r2,ts_din_8_en_r3,ts_din_8_en_r4;
		reg	[7:0]ts_cnt_8;
		reg	tsmf_flag_8;
		reg	tsmf_enable_8;
		reg	[7:0]tsmf_cnt_8;
		reg	[7:0]tsmf_num_8;
		reg	[17:0]time_cnt_8;
		reg	[3:0]tsmf_head_cnt_8;
		
		reg	ch8_wr_enable;
		reg	slot_8_wr;
		reg	[7:0]slot_8_waddr;
		reg	[7:0]slot_8_wdata;
		wire[7:0]slot_8_rdata;
		
		
    reg	 	ch8_wr;
		reg		[9:0]ch8_din;
		wire	ch8_rd;
		wire	[9:0]ch8_dout;
		wire 	ch8_empty;
   
    
    reg	[1:0]ch8_cstate;
		reg	[1:0]ch8_nstate;
		
		parameter CH8_IDLE=0,
							CH8_HEAD=1,
							CH8_TS	=2;		
	
		
		always@(posedge clk)begin
			if(ts_din_8_en)
				ts_cnt_8	<=	ts_cnt_8+1;
			else
				ts_cnt_8	<=0;
		end
		
		
		always@(posedge clk)begin
			ts_din_8_r1	<=	ts_din_8;
			ts_din_8_r2	<=	ts_din_8_r1;
			ts_din_8_r3	<=	ts_din_8_r2;
			
			ts_din_8_en_r1	<=	ts_din_8_en;
			ts_din_8_en_r2	<=	ts_din_8_en_r1;
			ts_din_8_en_r3	<=	ts_din_8_en_r2;
			ts_din_8_en_r4	<=	ts_din_8_en_r3;
		end
    
    always@(posedge clk)begin
			if(rst)
				tsmf_flag_8	<=0;
			else if(ts_cnt_8==2)
				if(ts_din_8_r2==8'h47 && ts_din_8_r1==8'h1f&& ts_din_8==8'hfe)
					tsmf_flag_8	<=1;
				else
					tsmf_flag_8	<=0;
			else
				tsmf_flag_8	<=0;				
		end
    
    
    always@(posedge clk)begin
			if(rst)
				tsmf_head_cnt_8	<=0;
			else if(tsmf_flag_8)
				tsmf_head_cnt_8	<=ts_din_8[3:0];
			else
				tsmf_head_cnt_8	<=tsmf_head_cnt_8;
		end
    
    always@(posedge clk)begin
			if(rst)
				ch8_cstate	<=	CH8_IDLE;
			else	
				ch8_cstate	<=	ch8_nstate;
		end	
		
		always@(*)begin
			case(ch8_cstate)
				CH8_IDLE:
					if(tsmf_flag_8)	
						ch8_nstate	=	CH8_HEAD;
					else
						ch8_nstate	=	CH8_IDLE;
				CH8_HEAD:
					if(!ts_din_8_en_r3)
						ch8_nstate	=	CH8_TS;
					else
						ch8_nstate	=	CH8_HEAD;			
				CH8_TS:
					if(tsmf_flag_8)
						ch8_nstate	=	CH8_HEAD;
					else if(!ts_din_8_en_r3&&ts_din_8_en_r4)
						if(tsmf_cnt_8==tsmf_num_8)
							ch8_nstate	=	CH8_IDLE;
						else
							ch8_nstate	=	CH8_TS;
					else if(time_cnt_8==TIME_OUT)
						ch8_nstate	=	CH8_IDLE;
					else
						ch8_nstate	=	CH8_TS;
				default:
					ch8_nstate	=	CH8_IDLE;	
			endcase
		end
		
		always@(posedge clk)begin
			if(ch8_cstate==CH8_IDLE)
				tsmf_cnt_8	<=	0;
			else if(CH8_TS ==ch8_cstate && ts_din_8_en&& !ts_din_8_en_r1)begin
				tsmf_cnt_8	<=	tsmf_cnt_8+1;					
			end
			else
				tsmf_cnt_8	<=	tsmf_cnt_8;
		end
    
    always@(posedge clk)begin
			if(ch8_cstate==CH8_TS)begin
				if(ch8_nstate==CH8_IDLE ||ch8_nstate==CH8_HEAD)begin
					ch8_wr	<=1;
					ch8_din	<=10'h200;	
				end
				else if(ts_din_8_en_r3)begin
					if(!ts_din_8_en_r4)begin
						ch8_wr	<=ch8_wr_enable;
						ch8_din	<={2'b01,ts_din_8_r3};				
					end
					else begin
						ch8_wr	<=ch8_wr_enable;
						ch8_din	<={2'b00,ts_din_8_r3};					
					end
				end					
				else begin
					ch8_wr	<=0;
					ch8_din	<=0;
				end
			end
			else begin
				ch8_wr	<=0;
				ch8_din	<=0;
			end
				
		end
    
    
    
    always@(posedge clk)begin
			if(ch8_cstate==CH8_HEAD ||ch8_cstate==CH8_TS)
				time_cnt_8	<=	time_cnt_8+1;
			else
				time_cnt_8	<=	0;			
		end
    
    
    always@(posedge clk)begin
    	if(ch8_cstate==CH8_TS)begin
    		if(ts_din_8_en&&!ts_din_8_en_r1)begin
    			if(tsmf_cnt_8[0]==0)begin
	    			if(slot_8_rdata[7:4]==ch8_no)
	    				ch8_wr_enable	<=1;
	    			else
	    				ch8_wr_enable	<=0;
    			end
    			else	begin
	    			if(slot_8_rdata[3:0]==ch8_no)
	    				ch8_wr_enable	<=1;
	    			else
	    				ch8_wr_enable	<=0;
    			end    			
    		end
    		else
    			ch8_wr_enable	<=	ch8_wr_enable;    		
    	end
    	else
    		ch8_wr_enable	<=0;
    end
    
    slot_buf slot_buf_8 (
		  .clka(clk), // input clka
		  .wea(slot_8_wr), // input [0 : 0] wea
		  .addra(slot_8_waddr), // input [7 : 0] addra
		  .dina(slot_8_wdata), // input [7 : 0] dina
		  .clkb(clk), // input clkb
		  .addrb({1'b0,tsmf_cnt_8[7:1]}), // input [7 : 0] addrb
		  .doutb(slot_8_rdata) // output [7 : 0] doutb
		);
		
		
		always@(posedge clk)begin
			if(ch8_cstate==CH8_IDLE)
				tsmf_num_8	<=0;
			else if(ch8_cstate==CH8_HEAD)
				if(ts_cnt_8>11&&ts_cnt_8<76)
					if(ts_din_8	!=0)
						tsmf_num_8	<=tsmf_num_8+1;
					else
						tsmf_num_8	<=tsmf_num_8;
				else
					tsmf_num_8	<=tsmf_num_8;
			else
				tsmf_num_8	<=tsmf_num_8;
		end
		
		always@(posedge clk)begin
			if(rst)begin
				slot_8_wr			<=0;
				slot_8_waddr	<=0;
				slot_8_wdata	<=0;
			end
			else if(ch8_cstate==CH8_HEAD)begin
				if(ts_cnt_8==12)begin
					slot_8_wr			<=1;
					slot_8_waddr	<=0;
					slot_8_wdata	<=ts_din_8;
				end
				else	if(ts_cnt_8>12&&ts_cnt_8<76)begin
					slot_8_wr			<=1;
					slot_8_waddr	<=slot_8_waddr+1;
					slot_8_wdata	<=ts_din_8;
				end
				else begin
					slot_8_wr			<=0;
					slot_8_waddr	<=0;
					slot_8_wdata	<=0;
				end
			end
			else begin
				slot_8_wr			<=0;
				slot_8_waddr	<=0;
				slot_8_wdata	<=0;
			end
		end
		
		
		
    
    reg	[17:0]time_cnt;
    
   	reg	[4:0]rcstate;
		reg	[4:0]rnstate;
   	
   	reg	ch1_dout_valid;
   	reg	ch2_dout_valid;
   	reg	ch3_dout_valid;
   	reg	ch4_dout_valid;
   	reg	ch5_dout_valid;
   	reg	ch6_dout_valid;
   	reg	ch7_dout_valid;
   	reg	ch8_dout_valid;
   	
   	

		parameter	R_IDLE=0,
							R_CH1_WAIT=1,
							R_CH1_TS=2,
							R_CH1_CK=3,
							R_CH2_WAIT=4,
							R_CH2_TS=5,
							R_CH2_CK=6,
							R_CH3_WAIT=7,
							R_CH3_TS=8,
							R_CH3_CK=9,
							R_CH4_WAIT=10,
							R_CH4_TS=11,
							R_CH4_CK=12,
							R_CH5_WAIT=13,
							R_CH5_TS=14,
							R_CH5_CK=15,
							R_CH6_WAIT=16,
							R_CH6_TS=17,
							R_CH6_CK=18,
							R_CH7_WAIT=19,
							R_CH7_TS=20,
							R_CH7_CK=21,
							R_CH8_WAIT=22,
							R_CH8_TS=23,
							R_CH8_CK=24;


		always@(posedge clk)begin
			if(tsmf_flag_1)
				tsmf_enable_1	<=1;
			else if(rcstate==R_CH1_CK)
				tsmf_enable_1	<=0;
			else
				tsmf_enable_1	<=tsmf_enable_1;
		end
		
		
		always@(posedge clk)begin
			if(tsmf_flag_2)
				tsmf_enable_2	<=1;
			else if(rcstate==R_CH2_CK)
				tsmf_enable_2	<=0;
			else
				tsmf_enable_2	<=tsmf_enable_2;
		end
		
		always@(posedge clk)begin
			if(tsmf_flag_3)
				tsmf_enable_3	<=1;
			else if(rcstate==R_CH3_CK)
				tsmf_enable_3	<=0;
			else
				tsmf_enable_3	<=tsmf_enable_3;
		end
		
		
		always@(posedge clk)begin
			if(tsmf_flag_4)
				tsmf_enable_4	<=1;
			else if(rcstate==R_CH4_CK)
				tsmf_enable_4	<=0;
			else
				tsmf_enable_4	<=tsmf_enable_4;
		end
		
		
		always@(posedge clk)begin
			if(tsmf_flag_5)
				tsmf_enable_5	<=1;
			else if(rcstate==R_CH5_CK)
				tsmf_enable_5	<=0;
			else
				tsmf_enable_5	<=tsmf_enable_5;
		end
		
		
		always@(posedge clk)begin
			if(tsmf_flag_6)
				tsmf_enable_6	<=1;
			else if(rcstate==R_CH6_CK)
				tsmf_enable_6	<=0;
			else
				tsmf_enable_6	<=tsmf_enable_6;
		end
		
		
		always@(posedge clk)begin
			if(tsmf_flag_7)
				tsmf_enable_7	<=1;
			else if(rcstate==R_CH7_CK)
				tsmf_enable_7	<=0;
			else
				tsmf_enable_7	<=tsmf_enable_7;
		end
		
		
		always@(posedge clk)begin
			if(tsmf_flag_8)
				tsmf_enable_8	<=1;
			else if(rcstate==R_CH8_CK)
				tsmf_enable_8	<=0;
			else
				tsmf_enable_8	<=tsmf_enable_8;
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
					if(tsmf_enable_1&ch_enable[0])
						rnstate	=	R_CH1_WAIT;
					else if(tsmf_enable_2&ch_enable[1])
						rnstate	=	R_CH2_WAIT;
					else if(tsmf_enable_3&ch_enable[2])
						rnstate	=	R_CH3_WAIT;
					else if(tsmf_enable_4&ch_enable[3])
						rnstate	=	R_CH4_WAIT;
					else if(tsmf_enable_5&ch_enable[4])
						rnstate	=	R_CH5_WAIT;
					else if(tsmf_enable_6&ch_enable[5])
						rnstate	=	R_CH6_WAIT;
					else if(tsmf_enable_7&ch_enable[6])
						rnstate	=	R_CH7_WAIT;
					else if(tsmf_enable_8&ch_enable[7])
						rnstate	=	R_CH8_WAIT;						
					else
						rnstate	=	R_IDLE;
				R_CH1_WAIT:
					if(!ch1_empty)
						rnstate	=	R_CH1_TS;
					else
						rnstate	=	R_CH1_WAIT;
				R_CH1_TS:
						if(ch1_dout[9])
							rnstate	=	R_CH1_CK;
						else
							rnstate	=	CH1_TS;
				R_CH1_CK:
					if(tsmf_enable_2&ch_enable[1] && tsmf_cnt==tsmf_head_cnt_2)
						rnstate	=	R_CH2_WAIT;
					else if(time_cnt==TIME_OUT)
						if(ch_enable[2])
							rnstate	=	R_CH2_CK;
						else
							rnstate	=	R_IDLE;	
					else 
						rnstate	=	R_CH1_CK;
				R_CH2_WAIT:
					if(!ch2_empty)
						rnstate	=	R_CH2_TS;
					else
						rnstate	=	R_CH2_WAIT;		
				R_CH2_TS:
						if(ch2_dout[9])
							rnstate	=	R_CH2_CK;
						else                            
							rnstate	=	R_CH2_TS;
				R_CH2_CK:			
					if(tsmf_enable_1&!ch_enable[2]&& tsmf_cnt==tsmf_head_cnt_1)	
							rnstate	=	R_CH1_WAIT;
					else if(tsmf_enable_3&ch_enable[2]&& tsmf_cnt==tsmf_head_cnt_3)
						rnstate	=	R_CH3_WAIT;
					else if(time_cnt==TIME_OUT)
						if(ch_enable[3])
							rnstate	=	R_CH3_CK;
						else
							rnstate	=	R_IDLE;	
					else
						rnstate	=	R_CH2_CK;
				R_CH3_WAIT:
					if(!ch3_empty)
						rnstate	=	R_CH3_TS;
					else
						rnstate	=	R_CH3_WAIT;		
				R_CH3_TS:
						if(ch3_dout[9])
							rnstate	=	R_CH3_CK;
						else
							rnstate	=	R_CH3_TS;
				R_CH3_CK:
					if(tsmf_enable_1&!ch_enable[3]&& tsmf_cnt==tsmf_head_cnt_1)	
							rnstate	=	R_CH1_WAIT;				
					else if(tsmf_enable_4&ch_enable[3]&& tsmf_cnt==tsmf_head_cnt_4)
						rnstate	=	R_CH4_WAIT;
					else if(time_cnt==TIME_OUT)
						if(ch_enable[4])
							rnstate	=	R_CH4_CK;
						else
							rnstate	=	R_IDLE;	
					else
						rnstate	=	R_CH3_CK;
				R_CH4_WAIT:
					if(!ch4_empty)
						rnstate	=	R_CH4_TS;
					else
						rnstate	=	R_CH4_WAIT;		
				R_CH4_TS:
						if(ch4_dout[9])
							rnstate	=	R_CH4_CK;
						else
							rnstate	=	R_CH4_TS;
				R_CH4_CK:	
					if(tsmf_enable_1&!ch_enable[4]&& tsmf_cnt==tsmf_head_cnt_1)	
							rnstate	=	R_CH1_WAIT;				
					else if(tsmf_enable_5&ch_enable[4]&& tsmf_cnt==tsmf_head_cnt_5)
						rnstate	=	R_CH5_WAIT;
					else if(time_cnt==TIME_OUT)
						if(ch_enable[5])
							rnstate	=	R_CH5_CK;
						else
							rnstate	=	R_IDLE;	
					else
						rnstate	=	R_CH4_CK;
				R_CH5_WAIT:
					if(!ch5_empty)
						rnstate	=	R_CH5_TS;
					else
						rnstate	=	R_CH5_WAIT;		
				R_CH5_TS:
						if(ch5_dout[9])
							rnstate	=	R_CH5_CK;
						else
							rnstate	=	R_CH5_TS;
				R_CH5_CK:				
					if(tsmf_enable_1&!ch_enable[5]&& tsmf_cnt==tsmf_head_cnt_1)	
							rnstate	=	R_CH1_WAIT;				
					else if(tsmf_enable_6&ch_enable[5]&& tsmf_cnt==tsmf_head_cnt_6)
						rnstate	=	R_CH6_WAIT;
					else if(time_cnt==TIME_OUT)
						if(ch_enable[5])
							rnstate	=	R_CH6_CK;
						else
							rnstate	=	R_IDLE;	
					else
						rnstate	=	R_CH5_CK;
				R_CH6_WAIT:
					if(!ch6_empty)
						rnstate	=	R_CH6_TS;
					else
						rnstate	=	R_CH6_WAIT;		
				R_CH6_TS:
						if(ch6_dout[9])
							rnstate	=	R_CH6_CK;
						else
							rnstate	=	R_CH6_TS;
				R_CH6_CK:			
					if(tsmf_enable_1&!ch_enable[6]&& tsmf_cnt==tsmf_head_cnt_1)	
							rnstate	=	R_CH1_WAIT;				
					else if(tsmf_enable_7&ch_enable[6]&& tsmf_cnt==tsmf_head_cnt_7)
						rnstate	=	R_CH7_WAIT;
					else if(time_cnt==TIME_OUT)
						if(ch_enable[6])
							rnstate	=	R_CH7_CK;
						else
							rnstate	=	R_IDLE;	
					else
						rnstate	=	R_CH6_CK;
				R_CH7_WAIT:
					if(!ch7_empty)
						rnstate	=	R_CH7_TS;
					else
						rnstate	=	R_CH7_WAIT;		
				R_CH7_TS:
						if(ch7_dout[9])
							rnstate	=	R_CH7_CK;
						else
							rnstate	=	R_CH7_TS;
				R_CH7_CK:				
					if(tsmf_enable_1&!ch_enable[7]&& tsmf_cnt==tsmf_head_cnt_1)	
							rnstate	=	R_CH1_WAIT;				
					else if(tsmf_enable_8&ch_enable[7]&& tsmf_cnt==tsmf_head_cnt_8)
						rnstate	=	R_CH8_WAIT;
					else if(time_cnt==TIME_OUT)
						if(ch_enable[7])
							rnstate	=	R_CH8_CK;
						else
							rnstate	=	R_IDLE;	
					else
						rnstate	=	R_CH7_CK;		
				R_CH8_WAIT:
					if(!ch8_empty)
						rnstate	=	R_CH8_TS;
					else
						rnstate	=	R_CH8_WAIT;		
				R_CH8_TS:
						if(ch8_dout[9])
							rnstate	=	R_CH8_CK;
						else
							rnstate	=	R_CH8_TS;
				R_CH8_CK:				
//					if(tsmf_enable_1&ch_enable[0]&& tsmf_cnt==tsmf_cnt_4)
//						rnstate	=	R_CH4_TS;
//					else if(time_cnt==TIME_OUT)
//						if(ch_enable[4])
//							rnstate	=	R_CH4_CK;
//						else
//							rnstate	=	R_IDLE;	
//					else
						rnstate	=	R_IDLE;
				default:
					rnstate	=	R_IDLE;
			endcase
		end
		
		always@(posedge clk)begin
			if(rnstate==R_CH1_WAIT&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_head_cnt_1;
			else if(rnstate==R_CH2_WAIT&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_head_cnt_2;
			else if(rnstate==R_CH3_WAIT&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_head_cnt_3;
			else if(rnstate==R_CH4_WAIT&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_head_cnt_4;
			else if(rnstate==R_CH5_WAIT&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_head_cnt_5;
			else if(rnstate==R_CH6_WAIT&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_head_cnt_6;
			else if(rnstate==R_CH7_WAIT&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_head_cnt_7;
			else if(rnstate==R_CH8_WAIT&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_head_cnt_8;
			else if(rcstate==R_CH1_TS &&ch1_dout[9])
				tsmf_cnt	<=tsmf_cnt+1;
			else if(rcstate==R_CH2_TS &&ch2_dout[9])
				tsmf_cnt	<=tsmf_cnt+1;	
			else if(rcstate==R_CH3_TS &&ch3_dout[9])
				tsmf_cnt	<=tsmf_cnt+1;	
			else if(rcstate==R_CH4_TS &&ch4_dout[9])
				tsmf_cnt	<=tsmf_cnt+1;	
			else if(rcstate==R_CH5_TS &&ch5_dout[9])
				tsmf_cnt	<=tsmf_cnt+1;	
			else if(rcstate==R_CH6_TS &&ch6_dout[9])
				tsmf_cnt	<=tsmf_cnt+1;	
			else if(rcstate==R_CH7_TS &&ch7_dout[9])
				tsmf_cnt	<=tsmf_cnt+1;	
			else if(rcstate==R_CH8_TS &&ch8_dout[9])
				tsmf_cnt	<=tsmf_cnt+1;		
			else if(time_cnt==TIME_OUT)
				tsmf_cnt	<=tsmf_cnt+1;
			else
				tsmf_cnt	<=tsmf_cnt;
		end
		
		always@(posedge clk)begin
			if(rcstate==R_CH1_CK||rcstate==R_CH2_CK||rcstate==R_CH3_CK||rcstate==R_CH4_CK
			||rcstate==R_CH5_CK||rcstate==R_CH6_CK||rcstate==R_CH7_CK||rcstate==R_CH8_CK)
				if(time_cnt==TIME_OUT)
					time_cnt	<=0;
				else
					time_cnt	<=	time_cnt	+1;
			else
				time_cnt	<=	0;
		end
		
		
		assign ch1_rd=((rnstate==R_CH1_TS)&&!ch1_empty)?1'b1:1'b0;
		assign ch2_rd=((rnstate==R_CH2_TS)&&!ch2_empty)?1'b1:1'b0;
		assign ch3_rd=((rnstate==R_CH3_TS)&&!ch3_empty)?1'b1:1'b0;
		assign ch4_rd=((rnstate==R_CH4_TS)&&!ch4_empty)?1'b1:1'b0;
		assign ch5_rd=((rnstate==R_CH5_TS)&&!ch5_empty)?1'b1:1'b0;
		assign ch6_rd=((rnstate==R_CH6_TS)&&!ch6_empty)?1'b1:1'b0;
		assign ch7_rd=((rnstate==R_CH7_TS)&&!ch7_empty)?1'b1:1'b0;
		assign ch8_rd=((rnstate==R_CH8_TS)&&!ch8_empty)?1'b1:1'b0;
		
		
		always@(posedge clk)begin
			ch1_dout_valid	<=	ch1_rd;
			ch2_dout_valid	<=	ch2_rd;
			ch3_dout_valid	<=	ch3_rd;
			ch4_dout_valid	<=	ch4_rd;
			ch5_dout_valid	<=	ch5_rd;
			ch6_dout_valid	<=	ch6_rd;
			ch7_dout_valid	<=	ch7_rd;
			ch8_dout_valid	<=	ch8_rd;
		end
		
		always@(posedge clk)begin
			if(ch1_dout_valid)begin
				ts_dout_en		<=!ch1_dout[9];
				ts_dout_syn		<=ch1_dout[8];
				ts_dout				<=ch1_dout;
			end
			else if(ch2_dout_valid)begin
				ts_dout_en		<=!ch2_dout[9];
				ts_dout_syn		<=ch2_dout[8];
				ts_dout				<=ch2_dout;
			end
			else if(ch3_dout_valid)begin
				ts_dout_en		<=!ch3_dout[9];
				ts_dout_syn		<=ch3_dout[8];
				ts_dout				<=ch3_dout;
			end
			else if(ch4_dout_valid)begin
				ts_dout_en		<=!ch4_dout[9];
				ts_dout_syn		<=ch4_dout[8];
				ts_dout				<=ch4_dout;
			end
			else if(ch5_dout_valid)begin
				ts_dout_en		<=!ch5_dout[9];
				ts_dout_syn		<=ch5_dout[8];
				ts_dout				<=ch5_dout;
			end
			else if(ch6_dout_valid)begin
				ts_dout_en		<=!ch6_dout[9];
				ts_dout_syn		<=ch6_dout[8];
				ts_dout				<=ch6_dout;
			end
			else if(ch7_dout_valid)begin
				ts_dout_en		<=!ch7_dout[9];
				ts_dout_syn		<=ch7_dout[8];
				ts_dout				<=ch7_dout;
			end
			else if(ch8_dout_valid)begin
				ts_dout_en		<=!ch8_dout[9];
				ts_dout_syn		<=ch8_dout[8];
				ts_dout				<=ch8_dout;
			end
			else begin
				ts_dout_en		<=0;
				ts_dout_syn		<=0;
				ts_dout				<=0;
			end
		end
		
		
		ts_data_fifo ts_fifo_1 (
		  .rst(rst), // input rst
		  .wr_clk(clk), // input wr_clk
		  .rd_clk(clk), // input rd_clk
		  .din(ch1_din), // input [8 : 0] din
		  .wr_en(ch1_wr), // input wr_en
		  .rd_en(ch1_rd), // input rd_en
		  .dout(ch1_dout), // output [8 : 0] dout
		  .full(), // output full
		  .empty(ch1_empty) // output empty
		);
		
		ts_data_fifo ts_fifo_2 (
		  .rst(rst), // input rst
		  .wr_clk(clk), // input wr_clk
		  .rd_clk(clk), // input rd_clk
		  .din(ch2_din), // input [8 : 0] din
		  .wr_en(ch2_wr), // input wr_en
		  .rd_en(ch2_rd), // input rd_en
		  .dout(ch2_dout), // output [8 : 0] dout
		  .full(), // output full
		  .empty(ch2_empty) // output empty
		);
		
		ts_data_fifo ts_fifo_3 (
		  .rst(rst), // input rst
		  .wr_clk(clk), // input wr_clk
		  .rd_clk(clk), // input rd_clk
		  .din(ch3_din), // input [8 : 0] din
		  .wr_en(ch3_wr), // input wr_en
		  .rd_en(ch3_rd), // input rd_en
		  .dout(ch3_dout), // output [8 : 0] dout
		  .full(), // output full
		  .empty(ch3_empty) // output empty
		);
		
		
		ts_data_fifo ts_fifo_4 (
		  .rst(rst), // input rst
		  .wr_clk(clk), // input wr_clk
		  .rd_clk(clk), // input rd_clk
		  .din(ch4_din), // input [8 : 0] din
		  .wr_en(ch4_wr), // input wr_en
		  .rd_en(ch4_rd), // input rd_en
		  .dout(ch4_dout), // output [8 : 0] dout
		  .full(), // output full
		  .empty(ch4_empty) // output empty
		);
		
		
		ts_data_fifo ts_fifo_5 (
		  .rst(rst), // input rst
		  .wr_clk(clk), // input wr_clk
		  .rd_clk(clk), // input rd_clk
		  .din(ch5_din), // input [8 : 0] din
		  .wr_en(ch5_wr), // input wr_en
		  .rd_en(ch5_rd), // input rd_en
		  .dout(ch5_dout), // output [8 : 0] dout
		  .full(), // output full
		  .empty(ch5_empty) // output empty
		);
		
		
		ts_data_fifo ts_fifo_6 (
		  .rst(rst), // input rst
		  .wr_clk(clk), // input wr_clk
		  .rd_clk(clk), // input rd_clk
		  .din(ch6_din), // input [8 : 0] din
		  .wr_en(ch6_wr), // input wr_en
		  .rd_en(ch6_rd), // input rd_en
		  .dout(ch6_dout), // output [8 : 0] dout
		  .full(), // output full
		  .empty(ch6_empty) // output empty
		);
		
		
		ts_data_fifo ts_fifo_7 (
		  .rst(rst), // input rst
		  .wr_clk(clk), // input wr_clk
		  .rd_clk(clk), // input rd_clk
		  .din(ch7_din), // input [8 : 0] din
		  .wr_en(ch7_wr), // input wr_en
		  .rd_en(ch7_rd), // input rd_en
		  .dout(ch7_dout), // output [8 : 0] dout
		  .full(), // output full
		  .empty(ch7_empty) // output empty
		);
		
		
		ts_data_fifo ts_fifo_8 (
		  .rst(rst), // input rst
		  .wr_clk(clk), // input wr_clk
		  .rd_clk(clk), // input rd_clk
		  .din(ch8_din), // input [8 : 0] din
		  .wr_en(ch8_wr), // input wr_en
		  .rd_en(ch8_rd), // input rd_en
		  .dout(ch8_dout), // output [8 : 0] dout
		  .full(), // output full
		  .empty(ch8_empty) // output empty
		);


endmodule
