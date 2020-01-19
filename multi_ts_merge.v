`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:24:41 10/25/2019 
// Design Name: 
// Module Name:    multi_ts_merge 
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
module multi_ts_merge(

		clk,
		rst,
		
		ts_din_1,
		ts_din_en_1,
		
		ts_din_2,
		ts_din_en_2,
		
		ts_din_3,
		ts_din_en_3,
		
		ts_din_4,
		ts_din_en_4,
		
		ts_din_5,
		ts_din_en_5,
		
		ts_din_6,
		ts_din_en_6,
		
		ts_din_7,
		ts_din_en_7,
		
		ts_din_8,
		ts_din_en_8

    );
    
    input 	clk;
    input		rst;
    
    input 	[7:0]ts_din_1;
    input 	ts_din_en_1;

		input 	[7:0]ts_din_2;
    input 	ts_din_en_2;
    
    input 	[7:0]ts_din_3;
    input 	ts_din_en_3;
    
    input 	[7:0]ts_din_4;
    input 	ts_din_en_4;
    
    input 	[7:0]ts_din_5;
    input 	ts_din_en_5;

		input 	[7:0]ts_din_6;
    input 	ts_din_en_6;
    
    input 	[7:0]ts_din_7;
    input 	ts_din_en_7;
    
    input 	[7:0]ts_din_8;
    input 	ts_din_en_8;



		
		
		
		reg	[4:0]rcstate;
		reg	[4:0]rnstate;
		
		parameter	R_IDLE=0,
							R_CH1_HEAD=1,
							R_CH1_TS=2,
							R_CH1_CK=3,
							R_CH2_HEAD=4,
							R_CH2_TS=5,
							R_CH2_CK=6,
							R_CH3_HEAD=7,
							R_CH3_TS=8,
							R_CH3_CK=9,
							R_CH4_HEAD=10,
							R_CH4_TS=11,
							R_CH4_CK=12,
							R_CH5_HEAD=13,
							R_CH5_TS=14,
							R_CH5_CK=15,
							R_CH6_HEAD=16,
							R_CH6_TS=17,
							R_CH6_CK=18,
							R_CH7_HEAD=19,
							R_CH7_TS=20,
							R_CH7_CK=21,
							R_CH8_HEAD=22,
							R_CH8_TS=23,
							R_CH8_CK=24;

		
		
		reg	[7:0]ch_enable;//通道使能，1代表通道有数据
		
		reg	[7:0]ts_din_1_r1;
		reg	[7:0]ts_din_1_r2;
		reg	[7:0]ts_din_1_r3;
		reg	ts_din_en_1_r1,ts_din_en_1_r2,ts_din_en_1_r3,ts_din_en_1_r4;
		reg	[7:0]ts_cnt_1;
		reg	tsmf_flag_1;
		reg	[7:0]tsmf_cnt_1;
		reg	[7:0]tsmf_num_1;
		
		
		reg	[31:0]s1_info_1;//1-8
		reg	[31:0]s1_info_2;//1-8
		reg	[31:0]s1_info_3;//1-8
		reg	[31:0]s1_info_4;//1-8
		reg	[31:0]s1_info_5;//1-8
		reg	[31:0]s1_info_6;//1-8
		reg	[31:0]s1_info_7;//1-8
		reg	[31:0]s1_info_8;//1-8
		reg	[31:0]s1_info_9;//1-8
		reg	[31:0]s1_info_10;//1-8
		reg	[31:0]s1_info_11;//1-8
		reg	[31:0]s1_info_12;//1-8
		reg	[31:0]s1_info_13;//1-8
		reg	[31:0]s1_info_14;//1-8
		reg	[31:0]s1_info_15;//1-8
		reg	[31:0]s1_info_16;//1-8
		
		always@(posedge clk)begin
		 ch_enable=8'hff;
		end
		
		reg	 	ch1_wr;
		reg		[8:0]ch1_din;
		wire	ch1_rd;
		wire	[8:0]ch1_dout;
		wire 	ch1_empty;
		
		reg	[1:0]ch1_cstate;
		reg	[1:0]ch1_nstate;
		
		parameter CH1_IDLE=0,
							CH1_HEAD=1,
							CH1_TS	=2;		
		
		
		reg	[3:0]tsmf_cnt;
		
		
		
		
		always@(posedge clk)begin
			if(ts_din_en_1)
				ts_cnt_1	<=	ts_cnt_1+1;
			else
				ts_cnt_1	<=0;
		end
		
		
		always@(posedge clk)begin
			ts_din_1_r1	<=	ts_din_1;
			ts_din_1_r2	<=	ts_din_1_r1;
			ts_din_1_r3	<=	ts_din_1_r2;
			
			ts_din_en_1_r1	<=	ts_din_en_1;
			ts_din_en_1_r2	<=	ts_din_en_1_r1;
			ts_din_en_1_r3	<=	ts_din_en_1_r2;
			ts_din_en_1_r4	<=	ts_din_en_1_r3;
		end
		
		always@(posedge clk)begin
			if(rst)
				tsmf_flag_1	<=0;
			else if(ts_cnt_1==2)
				if(ts_din_1_r2==8'h47 && ts_din_1_r1==8'h1f&& ts_din_1==8'hfe)
					tsmf_flag_1	<=1;
				else
					tsmf_flag_1	<=tsmf_flag_1;
			else if(rcstate==R_CH1_HEAD)
				tsmf_flag_1	<=0;
			else
				tsmf_flag_1	<=tsmf_flag_1;				
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
					if(!ts_din_en_1_r3)
						ch1_nstate	=	CH1_TS;
					else
						ch1_nstate	=	CH1_HEAD;
				CH1_TS:
					if(tsmf_flag_1)
						ch1_nstate	=	CH1_HEAD;
					else if(!ts_din_en_1_r3&&ts_din_en_1_r4)
						if(tsmf_cnt_1==tsmf_num_1)
							ch1_nstate	=	CH1_IDLE;
						else
							ch1_nstate	=	CH1_TS;
					else
						ch1_nstate	=	CH1_TS;
				default:
					ch1_nstate	=	CH1_IDLE;	
			endcase
		end
		
		always@(posedge clk)begin
			if(ch1_cstate==CH1_IDLE)
				tsmf_cnt_1	<=	0;
			else if(CH1_TS ==ch1_cstate && ts_din_en_1&& !ts_din_en_1_r1)begin
				tsmf_cnt_1	<=	tsmf_cnt_1+1;					
			end
			else
				tsmf_cnt_1	<=	tsmf_cnt_1;
		end
		
		
		
		always@(posedge clk)begin
			if(ch1_cstate==CH1_TS)begin
				if(tsmf_flag_1)begin
					ch1_wr	<=1;
					ch1_din	<=9'h100;	
				end
				else if(ts_din_en_1_r3)begin
					ch1_wr	<=1;
					ch1_din	<={1'b0,ts_din_1_r3};					
				end				
				else if(tsmf_cnt_1==tsmf_num_1&& !ts_din_en_1_r3&&ts_din_en_1_r4)begin
					ch1_wr	<=1;
					ch1_din	<=9'h100;	
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
		
		always@(posedge clk)begin
			if(CH1_IDLE==ch1_cstate)begin
				tsmf_num_1	<=	0;
				s1_info_1		<=	0; 				
				s1_info_2		<=  0;
				s1_info_3		<=  0;
				s1_info_4		<=  0;
				s1_info_5		<=  0;
				s1_info_6		<=  0;
				s1_info_7		<=  0;
				s1_info_8		<=  0;
				s1_info_9		<=  0;
				s1_info_10	<=  0;
				s1_info_11	<=  0;
				s1_info_12	<=  0;
				s1_info_13	<=  0;
				s1_info_14	<=  0;
				s1_info_15	<=	0;
			end
			else if(CH1_HEAD==ch1_cstate)begin
				case(ts_cnt_1)
					7'd12,
					7'd13,
					7'd14,
					7'd15:begin
						s1_info_1	<={s1_info_1[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd16,
					7'd17,
					7'd18,
					7'd19:begin
						s1_info_2	<={s1_info_1[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd20,
					7'd21,
					7'd22,
					7'd23:begin
						s1_info_3	<={s1_info_3[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd24,
					7'd25,
					7'd26,
					7'd27:begin
						s1_info_4	<={s1_info_4[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd28,
					7'd29,
					7'd30,
					7'd31:begin
						s1_info_5	<={s1_info_5[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd32,
					7'd33,
					7'd34,
					7'd35:begin
						s1_info_6	<={s1_info_6[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd36,
					7'd37,
					7'd38,
					7'd39:begin
						s1_info_7	<={s1_info_7[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd40,
					7'd41,
					7'd42,
					7'd43:begin
						s1_info_8	<={s1_info_8[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd44,
					7'd45,
					7'd46,
					7'd47:begin
						s1_info_9	<={s1_info_9[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd48,
					7'd49,
					7'd50,
					7'd51:begin
						s1_info_10	<={s1_info_10[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd52,
					7'd53,
					7'd54,
					7'd55:begin
						s1_info_11	<={s1_info_11[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd56,
					7'd57,
					7'd58,
					7'd59:begin
						s1_info_12	<={s1_info_12[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd60,
					7'd61,
					7'd62,
					7'd63:begin
						s1_info_13	<={s1_info_13[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd64,
					7'd65,
					7'd66,
					7'd67:begin
						s1_info_14	<={s1_info_14[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd68,
					7'd69,
					7'd70,
					7'd71:begin
						s1_info_15	<={s1_info_15[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					7'd72,
					7'd73,
					7'd74,
					7'd75:begin
						s1_info_16	<={s1_info_6[23:0],ts_din_1};
						if(ts_din_1!==0)
							tsmf_num_1	<=tsmf_num_1+1;
						else
							tsmf_num_1	<=tsmf_num_1;
					end
					default:begin				
						tsmf_num_1	<=	tsmf_num_1;
						s1_info_1		<=	s1_info_1; 				
						s1_info_2		<=  s1_info_2;
						s1_info_3		<=  s1_info_3;
						s1_info_4		<=  s1_info_4;
						s1_info_5		<=  s1_info_5;
						s1_info_6		<=  s1_info_6;
						s1_info_7		<=  s1_info_7;
						s1_info_8		<=  s1_info_8;
						s1_info_9		<=  s1_info_9;
						s1_info_10		<=  s1_info_10;
						s1_info_11		<=  s1_info_11;
						s1_info_12		<=  s1_info_12;
						s1_info_13		<=  s1_info_13;
						s1_info_14		<=  s1_info_14;
						s1_info_15		<=	s1_info_15;
						s1_info_16		<=	s1_info_16;
					end
				endcase	
			end
			else begin
				s1_info_1		<=	s1_info_1; 				
				s1_info_2		<=  s1_info_2;
				s1_info_3		<=  s1_info_3;
				s1_info_4		<=  s1_info_4;
				s1_info_5		<=  s1_info_5;
				s1_info_6		<=  s1_info_6;
				s1_info_7		<=  s1_info_7;
				s1_info_8		<=  s1_info_8;
				s1_info_9		<=  s1_info_9;
				s1_info_10		<=  s1_info_10;
				s1_info_11		<=  s1_info_11;
				s1_info_12		<=  s1_info_12;
				s1_info_13		<=  s1_info_13;
				s1_info_14		<=  s1_info_14;
				s1_info_15		<=	s1_info_15;
				s1_info_16		<=	s1_info_16;
			end
		end
		
		reg	[7:0]ts_din_2_r1;
		reg	[7:0]ts_din_2_r2;
		reg	[7:0]ts_din_2_r3;
		reg	ts_din_en_2_r1,ts_din_en_2_r2,ts_din_en_2_r3,ts_din_en_2_r4;
		reg	[7:0]ts_cnt_2;
		reg	tsmf_flag_2;
		reg	[3:0]tsmf_cnt_2;
		reg	[7:0]tsmf_num_2;
		
		reg	[31:0]s2_info_1;//1-8
		reg	[31:0]s2_info_2;//1-8
		reg	[31:0]s2_info_3;//1-8
		reg	[31:0]s2_info_4;//1-8
		reg	[31:0]s2_info_5;//1-8
		reg	[31:0]s2_info_6;//1-8
		reg	[31:0]s2_info_7;//1-8
		reg	[31:0]s2_info_8;//1-8
		reg	[31:0]s2_info_9;//1-8
		reg	[31:0]s2_info_10;//1-8
		reg	[31:0]s2_info_11;//1-8
		reg	[31:0]s2_info_12;//1-8
		reg	[31:0]s2_info_13;//1-8
		reg	[31:0]s2_info_14;//1-8
		reg	[31:0]s2_info_15;//1-8
		reg	[31:0]s2_info_16;//1-8
		
		reg	 	ch2_wr;
		reg		[8:0]ch2_din;
		wire	ch2_rd;
		wire	[8:0]ch2_dout;
		wire 	ch2_empty;
		
		reg	[1:0]ch2_cstate;
		reg	[1:0]ch2_nstate;
		
		parameter CH2_IDLE=0,
							CH2_HEAD=1,
							CH2_TS	=2;		
		
		
		always@(posedge clk)begin
			if(ts_din_en_2)
				ts_cnt_2	<=	ts_cnt_2+1;
			else
				ts_cnt_2	<=0;
		end
		
		
		always@(posedge clk)begin
			ts_din_2_r1	<=	ts_din_2;
			ts_din_2_r2	<=	ts_din_2_r1;
			ts_din_2_r3	<=	ts_din_2_r2;
			
			ts_din_en_2_r1	<=	ts_din_en_2;
			ts_din_en_2_r2	<=ts_din_en_2_r1;
			ts_din_en_2_r3	<=ts_din_en_2_r2;
			ts_din_en_2_r4	<=ts_din_en_2_r3;
		end
		
		always@(posedge clk)begin
			if(rst)
				tsmf_flag_2	<=0;
			else if(ts_cnt_2==2)
				if(ts_din_2_r2==8'h47 && ts_din_2_r1==8'h1f&& ts_din_2==8'hfe)
					tsmf_flag_2	<=1;
				else
					tsmf_flag_2	<=tsmf_flag_2;
			else if(rnstate==R_CH2_HEAD)
				tsmf_flag_2	<=0;
			else
				tsmf_flag_2	<=tsmf_flag_2;				
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
					if(!ts_din_en_2_r3)
						ch2_nstate	=	CH2_TS;
					else
						ch2_nstate	=	CH2_HEAD;
				CH2_TS:
					if(tsmf_flag_2)
						ch2_nstate	=	CH2_HEAD;
					else	if(!ts_din_en_2_r3&&ts_din_en_2_r4)
						if(tsmf_cnt_2==tsmf_num_2)
							ch2_nstate	=	CH2_IDLE;
						else
							ch2_nstate	=	CH2_TS;
					else
						ch2_nstate	=	CH2_TS;
				default:
					ch2_nstate	=	CH2_IDLE;	
			endcase
		end
		
		always@(posedge clk)begin
			if(ch2_cstate==CH2_IDLE)
				tsmf_cnt_2	<=	0;
			else if(CH2_TS ==ch2_cstate && !ts_din_en_2_r3&& ts_din_en_2_r4)begin
				tsmf_cnt_2	<=	tsmf_cnt_2+1;					
			end
			else
				tsmf_cnt_2	<=	tsmf_cnt_2;
		end
		
		
		
		always@(posedge clk)begin
			if(ch2_cstate==CH2_TS)begin
				if(tsmf_flag_2)begin
					ch2_wr	<=1;
					ch2_din	<=9'h100;
				end
				else if(ts_din_en_2_r3)begin
					ch2_wr	<=1;
					ch2_din	<={1'b0,ts_din_2_r3};					
				end
				else if(tsmf_cnt_2==tsmf_num_2&& !ts_din_en_2_r3&&ts_din_en_2_r4)begin
					ch2_wr	<=1;
					ch2_din	<=9'h100;	
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
			if(CH2_IDLE==ch2_cstate)begin
				tsmf_num_2	<=	0;
				s2_info_1		<=	0; 				
				s2_info_2		<=  0;
				s2_info_3		<=  0;
				s2_info_4		<=  0;
				s2_info_5		<=  0;
				s2_info_6		<=  0;
				s2_info_7		<=  0;
				s2_info_8		<=  0;
				s2_info_9		<=  0;
				s2_info_10	<=  0;
				s2_info_11	<=  0;
				s2_info_12	<=  0;
				s2_info_13	<=  0;
				s2_info_14	<=  0;
				s2_info_15	<=	0;
				s2_info_16	<=	0;
			end
			else if(CH2_HEAD==ch2_cstate)begin
				case(ts_cnt_2)
					7'd12,
					7'd13,
					7'd14,
					7'd15:begin
						s2_info_1	<={s2_info_1[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd16,
					7'd17,
					7'd18,
					7'd19:begin
						s2_info_2	<={s2_info_2[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd20,
					7'd21,
					7'd22,
					7'd23:begin
						s2_info_3	<={s2_info_3[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd24,
					7'd25,
					7'd26,
					7'd27:begin
						s2_info_4	<={s2_info_4[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd28,
					7'd29,
					7'd30,
					7'd31:begin
						s2_info_5	<={s2_info_5[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd32,
					7'd33,
					7'd34,
					7'd35:begin
						s2_info_6	<={s2_info_6[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd36,
					7'd37,
					7'd38,
					7'd39:begin
						s2_info_7	<={s2_info_7[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd40,
					7'd41,
					7'd42,
					7'd43:begin
						s2_info_8	<={s2_info_8[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd44,
					7'd45,
					7'd46,
					7'd47:begin
						s2_info_9	<={s2_info_9[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd48,
					7'd49,
					7'd50,
					7'd51:begin
						s2_info_10	<={s2_info_10[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd52,
					7'd53,
					7'd54,
					7'd55:begin
						s2_info_11	<={s2_info_11[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd56,
					7'd57,
					7'd58,
					7'd59:begin
						s2_info_12	<={s2_info_12[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd60,
					7'd61,
					7'd62,
					7'd63:begin
						s2_info_13	<={s2_info_13[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd64,
					7'd65,
					7'd66,
					7'd67:begin
						s2_info_14	<={s2_info_14[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd68,
					7'd69,
					7'd70,
					7'd71:begin
						s2_info_15	<={s2_info_15[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					7'd72,
					7'd73,
					7'd74,
					7'd75:begin
						s2_info_16	<={s2_info_16[23:0],ts_din_2};
						if(ts_din_2!==0)
							tsmf_num_2	<=tsmf_num_2+1;
						else
							tsmf_num_2	<=tsmf_num_2;
					end
					default:begin				
						tsmf_num_2	<=	tsmf_num_2;
						s2_info_1		<=	s2_info_1; 				
						s2_info_2		<=  s2_info_2;
						s2_info_3		<=  s2_info_3;
						s2_info_4		<=  s2_info_4;
						s2_info_5		<=  s2_info_5;
						s2_info_6		<=  s2_info_6;
						s2_info_7		<=  s2_info_7;
						s2_info_8		<=  s2_info_8;
						s2_info_9		<=  s2_info_9;
						s2_info_10		<=  s2_info_10;
						s2_info_11		<=  s2_info_11;
						s2_info_12		<=  s2_info_12;
						s2_info_13		<=  s2_info_13;
						s2_info_14		<=  s2_info_14;
						s2_info_15		<=	s2_info_15;  
						s2_info_16		<=	s2_info_16;
					end
				endcase	
			end
			else begin
				s2_info_1		<=	s2_info_1; 				
				s2_info_2		<=  s2_info_2;
				s2_info_3		<=  s2_info_3;
				s2_info_4		<=  s2_info_4;
				s2_info_5		<=  s2_info_5;
				s2_info_6		<=  s2_info_6;
				s2_info_7		<=  s2_info_7;
				s2_info_8		<=  s2_info_8;
				s2_info_9		<=  s2_info_9;
				s2_info_10		<=  s2_info_10;
				s2_info_11		<=  s2_info_11;
				s2_info_12		<=  s2_info_12;
				s2_info_13		<=  s2_info_13;
				s2_info_14		<=  s2_info_14;
				s1_info_15		<=	s1_info_15;  
				s2_info_16		<=	s2_info_16;
			end
		end
		
		
		reg	[7:0]ts_din_3_r;
		reg	[7:0]ts_din_3_rr;
		reg	ts_din_en_3_r,ts_din_en_3_rr;
		reg	[7:0]ts_cnt_3;
		reg	tsmf_flag_3;
		reg	[3:0]tsmf_cnt_3;
		
		reg	[31:0]s3_info_1;//1-8
		reg	[31:0]s3_info_2;//1-8
		reg	[31:0]s3_info_3;//1-8
		reg	[31:0]s3_info_4;//1-8
		reg	[31:0]s3_info_5;//1-8
		reg	[31:0]s3_info_6;//1-8
		reg	[31:0]s3_info_7;//1-8
		reg	[31:0]s3_info_8;//1-8
		reg	[31:0]s3_info_9;//1-8
		reg	[31:0]s3_info_10;//1-8
		reg	[31:0]s3_info_11;//1-8
		reg	[31:0]s3_info_12;//1-8
		reg	[31:0]s3_info_13;//1-8
		reg	[31:0]s3_info_14;//1-8
		reg	[31:0]s3_info_15;//1-8
		reg	[31:0]s3_info_16;//1-8
		
		reg	 	ch3_wr;
		reg		[8:0]ch3_din;
		wire	ch3_rd;
		wire	[8:0]ch3_dout;
		wire 	ch3_empty;
		
		reg	[1:0]ch3_cstate;
		reg	[1:0]ch3_nstate;
		
		parameter CH3_IDLE=0,
							CH3_HEAD=1,
							CH3_TS	=2;	
		
		reg	[7:0]ts_din_4_r;
		reg	[7:0]ts_din_4_rr;
		reg	ts_din_en_4_r,ts_din_en_4_rr;
		reg	[7:0]ts_cnt_4;
		reg	tsmf_flag_4;
		reg	[3:0]tsmf_cnt_4;
		
		reg	[31:0]s4_info_1;//1-8
		reg	[31:0]s4_info_2;//1-8
		reg	[31:0]s4_info_3;//1-8
		reg	[31:0]s4_info_4;//1-8
		reg	[31:0]s4_info_5;//1-8
		reg	[31:0]s4_info_6;//1-8
		reg	[31:0]s4_info_7;//1-8
		reg	[31:0]s4_info_8;//1-8
		reg	[31:0]s4_info_9;//1-8
		reg	[31:0]s4_info_10;//1-8
		reg	[31:0]s4_info_11;//1-8
		reg	[31:0]s4_info_12;//1-8
		reg	[31:0]s4_info_13;//1-8
		reg	[31:0]s4_info_14;//1-8
		reg	[31:0]s4_info_15;//1-8
		reg	[31:0]s4_info_16;//1-8
		
		reg	 	ch4_wr;
		reg		[8:0]ch4_din;
		wire	ch4_rd;
		wire	[8:0]ch4_dout;
		wire 	ch4_empty;
		
		reg	[1:0]ch4_cstate;
		reg	[1:0]ch4_nstate;
		
		parameter CH4_IDLE=0,
							CH4_HEAD=1,
							CH4_TS	=2;
		
		
		reg	[7:0]ts_din_5_r;
		reg	[7:0]ts_din_5_rr;
		reg	ts_din_en_5_r,ts_din_en_5_rr;
		reg	[7:0]ts_cnt_5;
		reg	tsmf_flag_5;
		reg	[3:0]tsmf_cnt_5;
		
		reg	[31:0]s5_info_1;//1-8
		reg	[31:0]s5_info_2;//1-8
		reg	[31:0]s5_info_3;//1-8
		reg	[31:0]s5_info_4;//1-8
		reg	[31:0]s5_info_5;//1-8
		reg	[31:0]s5_info_6;//1-8
		reg	[31:0]s5_info_7;//1-8
		reg	[31:0]s5_info_8;//1-8
		reg	[31:0]s5_info_9;//1-8
		reg	[31:0]s5_info_10;//1-8
		reg	[31:0]s5_info_11;//1-8
		reg	[31:0]s5_info_12;//1-8
		reg	[31:0]s5_info_13;//1-8
		reg	[31:0]s5_info_14;//1-8
		reg	[31:0]s5_info_15;//1-8
		reg	[31:0]s5_info_16;//1-8
		
		reg	 	ch5_wr;
		reg		[8:0]ch5_din;
		wire	ch5_rd;
		wire	[8:0]ch5_dout;
		wire 	ch5_empty;
		
		reg	[1:0]ch5_cstate;
		reg	[1:0]ch5_nstate;
		
		parameter CH5_IDLE=0,
							CH5_HEAD=1,
							CH5_TS	=2;
		
		reg	[7:0]ts_din_6_r;
		reg	[7:0]ts_din_6_rr;
		reg	ts_din_en_6_r,ts_din_en_6_rr;
		reg	[7:0]ts_cnt_6;
		reg	tsmf_flag_6;
		reg	[3:0]tsmf_cnt_6;
		
		reg	[31:0]s6_info_1;//1-8
		reg	[31:0]s6_info_2;//1-8
		reg	[31:0]s6_info_3;//1-8
		reg	[31:0]s6_info_4;//1-8
		reg	[31:0]s6_info_5;//1-8
		reg	[31:0]s6_info_6;//1-8
		reg	[31:0]s6_info_7;//1-8
		reg	[31:0]s6_info_8;//1-8
		reg	[31:0]s6_info_9;//1-8
		reg	[31:0]s6_info_10;//1-8
		reg	[31:0]s6_info_11;//1-8
		reg	[31:0]s6_info_12;//1-8
		reg	[31:0]s6_info_13;//1-8
		reg	[31:0]s6_info_14;//1-8
		reg	[31:0]s6_info_15;//1-8
		reg	[31:0]s6_info_16;//1-8
		
		
		reg	 	ch6_wr;
		reg		[8:0]ch6_din;
		wire	ch6_rd;
		wire	[8:0]ch6_dout;
		wire 	ch6_empty;
		
		reg	[1:0]ch6_cstate;
		reg	[1:0]ch6_nstate;
		
		parameter CH6_IDLE=0,
							CH6_HEAD=1,
							CH6_TS	=2;
		
				
		reg	[7:0]ts_din_7_r;
		reg	[7:0]ts_din_7_rr;
		reg	ts_din_en_7_r,ts_din_en_7_rr;
		reg	[7:0]ts_cnt_7;
		reg	tsmf_flag_7;
		reg	[3:0]tsmf_cnt_7;
		
		reg	[31:0]s7_info_1;//1-8
		reg	[31:0]s7_info_2;//1-8
		reg	[31:0]s7_info_3;//1-8
		reg	[31:0]s7_info_4;//1-8
		reg	[31:0]s7_info_5;//1-8
		reg	[31:0]s7_info_6;//1-8
		reg	[31:0]s7_info_7;//1-8
		reg	[31:0]s7_info_8;//1-8
		reg	[31:0]s7_info_9;//1-8
		reg	[31:0]s7_info_10;//1-8
		reg	[31:0]s7_info_11;//1-8
		reg	[31:0]s7_info_12;//1-8
		reg	[31:0]s7_info_13;//1-8
		reg	[31:0]s7_info_14;//1-8
		reg	[31:0]s7_info_15;//1-8
		reg	[31:0]s7_info_16;//1-8
		
		reg	 	ch7_wr;
		reg		[8:0]ch7_din;
		wire	ch7_rd;
		wire	[8:0]ch7_dout;
		wire 	ch7_empty;
		
		reg	[1:0]ch7_cstate;
		reg	[1:0]ch7_nstate;
		
		parameter CH7_IDLE=0,
							CH7_HEAD=1,
							CH7_TS	=2;
		
		reg	[7:0]ts_din_8_r;
		reg	[7:0]ts_din_8_rr;
		reg	ts_din_en_8_r,ts_din_en_8_rr;
		reg	[7:0]ts_cnt_8;
		reg	tsmf_flag_8;
		reg	[3:0]tsmf_cnt_8;
		
		reg	[31:0]s8_info_1;//1-8
		reg	[31:0]s8_info_2;//1-8
		reg	[31:0]s8_info_3;//1-8
		reg	[31:0]s8_info_4;//1-8
		reg	[31:0]s8_info_5;//1-8
		reg	[31:0]s8_info_6;//1-8
		reg	[31:0]s8_info_7;//1-8
		reg	[31:0]s8_info_8;//1-8
		reg	[31:0]s8_info_9;//1-8
		reg	[31:0]s8_info_10;//1-8
		reg	[31:0]s8_info_11;//1-8
		reg	[31:0]s8_info_12;//1-8
		reg	[31:0]s8_info_13;//1-8
		reg	[31:0]s8_info_14;//1-8
		reg	[31:0]s8_info_15;//1-8
		reg	[31:0]s8_info_16;//1-8
		
		reg	 	ch8_wr;
		reg		[8:0]ch8_din;
		wire	ch8_rd;
		wire	[8:0]ch8_dout;
		wire 	ch8_empty;
		
		reg	[1:0]ch8_cstate;
		reg	[1:0]ch8_nstate;
		
		parameter CH8_IDLE=0,
							CH8_HEAD=1,
							CH8_TS	=2;
			
		
		
		
		always@(posedge clk)begin
			if(rst)
				rcstate		<=	R_IDLE;
			else	
				rcstate		<=	rnstate;
		end
		
		
		always@(*)begin
			case(rcstate)
				R_IDLE:
					if(tsmf_flag_1&ch_enable[0])
						rnstate	=	R_CH1_HEAD;
					else if(tsmf_flag_2&ch_enable[1])
						rnstate	=	R_CH2_HEAD;
					else if(tsmf_flag_3&ch_enable[2])
						rnstate	=	R_CH3_HEAD;
					else if(tsmf_flag_4&ch_enable[3])
						rnstate	=	R_CH4_HEAD;
					else if(tsmf_flag_5&ch_enable[4])
						rnstate	=	R_CH5_HEAD;
					else if(tsmf_flag_6&ch_enable[5])
						rnstate	=	R_CH6_HEAD;
					else if(tsmf_flag_7&ch_enable[6])
						rnstate	=	R_CH7_HEAD;
					else if(tsmf_flag_8&ch_enable[7])
						rnstate	=	R_CH8_HEAD;						
					else
						rnstate	=	R_IDLE;
				R_CH1_HEAD:
						if(ch1_dout[8])
							rnstate	=	R_CH1_CK;
						else
							rnstate	=	CH1_HEAD;
				R_CH1_CK:
					if(tsmf_flag_2&ch_enable[1] && tsmf_cnt==tsmf_cnt_2)
						rnstate	=	R_CH2_HEAD;
					else if(tsmf_flag_3&ch_enable[2]&& tsmf_cnt==tsmf_cnt_3)
						rnstate	=	R_CH3_HEAD;
					else if(tsmf_flag_4&ch_enable[3]&& tsmf_cnt==tsmf_cnt_4)
						rnstate	=	R_CH4_HEAD;
					else if(tsmf_flag_5&ch_enable[4]&& tsmf_cnt==tsmf_cnt_5)
						rnstate	=	R_CH5_HEAD;
					else if(tsmf_flag_6&ch_enable[5]&& tsmf_cnt==tsmf_cnt_6)
						rnstate	=	R_CH6_HEAD;
					else if(tsmf_flag_7&ch_enable[6]&& tsmf_cnt==tsmf_cnt_7)
						rnstate	=	R_CH7_HEAD;
					else if(tsmf_flag_8&ch_enable[7]&& tsmf_cnt==tsmf_cnt_8)
						rnstate	=	R_CH8_HEAD;						
					else 
						rnstate	=	R_CH1_CK;
				R_CH2_HEAD:
						if(ch2_dout[8])
							rnstate	=	R_CH2_CK;
						else
							rnstate	=	R_CH2_HEAD;
				R_CH2_CK:
					if(tsmf_flag_1&ch_enable[0] && tsmf_cnt==tsmf_cnt_1)
						rnstate	=	R_CH1_HEAD;
					else if(tsmf_flag_3&ch_enable[2]&& tsmf_cnt==tsmf_cnt_3)
						rnstate	=	R_CH3_HEAD;
					else if(tsmf_flag_4&ch_enable[3]&& tsmf_cnt==tsmf_cnt_4)
						rnstate	=	R_CH4_HEAD;
					else if(tsmf_flag_5&ch_enable[4]&& tsmf_cnt==tsmf_cnt_5)
						rnstate	=	R_CH5_HEAD;
					else if(tsmf_flag_6&ch_enable[5]&& tsmf_cnt==tsmf_cnt_6)
						rnstate	=	R_CH6_HEAD;
					else if(tsmf_flag_7&ch_enable[6]&& tsmf_cnt==tsmf_cnt_7)
						rnstate	=	R_CH7_HEAD;
					else if(tsmf_flag_8&ch_enable[7]&& tsmf_cnt==tsmf_cnt_8)
						rnstate	=	R_CH8_HEAD;						
					else
						rnstate	=	R_IDLE;
				default:
					rnstate	=	R_IDLE;
			endcase
		end
		
		
		always@(posedge clk)begin
			if(rnstate==R_CH1_HEAD&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_cnt_1+1;
			else if(rnstate==R_CH2_HEAD&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_cnt_2+1;
			else if(rnstate==R_CH3_HEAD&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_cnt_3+1;
			else if(rnstate==R_CH4_HEAD&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_cnt_4+1;
			else if(rnstate==R_CH5_HEAD&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_cnt_5+1;
			else if(rnstate==R_CH6_HEAD&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_cnt_6+1;
			else if(rnstate==R_CH7_HEAD&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_cnt_7+1;
			else if(rnstate==R_CH8_HEAD&&rcstate==R_IDLE)
				tsmf_cnt	<=tsmf_cnt_8+1;
			else
				tsmf_cnt	<=tsmf_cnt;
		end
		
		
		assign ch1_rd=((rnstate==R_CH1_HEAD||rnstate==R_CH1_TS)&&!ch1_empty)?1'b1:1'b0;
		
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
