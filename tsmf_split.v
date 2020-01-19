`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    17:23:51 08/19/2019
// Design Name:
// Module Name:    tsmf_split
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
module tsmf_split(

	clk,
	rst,

	ts_din,
	ts_din_en,



	freq_con_din,
	freq_con_din_en,

	channel_din,//取IP PORT配置命令的前两字节
	channel_din_en,

//	pcie_clk

	ts_ram_wr,
	ts_ram_waddr,
	ts_ram_wdata,
	ts_ram_valid,
	test_flag,
	ts_ram_clear

    );

	input clk;
	input rst;

	input [31:0]ts_din;
	input	ts_din_en;



	input [7:0]freq_con_din;
	input		freq_con_din_en;

	input	[7:0]channel_din;
	input 	channel_din_en;

//	input pcie_clk;

	output [12:0]ts_ram_waddr;
	output ts_ram_wr;
	output [127:0]ts_ram_wdata;
	output 	test_flag;


	reg [12:0]ts_ram_waddr;
	reg ts_ram_wr;
	reg [127:0]ts_ram_wdata;

	output 	ts_ram_valid;
	reg			ts_ram_valid;

	input 	ts_ram_clear;


	reg[16:0]freq_reg_1;//最高为1 ，启用该通道。
	reg[16:0]freq_reg_2;
	reg[16:0]freq_reg_3;
	reg[16:0]freq_reg_4;
	reg[16:0]freq_reg_5;
	reg[16:0]freq_reg_6;
	reg[16:0]freq_reg_7;
	reg[16:0]freq_reg_8;

	reg[4:0]freq_cnt;

	reg[5:0]wcstate;
	reg[5:0]wnstate;

	reg rattle_1_full;
	reg rattle_2_full;

	parameter IDLE=0,
						TS_RAM_1=1,
						TS_RAM_2=2,
						CH1_CHECK=3,
						CH1_TS_WAIT=4,
						CH1_TS_WRITE=5,
						CH1_TS_CHECK=6,
						CH1_TS_HEADER_VALID=7,
						CH2_CHECK=8,
						CH2_TS_WAIT=9,
						CH2_TS_WRITE=10,
						CH2_TS_CHECK=11,
						CH2_TS_HEADER_VALID=12,
						CH3_CHECK=13,
						CH3_TS_WAIT=14,
						CH3_TS_WRITE=15,
						CH3_TS_CHECK=16,
						CH3_TS_HEADER_VALID=17,
						CH4_CHECK=18,
						CH4_TS_WAIT=19,
						CH4_TS_WRITE=20,
						CH4_TS_CHECK=21,
						CH4_TS_HEADER_VALID=22,
						CH5_CHECK=23,
						CH5_TS_WAIT=24,
						CH5_TS_WRITE=25,
						CH5_TS_CHECK=26,
						CH5_TS_HEADER_VALID=27,
						CH6_CHECK=28,
						CH6_TS_WAIT=29,
						CH6_TS_WRITE=30,
						CH6_TS_CHECK=31,
						CH6_TS_HEADER_VALID=32,
						CH7_CHECK=33,
						CH7_TS_WAIT=34,
						CH7_TS_WRITE=35,
						CH7_TS_CHECK=36,
						CH7_TS_HEADER_VALID=37,
						CH8_CHECK=38,
						CH8_TS_WAIT=39,
						CH8_TS_WRITE=40,
						CH8_TS_CHECK=41,
						CH8_TS_HEADER_VALID=42,
						TS_PCIE_VALID=43;



	reg		ts_din_en_r;


	reg	[15:0]pack_cnt;
	reg	[5:0]ts_cnt;
	parameter TS_NUM=46;
	parameter	TS_HEAD_NUM=23;
	reg [3:0]frame_cnt;
	reg	[3:0]stream_order;




	reg	[31:0]syn_ver_slot;
	reg	[31:0]slot;

	reg	[31:0]stream_info_1;//1-8
	reg	[31:0]stream_info_2;//1-8
	reg	[31:0]stream_info_3;//1-8
	reg	[31:0]stream_info_4;//1-8
	reg	[31:0]stream_info_5;//1-8
	reg	[31:0]stream_info_6;//1-8
	reg	[31:0]stream_info_7;//1-8
	reg	[31:0]stream_info_8;//1-8
	reg	[31:0]stream_info_9;//1-8
	reg	[31:0]stream_info_10;//1-8
	reg	[31:0]stream_info_11;//1-8
	reg	[31:0]stream_info_12;//1-8
	reg	[31:0]stream_info_13;//1-8
	reg	[31:0]stream_info_14;//1-8
	reg	[31:0]stream_info_15;//1-8
	reg	[31:0]stream_info_16;//1-8

	reg	[31:0]stream_type;
	reg	[31:0]carrier_info;

	reg	[31:0]crc_reg;

	wire	out_enable;
	assign out_enable=freq_reg_1[16]|freq_reg_2[16]|freq_reg_3[16]|freq_reg_4[16]
										|freq_reg_5[16]|freq_reg_6[16]|freq_reg_7[16]|freq_reg_8[16];

	reg	ram_wr;
	reg	[14:0]ram_waddr;
	reg	[31:0]ram_wdata;

	reg	[12:0]ram1_raddr;
	wire[127:0]ram1_rdata;
	reg	[12:0]ram2_raddr;
	wire[127:0]ram2_rdata;

	reg	ram_sel;


	reg	channel_din_en_r;


	reg	[3:0]rcstate;
	reg	[3:0]rnstate;

	reg		ts_ram_clear_r1,ts_ram_clear_r2,ts_ram_clear_r3;

	parameter RD_IDLE=0,
						RD_START=1,
						RD_CLEAR_RAM_1=2,
						RD_CLEAR_RAM_2=3,
						RD_TS_RAM_1=4,
						RD_TS_RAM_2=5,
						RD_PCIE_DONE_1=6,
						RD_PCIE_DONE_2=7,
						RD_WAIT_1_1=8,
						RD_WAIT_1_2=9,
						RD_WAIT_1_3=10,
						RD_WAIT_1_4=11,
						RD_WAIT_2_1=12,
						RD_WAIT_2_2=13,
						RD_WAIT_2_3=14,
						RD_WAIT_2_4=15;


	reg	[12:0]rd_cnt;
	parameter	RD_COUNT=8192;

	always@(posedge clk)begin
		channel_din_en_r	<=	channel_din_en;
		if(rst)
			syn_ver_slot	<=0;
		else if(channel_din_en&&!channel_din_en_r)
			syn_ver_slot	<={16'h1a86,5'b0,channel_din,3'b0};
		else	if(!channel_din_en&&channel_din_en_r)
			syn_ver_slot	<={syn_ver_slot[31:4],channel_din[7:5]};
		else
			syn_ver_slot	<=syn_ver_slot;
	end

	always@(posedge clk)begin
		if(rst)
			slot	<=0;
		else if(!channel_din_en&&channel_din_en_r)
			slot	<={channel_din[4:1],28'h0};
		else
			slot	<=slot;
	end

	always@(posedge clk)begin
		stream_type	<=	{17'h0,15'h7fff};
		carrier_info	<={8'h11,8'h08,8'h00,8'h00};
		crc_reg			<=0;
	end

	always@(posedge clk)begin
		if(freq_con_din_en)
			freq_cnt	<=	freq_cnt+1;
		else
			freq_cnt	<=0;
	end

	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_1	<=0;
		else if(freq_cnt==2)
			freq_reg_1	<={freq_reg_1[15:0],freq_con_din[0]};
		else if(freq_cnt==3)
			freq_reg_1	<={freq_reg_1[8:0],freq_con_din};
		else if(freq_cnt==4)
			freq_reg_1	<={freq_reg_1[8:0],freq_con_din};
		else
			freq_reg_1	<=freq_reg_1;
	end


	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_2	<=0;
		else if(freq_cnt==5)
			freq_reg_2	<={freq_reg_2[15:0],freq_con_din[0]};
		else if(freq_cnt==6)
			freq_reg_2	<={freq_reg_2[8:0],freq_con_din};
		else if(freq_cnt==7)
			freq_reg_2	<={freq_reg_2[8:0],freq_con_din};
		else
			freq_reg_2	<=freq_reg_2;
	end

	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_3	<=0;
		else if(freq_cnt==8)
			freq_reg_3	<={freq_reg_3[15:0],freq_con_din[0]};
		else if(freq_cnt==9)
			freq_reg_3	<={freq_reg_3[8:0],freq_con_din};
		else if(freq_cnt==10)
			freq_reg_3	<={freq_reg_3[8:0],freq_con_din};
		else
			freq_reg_3	<=freq_reg_3;
	end

	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_4	<=0;
		else if(freq_cnt==11)
			freq_reg_4	<={freq_reg_4[15:0],freq_con_din[0]};
		else if(freq_cnt==12)
			freq_reg_4	<={freq_reg_4[8:0],freq_con_din};
		else if(freq_cnt==13)
			freq_reg_4	<={freq_reg_4[8:0],freq_con_din};
		else
			freq_reg_4	<=freq_reg_4;
	end

	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_5	<=0;
		else if(freq_cnt==14)
			freq_reg_5	<={freq_reg_5[15:0],freq_con_din[0]};
		else if(freq_cnt==15)
			freq_reg_5	<={freq_reg_5[8:0],freq_con_din};
		else if(freq_cnt==16)
			freq_reg_5	<={freq_reg_5[8:0],freq_con_din};
		else
			freq_reg_5	<=freq_reg_5;
	end

	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_6	<=0;
		else if(freq_cnt==17)
			freq_reg_6	<={freq_reg_6[15:0],freq_con_din[0]};
		else if(freq_cnt==18)
			freq_reg_6	<={freq_reg_6[8:0],freq_con_din};
		else if(freq_cnt==19)
			freq_reg_6	<={freq_reg_6[8:0],freq_con_din};
		else
			freq_reg_6	<=freq_reg_6;
	end
	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_7	<=0;
		else if(freq_cnt==20)
			freq_reg_7	<={freq_reg_7[15:0],freq_con_din[0]};
		else if(freq_cnt==21)
			freq_reg_7	<={freq_reg_7[8:0],freq_con_din};
		else if(freq_cnt==22)
			freq_reg_7	<={freq_reg_7[8:0],freq_con_din};
		else
			freq_reg_7	<=freq_reg_7;
	end
	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_8	<=0;
		else if(freq_cnt==23)
			freq_reg_8	<={freq_reg_8[15:0],freq_con_din[0]};
		else if(freq_cnt==24)
			freq_reg_8	<={freq_reg_8[8:0],freq_con_din};
		else if(freq_cnt==25)
			freq_reg_8	<={freq_reg_8[8:0],freq_con_din};
		else
			freq_reg_8	<=freq_reg_8;
	end



//	always@(posedge clk)begin
//		case(wcstate)
//			IDLE:
//				out_enable	<=0;
//			CH1_TS_WAIT:
//				out_enable	<=1;
//			CH2_TS_WAIT:
//				out_enable	<=1;
//			CH3_TS_WAIT:
//				out_enable	<=1;
//			CH4_TS_WAIT:
//				out_enable	<=1;
//			CH5_TS_WAIT:
//				out_enable	<=1;
//			CH6_TS_WAIT:
//				out_enable	<=1;
//			CH7_TS_WAIT:
//				out_enable	<=1;
//			CH8_TS_WAIT:
//				out_enable	<=1;
//			default:
//				out_enable	<=out_enable;
//		endcase
//	end
//

	always@(posedge clk)begin
		ts_din_en_r	<=ts_din_en;
		if(rst)begin
			rattle_1_full	<=0;
			rattle_2_full	<=0;
		end
		else if((wcstate==CH8_CHECK&&wnstate==IDLE)||(wcstate==CH8_TS_HEADER_VALID&&wnstate==IDLE))begin
			rattle_1_full	<= !ram_sel&out_enable;
			rattle_2_full	<= ram_sel&out_enable;
		end
		else if(rcstate==RD_WAIT_1_2)begin
			rattle_1_full	<= 0;
			rattle_2_full	<= rattle_2_full;
		end
		else if(rcstate==RD_WAIT_2_2)begin
			rattle_1_full	<= rattle_1_full;
			rattle_2_full	<= 0;
		end
		else begin
			rattle_1_full	<= rattle_1_full;
			rattle_2_full	<= rattle_2_full;
		end

	end

	always@(posedge clk)begin
		if(rst)
			wcstate	<=IDLE;
		else
			wcstate	<=wnstate;
	end

	always@(*)begin
		case(wcstate)
			IDLE:begin
				if(!rattle_1_full)
					wnstate	=	TS_RAM_1;
				else if(!rattle_2_full)
					wnstate	=	TS_RAM_2;
				else
					wnstate	=IDLE;
			end
			TS_RAM_1:
				wnstate	= CH1_CHECK;
			TS_RAM_2	:
				wnstate	=	CH1_CHECK;
			CH1_CHECK:
				if(freq_reg_1[16])
				wnstate	=	CH1_TS_WAIT;
				else
					wnstate	=CH2_CHECK;
			CH1_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					wnstate	= CH1_TS_WRITE;
				else
					wnstate	=	CH1_TS_WAIT;
			CH1_TS_WRITE:
				if(ts_cnt==TS_NUM)
					wnstate	=	CH1_TS_CHECK;
				else
					wnstate	=	CH1_TS_WRITE;
			CH1_TS_CHECK:
				if(pack_cnt+1==freq_reg_1[15:0])
					wnstate	=	CH1_TS_HEADER_VALID;
				else
					wnstate	= CH1_TS_WAIT;
			CH1_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					wnstate	= CH2_CHECK;
				else
					wnstate	=	CH1_TS_HEADER_VALID;

			CH2_CHECK:
				if(freq_reg_2[16])
				wnstate	=	CH2_TS_WAIT;
				else
					wnstate	=CH3_CHECK;
			CH2_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					wnstate	= CH2_TS_WRITE;
				else
					wnstate	=	CH2_TS_WAIT;
			CH2_TS_WRITE:
				if(ts_cnt==TS_NUM)
					wnstate	=	CH2_TS_CHECK;
				else
					wnstate	=	CH2_TS_WRITE;
			CH2_TS_CHECK:
				if(pack_cnt+1==freq_reg_2[15:0])
					wnstate	=	CH2_TS_HEADER_VALID;
				else
					wnstate	= CH2_TS_WAIT;
			CH2_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					wnstate	= CH3_CHECK;
				else
					wnstate	=	CH2_TS_HEADER_VALID;


			CH3_CHECK:
				if(freq_reg_3[16])
				wnstate	=	CH3_TS_WAIT;
				else
					wnstate	=CH4_CHECK;
			CH3_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					wnstate	= CH3_TS_WRITE;
				else
					wnstate	=	CH3_TS_WAIT;
			CH3_TS_WRITE:
				if(ts_cnt==TS_NUM)
					wnstate	=	CH3_TS_CHECK;
				else
					wnstate	=	CH3_TS_WRITE;
			CH3_TS_CHECK:
				if(pack_cnt+1==freq_reg_3[15:0])
					wnstate	=	CH3_TS_HEADER_VALID;
				else
					wnstate	= CH3_TS_WAIT;
			CH3_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					wnstate	= CH4_CHECK;
				else
					wnstate	=	CH3_TS_HEADER_VALID;

			CH4_CHECK:
				if(freq_reg_4[16])
				wnstate	=	CH4_TS_WAIT;
				else
					wnstate	=CH5_CHECK;
			CH4_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					wnstate	= CH4_TS_WRITE;
				else
					wnstate	=	CH4_TS_WAIT;
			CH4_TS_WRITE:
				if(ts_cnt==TS_NUM)
					wnstate	=	CH4_TS_CHECK;
				else
					wnstate	=	CH4_TS_WRITE;
			CH4_TS_CHECK:
				if(pack_cnt+1==freq_reg_4[15:0])
					wnstate	=	CH4_TS_HEADER_VALID;
				else
					wnstate	= CH4_TS_WAIT;
			CH4_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					wnstate	= CH5_CHECK;
				else
					wnstate	=	CH4_TS_HEADER_VALID;

			CH5_CHECK:
				if(freq_reg_5[16])
				wnstate	=	CH5_TS_WAIT;
				else
					wnstate	=CH6_CHECK;
			CH5_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					wnstate	= CH5_TS_WRITE;
				else
					wnstate	=	CH5_TS_WAIT;
			CH5_TS_WRITE:
				if(ts_cnt==TS_NUM)
					wnstate	=	CH5_TS_CHECK;
				else
					wnstate	=	CH5_TS_WRITE;
			CH5_TS_CHECK:
				if(pack_cnt+1==freq_reg_5[15:0])
					wnstate	=	CH5_TS_HEADER_VALID;
				else
					wnstate	= CH5_TS_WAIT;
			CH5_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					wnstate	= CH6_CHECK;
				else
					wnstate	=	CH5_TS_HEADER_VALID;


			CH6_CHECK:
				if(freq_reg_6[16])
				wnstate	=	CH6_TS_WAIT;
				else
					wnstate	=CH7_CHECK;
			CH6_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					wnstate	= CH6_TS_WRITE;
				else
					wnstate	=	CH6_TS_WAIT;
			CH6_TS_WRITE:
				if(ts_cnt==TS_NUM)
					wnstate	=	CH6_TS_CHECK;
				else
					wnstate	=	CH6_TS_WRITE;
			CH6_TS_CHECK:
				if(pack_cnt+1==freq_reg_6[15:0])
					wnstate	=	CH6_TS_HEADER_VALID;
				else
					wnstate	= CH6_TS_WAIT;
			CH6_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					wnstate	= CH7_CHECK;
				else
					wnstate	=	CH6_TS_HEADER_VALID;

			CH7_CHECK:
				if(freq_reg_7[16])
				wnstate	=	CH7_TS_WAIT;
				else
					wnstate	=CH8_CHECK;
			CH7_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					wnstate	= CH7_TS_WRITE;
				else
					wnstate	=	CH7_TS_WAIT;
			CH7_TS_WRITE:
				if(ts_cnt==TS_NUM)
					wnstate	=	CH7_TS_CHECK;
				else
					wnstate	=	CH7_TS_WRITE;
			CH7_TS_CHECK:
				if(pack_cnt+1==freq_reg_7[15:0])
					wnstate	=	CH7_TS_HEADER_VALID;
				else
					wnstate	= CH7_TS_WAIT;
			CH7_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					wnstate	= CH8_CHECK;
				else
					wnstate	=	CH7_TS_HEADER_VALID;

			CH8_CHECK:
				if(freq_reg_8[16])
				wnstate	=	CH8_TS_WAIT;
				else
					wnstate	=IDLE;
			CH8_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					wnstate	= CH8_TS_WRITE;
				else
					wnstate	=	CH8_TS_WAIT;
			CH8_TS_WRITE:
				if(ts_cnt==TS_NUM)
					wnstate	=	CH8_TS_CHECK;
				else
					wnstate	=	CH8_TS_WRITE;
			CH8_TS_CHECK:
				if(pack_cnt+1==freq_reg_8[15:0])
					wnstate	=	CH8_TS_HEADER_VALID;
				else
					wnstate	= CH8_TS_WAIT;
			CH8_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					wnstate	= IDLE;
				else
					wnstate	=	CH8_TS_HEADER_VALID;

			default:
				wnstate=IDLE;
		endcase
	end


	always@(posedge clk)begin
		if((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)
		||(wcstate==CH1_TS_HEADER_VALID)||(wcstate==CH2_TS_HEADER_VALID)||(wcstate==CH3_TS_HEADER_VALID)||(wcstate==CH4_TS_HEADER_VALID)
		||(wcstate==CH5_TS_HEADER_VALID)||(wcstate==CH6_TS_HEADER_VALID)||(wcstate==CH7_TS_HEADER_VALID)||(wcstate==CH8_TS_HEADER_VALID))
			ts_cnt	<=ts_cnt+1;
		else
			ts_cnt	<=0;
	end

	always@(posedge clk)begin
		if(ts_din_en&!ts_din_en_r)
			stream_order	<=ts_din[3:0];
		else
			stream_order	<=stream_order;
	end

	always@(posedge clk)begin
		if(rst)
			pack_cnt	<=0;
		else if((wcstate==CH1_TS_CHECK)||(wcstate==CH2_TS_CHECK)||(wcstate==CH3_TS_CHECK)||(wcstate==CH4_TS_CHECK)
		||(wcstate==CH5_TS_CHECK)||(wcstate==CH6_TS_CHECK)||(wcstate==CH7_TS_CHECK)||(wcstate==CH8_TS_CHECK))
			pack_cnt	<=pack_cnt+1;
		else if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))
			pack_cnt	<=0;
		else
			pack_cnt	<=pack_cnt;
	end

	always@(posedge clk)begin
		if(rst)
			frame_cnt	<=0;
		else begin
			case(wcstate)
				CH1_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM &freq_reg_1[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH2_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM &freq_reg_2[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH3_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM&freq_reg_3[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH4_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM&freq_reg_4[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH5_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM &freq_reg_5[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH6_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM &freq_reg_6[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH7_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM&freq_reg_7[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH8_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM&&freq_reg_8[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
			default:
				frame_cnt<=frame_cnt;
			endcase
		end
	end




	always@(posedge clk)begin
		if(wcstate==TS_RAM_1)
			ram_sel	<=0;
		else if(wcstate==TS_RAM_2)
			ram_sel	<=1;
		else
			ram_sel	<=ram_sel;
	end


	always@(posedge clk)begin
		if(wcstate==CH1_CHECK&&wnstate==CH1_TS_WAIT)begin
			ram_waddr	<={3'b000,12'b000000110010};
		end
		else if(wcstate==CH2_CHECK&&wnstate==CH2_TS_WAIT)begin
			ram_waddr	<={3'b001,12'b000000110010};
		end
		else if(wcstate==CH3_CHECK&&wnstate==CH3_TS_WAIT)begin
			ram_waddr	<={3'b010,12'b000000110010};
		end
		else if(wcstate==CH4_CHECK&&wnstate==CH4_TS_WAIT)begin
			ram_waddr	<={3'b011,12'b000000110010};
		end
		else if(wcstate==CH5_CHECK&&wnstate==CH5_TS_WAIT)begin
			ram_waddr	<={3'b100,12'b000000110010};
		end
		else if(wcstate==CH6_CHECK&&wnstate==CH6_TS_WAIT)begin
			ram_waddr	<={3'b101,12'b000000110010};
		end
		else if(wcstate==CH7_CHECK&&wnstate==CH7_TS_WAIT)begin
			ram_waddr	<={3'b110,12'b000000110010};
		end
		else if(wcstate==CH8_CHECK&&wnstate==CH8_TS_WAIT)begin
			ram_waddr	<={3'b111,12'b000000110010};
		end
		else if((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE))begin
			ram_waddr	<=ram_waddr+1;
		end
		else if((wcstate==CH1_TS_HEADER_VALID)||(wcstate==CH2_TS_HEADER_VALID)||(wcstate==CH3_TS_HEADER_VALID)||(wcstate==CH4_TS_HEADER_VALID)
		||(wcstate==CH5_TS_HEADER_VALID)||(wcstate==CH6_TS_HEADER_VALID)||(wcstate==CH7_TS_HEADER_VALID)||(wcstate==CH8_TS_HEADER_VALID))begin
			case(ts_cnt)
				5'd0:begin
				case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000000100};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000000100};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000000100};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000000100};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000000100};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000000100};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000000100};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000000100};
					default:
						ram_waddr	<=0;
				endcase
				end
				5'd1:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000000101};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000000101};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000000101};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000000101};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000000101};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000000101};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000000101};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000000101};
					default:
						ram_waddr	<=0;
				endcase
				5'd2:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000000110};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000000110};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000000110};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000000110};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000000110};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000000110};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000000110};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000000110};
					default:
						ram_waddr	<=0;
				endcase
				5'd3:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000010110};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000010110};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000010110};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000010110};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000010110};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000010110};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000010110};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000010110};
					default:
						ram_waddr	<=0;
				endcase
				5'd4:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000010111};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000010111};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000010111};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000010111};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000010111};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000010111};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000010111};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000010111};
					default:
						ram_waddr	<=0;
				endcase
				5'd5:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000011000};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000011000};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000011000};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000011000};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000011000};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000011000};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000011000};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000011000};
					default:
						ram_waddr	<=0;
				endcase
				5'd6:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000011001};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000011001};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000011001};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000011001};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000011001};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000011001};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000011001};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000011001};
					default:
						ram_waddr	<=0;
				endcase
				5'd7:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000011010};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000011010};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000011010};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000011010};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000011010};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000011010};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000011010};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000011010};
					default:
						ram_waddr	<=0;
				endcase
				5'd8:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000011011};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000011011};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000011011};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000011011};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000011011};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000011011};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000011011};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000011011};
					default:
						ram_waddr	<=0;
				endcase
				5'd9:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000011100};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000011100};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000011100};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000011100};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000011100};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000011100};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000011100};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000011100};
					default:
						ram_waddr	<=0;
				endcase
				5'd10:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000011101};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000011101};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000011101};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000011101};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000011101};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000011101};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000011101};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000011101};
					default:
						ram_waddr	<=0;
				endcase
				5'd11:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000011110};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000011110};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000011110};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000011110};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000011110};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000011110};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000011110};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000011110};
					default:
						ram_waddr	<=0;
				endcase
				5'd12:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000011111};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000011111};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000011111};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000011111};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000011111};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000011111};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000011111};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000011111};
					default:
						ram_waddr	<=0;
				endcase
				5'd13:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000100000};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000100000};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000100000};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000100000};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000100000};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000100000};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000100000};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000100000};
					default:
						ram_waddr	<=0;
				endcase
				5'd14:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000100001};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000100001};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000100001};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000100001};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000100001};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000100001};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000100001};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000100001};
					default:
						ram_waddr	<=0;
				endcase
				5'd15:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000100010};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000100010};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000100010};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000100010};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000100010};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000100010};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000100010};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000100010};
					default:
						ram_waddr	<=0;
				endcase
				5'd16:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000100011};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000100011};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000100011};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000100011};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000100011};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000100011};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000100011};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000100011};
					default:
						ram_waddr	<=0;
				endcase
				5'd17:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000100100};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000100100};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000100100};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000100100};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000100100};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000100100};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000100100};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000100100};
					default:
						ram_waddr	<=0;
				endcase
				5'd18:
				case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000100101};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000100101};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000100101};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000100101};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000100101};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000100101};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000100101};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000100101};
					default:
						ram_waddr	<=0;
				endcase
				5'd19:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000100110};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000100110};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000100110};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000100110};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000100110};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000100110};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000100110};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000100110};
					default:
						ram_waddr	<=0;
				endcase
				5'd20:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000100111};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000100111};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000100111};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000100111};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000100111};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000100111};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000100111};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000100111};
					default:
						ram_waddr	<=0;
				endcase
				5'd21:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000110010};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000110010};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000110010};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000110010};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000110010};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000110010};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000110010};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000110010};
					default:
						ram_waddr	<=0;
				endcase
				5'd22:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000000011};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000000011};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000000011};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000000011};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000000011};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000000011};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000000011};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000000011};
					default:
						ram_waddr	<=0;
				endcase
				5'd23:
					case(wcstate)
					CH1_TS_HEADER_VALID:
						ram_waddr	<={3'b000,12'b000000000010};
					CH2_TS_HEADER_VALID:
						ram_waddr	<={3'b001,12'b000000000010};
					CH3_TS_HEADER_VALID:
						ram_waddr	<={3'b010,12'b000000000010};
					CH4_TS_HEADER_VALID:
						ram_waddr	<={3'b011,12'b000000000010};
					CH5_TS_HEADER_VALID:
						ram_waddr	<={3'b100,12'b000000000010};
					CH6_TS_HEADER_VALID:
						ram_waddr	<={3'b101,12'b000000000010};
					CH7_TS_HEADER_VALID:
						ram_waddr	<={3'b110,12'b000000000010};
					CH8_TS_HEADER_VALID:
						ram_waddr	<={3'b111,12'b000000000010};
					default:
						ram_waddr	<=0;
				endcase
				default:
					ram_waddr	<=ram_waddr;
			endcase
		end
		else if((wcstate==CH8_CHECK&&wnstate==IDLE)||(wcstate==CH8_TS_HEADER_VALID&&wnstate==IDLE))begin
				ram_waddr	<=1;
		end
		else begin
			ram_waddr	<=ram_waddr;
		end
	end

	always@(posedge clk)begin
		if((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE))begin
			ram_wdata	<=ts_din;
			ram_wr		<=ts_din_en;
		end
		else if((wcstate==CH1_TS_HEADER_VALID)||(wcstate==CH2_TS_HEADER_VALID)||(wcstate==CH3_TS_HEADER_VALID)||(wcstate==CH4_TS_HEADER_VALID)
		||(wcstate==CH5_TS_HEADER_VALID)||(wcstate==CH6_TS_HEADER_VALID)||(wcstate==CH7_TS_HEADER_VALID)||(wcstate==CH8_TS_HEADER_VALID))begin
			case(ts_cnt)
				5'd0:begin//ts baotou
					ram_wdata	<={28'h471ffe1,frame_cnt};
					ram_wr		<=1;
				end
				5'd1:begin//syn_ver_slot
					ram_wdata	<=syn_ver_slot;
					ram_wr		<=1;
				end
				5'd2:begin//slot
					ram_wdata	<=slot;
					ram_wr		<=1;
				end
				5'd3:begin
					ram_wdata	<=stream_info_1;
					ram_wr		<=1;
				end
				5'd4:begin
					ram_wdata	<=stream_info_2;
					ram_wr		<=1;
				end
				5'd5:begin
					ram_wdata	<=stream_info_3;
					ram_wr		<=1;
				end
				5'd6:begin
					ram_wdata	<=stream_info_4;
					ram_wr		<=1;
				end
				5'd7:begin
					ram_wdata	<=stream_info_5;
					ram_wr		<=1;
				end
				5'd8:begin
					ram_wdata	<=stream_info_6;
					ram_wr		<=1;
				end
				5'd9:begin
					ram_wdata	<=stream_info_7;
					ram_wr		<=1;
				end
				5'd10:begin//
					ram_wdata	<=stream_info_8;
					ram_wr		<=1;
				end
				5'd11:begin//
					ram_wdata	<=stream_info_9;
					ram_wr		<=1;
				end
				5'd12:begin//
					ram_wdata	<=stream_info_10;
					ram_wr		<=1;
				end
				5'd13:begin
					ram_wdata	<=stream_info_11;
					ram_wr		<=1;
				end
				5'd14:begin
					ram_wdata	<=stream_info_12;
					ram_wr		<=1;
				end
				5'd15:begin
					ram_wdata	<=stream_info_13;
					ram_wr		<=1;
				end
				5'd16:begin
					ram_wdata	<=stream_info_14;
					ram_wr		<=1;
				end
				5'd17:begin
					ram_wdata	<=stream_info_15;
					ram_wr		<=1;
				end
				5'd18:begin
					ram_wdata	<=stream_info_16;
					ram_wr		<=1;
				end
				5'd19:begin
					ram_wdata	<=stream_type;
					ram_wr		<=1;
				end
				5'd20:begin
					ram_wdata	<=carrier_info;
					ram_wr		<=1;
				end
				5'd21:begin
					ram_wdata	<=crc_reg;//crc
					ram_wr		<=1;
				end
				5'd22:begin
					ram_wdata	<=pack_cnt;//帧中TS包的个数
					ram_wr		<=1;
				end
				5'd23:begin
					ram_wdata	<=32'haaaaaaaa;
					ram_wr		<=1;
				end
				default:begin
					ram_wdata	<=0;
					ram_wr		<=0;
				end
			endcase
		end
		else if((wcstate==CH8_CHECK&&wnstate==IDLE)||(wcstate==CH8_TS_HEADER_VALID&&wnstate==IDLE))begin
				ram_wdata	<=32'haaaaaaaa;
				ram_wr		<=out_enable;
		end
		else begin
			ram_wdata	<=0;
			ram_wr		<=0;
		end
	end



	ts_split_ram split_ram_uut_1 (
	  .clka(clk), // input clka
	  .wea(ram_wr&!ram_sel), // input [0 : 0] wea
	  .addra(ram_waddr), // input [14 : 0] addra
	  .dina(ram_wdata), // input [31 : 0] dina
	  .clkb(clk), // input clkb
	  .addrb(ram1_raddr), // input [13 : 0] addrb
	  .doutb(ram1_rdata) // output [63 : 0] doutb
	);


	ts_split_ram split_ram_uut_2 (
	  .clka(clk), // input clka
	  .wea(ram_wr&ram_sel), // input [0 : 0] wea
	  .addra(ram_waddr), // input [14 : 0] addra
	  .dina(ram_wdata), // input [31 : 0] dina
	  .clkb(clk), // input clkb
	  .addrb(ram2_raddr), // input [13 : 0] addrb
	  .doutb(ram2_rdata) // output [63 : 0] doutb
	);




	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_1	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h0
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_1	<={stream_order,stream_info_1[27:0]};
				3'd1:
					stream_info_1	<={stream_info_1[31:28],stream_order,stream_info_1[23:0]};
				3'd2:
					stream_info_1	<={stream_info_1[31:24],stream_order,stream_info_1[19:0]};
				3'd3:
					stream_info_1	<={stream_info_1[31:20],stream_order,stream_info_1[15:0]};
				3'd4:
					stream_info_1	<={stream_info_1[31:16],stream_order,stream_info_1[11:0]};
				3'd5:
					stream_info_1	<={stream_info_1[31:12],stream_order,stream_info_1[7:0]};
				3'd6:
					stream_info_1	<={stream_info_1[31:8],stream_order,stream_info_1[3:0]};
				3'd7:
					stream_info_1	<={stream_info_1[31:4],stream_order};

				default:
					stream_info_1	<=stream_info_1;
			endcase
		end
		else
			stream_info_1	<=	stream_info_1;
	end

	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_2	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h1
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_2	<={stream_order,stream_info_2[27:0]};
				3'd1:
					stream_info_2	<={stream_info_2[31:28],stream_order,stream_info_2[23:0]};
				3'd2:
					stream_info_2	<={stream_info_2[31:24],stream_order,stream_info_2[19:0]};
				3'd3:
					stream_info_2	<={stream_info_2[31:20],stream_order,stream_info_2[15:0]};
				3'd4:
					stream_info_2	<={stream_info_2[31:16],stream_order,stream_info_2[11:0]};
				3'd5:
					stream_info_2	<={stream_info_2[31:12],stream_order,stream_info_2[7:0]};
				3'd6:
					stream_info_2	<={stream_info_2[31:8],stream_order,stream_info_2[3:0]};
				3'd7:
					stream_info_2	<={stream_info_2[31:4],stream_order};

				default:
					stream_info_2	<=stream_info_2;
			endcase
		end
		else
			stream_info_2	<=	stream_info_2;
	end


	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_3	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h2
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_3	<={stream_order,stream_info_3[27:0]};
				3'd1:
					stream_info_3	<={stream_info_3[31:28],stream_order,stream_info_3[23:0]};
				3'd2:
					stream_info_3	<={stream_info_3[31:24],stream_order,stream_info_3[19:0]};
				3'd3:
					stream_info_3	<={stream_info_3[31:20],stream_order,stream_info_3[15:0]};
				3'd4:
					stream_info_3	<={stream_info_3[31:16],stream_order,stream_info_3[11:0]};
				3'd5:
					stream_info_3	<={stream_info_3[31:12],stream_order,stream_info_3[7:0]};
				3'd6:
					stream_info_3	<={stream_info_3[31:8],stream_order,stream_info_3[3:0]};
				3'd7:
					stream_info_3	<={stream_info_3[31:4],stream_order};

				default:
					stream_info_3	<=stream_info_3;
			endcase
		end
		else
			stream_info_3	<=	stream_info_3;
	end


	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_4	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h3
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_4	<={stream_order,stream_info_4[27:0]};
				3'd1:
					stream_info_4	<={stream_info_4[31:28],stream_order,stream_info_4[23:0]};
				3'd2:
					stream_info_4	<={stream_info_4[31:24],stream_order,stream_info_4[19:0]};
				3'd3:
					stream_info_4	<={stream_info_4[31:20],stream_order,stream_info_4[15:0]};
				3'd4:
					stream_info_4	<={stream_info_4[31:16],stream_order,stream_info_4[11:0]};
				3'd5:
					stream_info_4	<={stream_info_4[31:12],stream_order,stream_info_4[7:0]};
				3'd6:
					stream_info_4	<={stream_info_4[31:8],stream_order,stream_info_4[3:0]};
				3'd7:
					stream_info_4	<={stream_info_4[31:4],stream_order};

				default:
					stream_info_4	<=stream_info_4;
			endcase
		end
		else
			stream_info_4	<=	stream_info_4;
	end


	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_5	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h4
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_5	<={stream_order,stream_info_5[27:0]};
				3'd1:
					stream_info_5	<={stream_info_5[31:28],stream_order,stream_info_5[23:0]};
				3'd2:
					stream_info_5	<={stream_info_5[31:24],stream_order,stream_info_5[19:0]};
				3'd3:
					stream_info_5	<={stream_info_5[31:20],stream_order,stream_info_5[15:0]};
				3'd4:
					stream_info_5	<={stream_info_5[31:16],stream_order,stream_info_5[11:0]};
				3'd5:
					stream_info_5	<={stream_info_5[31:12],stream_order,stream_info_5[7:0]};
				3'd6:
					stream_info_5	<={stream_info_5[31:8],stream_order,stream_info_5[3:0]};
				3'd7:
					stream_info_5	<={stream_info_5[31:4],stream_order};

				default:
					stream_info_5	<=stream_info_5;
			endcase
		end
		else
			stream_info_5	<=	stream_info_5;
	end

	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_6	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h5
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_6	<={stream_order,stream_info_6[27:0]};
				3'd1:
					stream_info_6	<={stream_info_6[31:28],stream_order,stream_info_6[23:0]};
				3'd2:
					stream_info_6	<={stream_info_6[31:24],stream_order,stream_info_6[19:0]};
				3'd3:
					stream_info_6	<={stream_info_6[31:20],stream_order,stream_info_6[15:0]};
				3'd4:
					stream_info_6	<={stream_info_6[31:16],stream_order,stream_info_6[11:0]};
				3'd5:
					stream_info_6	<={stream_info_6[31:12],stream_order,stream_info_6[7:0]};
				3'd6:
					stream_info_6	<={stream_info_6[31:8],stream_order,stream_info_6[3:0]};
				3'd7:
					stream_info_6	<={stream_info_6[31:4],stream_order};

				default:
					stream_info_6	<=stream_info_6;
			endcase
		end
		else
			stream_info_6	<=	stream_info_6;
	end


	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_7	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h6
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_7	<={stream_order,stream_info_7[27:0]};
				3'd1:
					stream_info_7	<={stream_info_7[31:28],stream_order,stream_info_7[23:0]};
				3'd2:
					stream_info_7	<={stream_info_7[31:24],stream_order,stream_info_7[19:0]};
				3'd3:
					stream_info_7	<={stream_info_7[31:20],stream_order,stream_info_7[15:0]};
				3'd4:
					stream_info_7	<={stream_info_7[31:16],stream_order,stream_info_7[11:0]};
				3'd5:
					stream_info_7	<={stream_info_7[31:12],stream_order,stream_info_7[7:0]};
				3'd6:
					stream_info_7	<={stream_info_7[31:8],stream_order,stream_info_7[3:0]};
				3'd7:
					stream_info_7	<={stream_info_7[31:4],stream_order};

				default:
					stream_info_7	<=stream_info_7;
			endcase
		end
		else
			stream_info_7	<=	stream_info_7;
	end

	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_8	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h7
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_8	<={stream_order,stream_info_8[27:0]};
				3'd1:
					stream_info_8	<={stream_info_8[31:28],stream_order,stream_info_8[23:0]};
				3'd2:
					stream_info_8	<={stream_info_8[31:24],stream_order,stream_info_8[19:0]};
				3'd3:
					stream_info_8	<={stream_info_8[31:20],stream_order,stream_info_8[15:0]};
				3'd4:
					stream_info_8	<={stream_info_8[31:16],stream_order,stream_info_8[11:0]};
				3'd5:
					stream_info_8	<={stream_info_8[31:12],stream_order,stream_info_8[7:0]};
				3'd6:
					stream_info_8	<={stream_info_8[31:8],stream_order,stream_info_8[3:0]};
				3'd7:
					stream_info_8	<={stream_info_8[31:4],stream_order};

				default:
					stream_info_8	<=stream_info_8;
			endcase
		end
		else
			stream_info_8	<=	stream_info_8;
	end

	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_9	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h8
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_9	<={stream_order,stream_info_9[27:0]};
				3'd1:
					stream_info_9	<={stream_info_9[31:28],stream_order,stream_info_9[23:0]};
				3'd2:
					stream_info_9	<={stream_info_9[31:24],stream_order,stream_info_9[19:0]};
				3'd3:
					stream_info_9	<={stream_info_9[31:20],stream_order,stream_info_9[15:0]};
				3'd4:
					stream_info_9	<={stream_info_9[31:16],stream_order,stream_info_9[11:0]};
				3'd5:
					stream_info_9	<={stream_info_9[31:12],stream_order,stream_info_9[7:0]};
				3'd6:
					stream_info_9	<={stream_info_9[31:8],stream_order,stream_info_9[3:0]};
				3'd7:
					stream_info_9	<={stream_info_9[31:4],stream_order};

				default:
					stream_info_9	<=stream_info_9;
			endcase
		end
		else
			stream_info_9	<=	stream_info_9;
	end

	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_10	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h9
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_10	<={stream_order,stream_info_10[27:0]};
				3'd1:
					stream_info_10	<={stream_info_10[31:28],stream_order,stream_info_10[23:0]};
				3'd2:
					stream_info_10	<={stream_info_10[31:24],stream_order,stream_info_10[19:0]};
				3'd3:
					stream_info_10	<={stream_info_10[31:20],stream_order,stream_info_10[15:0]};
				3'd4:
					stream_info_10	<={stream_info_10[31:16],stream_order,stream_info_10[11:0]};
				3'd5:
					stream_info_10	<={stream_info_10[31:12],stream_order,stream_info_10[7:0]};
				3'd6:
					stream_info_10	<={stream_info_10[31:8],stream_order,stream_info_10[3:0]};
				3'd7:
					stream_info_10	<={stream_info_10[31:4],stream_order};

				default:
					stream_info_10	<=stream_info_10;
			endcase
		end
		else
			stream_info_10	<=	stream_info_10;
	end

	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_11	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'ha
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_11	<={stream_order,stream_info_11[27:0]};
				3'd1:
					stream_info_11	<={stream_info_11[31:28],stream_order,stream_info_11[23:0]};
				3'd2:
					stream_info_11	<={stream_info_11[31:24],stream_order,stream_info_11[19:0]};
				3'd3:
					stream_info_11	<={stream_info_11[31:20],stream_order,stream_info_11[15:0]};
				3'd4:
					stream_info_11	<={stream_info_11[31:16],stream_order,stream_info_11[11:0]};
				3'd5:
					stream_info_11	<={stream_info_11[31:12],stream_order,stream_info_11[7:0]};
				3'd6:
					stream_info_11	<={stream_info_11[31:8],stream_order,stream_info_11[3:0]};
				3'd7:
					stream_info_11	<={stream_info_11[31:4],stream_order};

				default:
					stream_info_11	<=stream_info_11;
			endcase
		end
		else
			stream_info_11	<=	stream_info_11;
	end

	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_12	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'hb
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_12	<={stream_order,stream_info_12[27:0]};
				3'd1:
					stream_info_12	<={stream_info_12[31:28],stream_order,stream_info_12[23:0]};
				3'd2:
					stream_info_12	<={stream_info_12[31:24],stream_order,stream_info_12[19:0]};
				3'd3:
					stream_info_12	<={stream_info_12[31:20],stream_order,stream_info_12[15:0]};
				3'd4:
					stream_info_12	<={stream_info_12[31:16],stream_order,stream_info_12[11:0]};
				3'd5:
					stream_info_12	<={stream_info_12[31:12],stream_order,stream_info_12[7:0]};
				3'd6:
					stream_info_12	<={stream_info_12[31:8],stream_order,stream_info_12[3:0]};
				3'd7:
					stream_info_12	<={stream_info_12[31:4],stream_order};

				default:
					stream_info_12	<=stream_info_12;
			endcase
		end
		else
			stream_info_12	<=	stream_info_12;
	end

	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_13	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'hc
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_13	<={stream_order,stream_info_13[27:0]};
				3'd1:
					stream_info_13	<={stream_info_13[31:28],stream_order,stream_info_13[23:0]};
				3'd2:
					stream_info_13	<={stream_info_13[31:24],stream_order,stream_info_13[19:0]};
				3'd3:
					stream_info_13	<={stream_info_13[31:20],stream_order,stream_info_13[15:0]};
				3'd4:
					stream_info_13	<={stream_info_13[31:16],stream_order,stream_info_13[11:0]};
				3'd5:
					stream_info_13	<={stream_info_13[31:12],stream_order,stream_info_13[7:0]};
				3'd6:
					stream_info_13	<={stream_info_13[31:8],stream_order,stream_info_13[3:0]};
				3'd7:
					stream_info_13	<={stream_info_13[31:4],stream_order};

				default:
					stream_info_13	<=stream_info_13;
			endcase
		end
		else
			stream_info_13	<=	stream_info_13;
	end


	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_14	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'hd
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_14	<={stream_order,stream_info_14[27:0]};
				3'd1:
					stream_info_14	<={stream_info_14[31:28],stream_order,stream_info_14[23:0]};
				3'd2:
					stream_info_14	<={stream_info_14[31:24],stream_order,stream_info_14[19:0]};
				3'd3:
					stream_info_14	<={stream_info_14[31:20],stream_order,stream_info_14[15:0]};
				3'd4:
					stream_info_14	<={stream_info_14[31:16],stream_order,stream_info_14[11:0]};
				3'd5:
					stream_info_14	<={stream_info_14[31:12],stream_order,stream_info_14[7:0]};
				3'd6:
					stream_info_14	<={stream_info_14[31:8],stream_order,stream_info_14[3:0]};
				3'd7:
					stream_info_14	<={stream_info_14[31:4],stream_order};

				default:
					stream_info_14	<=stream_info_14;
			endcase
		end
		else
			stream_info_14	<=	stream_info_14;
	end

	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_15	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'he
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_15	<={stream_order,stream_info_15[27:0]};
				3'd1:
					stream_info_15	<={stream_info_15[31:28],stream_order,stream_info_15[23:0]};
				3'd2:
					stream_info_15	<={stream_info_15[31:24],stream_order,stream_info_15[19:0]};
				3'd3:
					stream_info_15	<={stream_info_15[31:20],stream_order,stream_info_15[15:0]};
				3'd4:
					stream_info_15	<={stream_info_15[31:16],stream_order,stream_info_15[11:0]};
				3'd5:
					stream_info_15	<={stream_info_15[31:12],stream_order,stream_info_15[7:0]};
				3'd6:
					stream_info_15	<={stream_info_15[31:8],stream_order,stream_info_15[3:0]};
				3'd7:
					stream_info_15	<={stream_info_15[31:4],stream_order};

				default:
					stream_info_15	<=stream_info_15;
			endcase
		end
		else
			stream_info_15	<=	stream_info_15;
	end

	always@(posedge clk)begin
		if((wcstate==CH1_CHECK)||(wcstate==CH2_CHECK)||(wcstate==CH3_CHECK)||(wcstate==CH4_CHECK)
		||(wcstate==CH5_CHECK)||(wcstate==CH6_CHECK)||(wcstate==CH7_CHECK)||(wcstate==CH8_CHECK))begin
			stream_info_16	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'hf
		&&((wcstate==CH1_TS_WRITE)||(wcstate==CH2_TS_WRITE)||(wcstate==CH3_TS_WRITE)||(wcstate==CH4_TS_WRITE)
		||(wcstate==CH5_TS_WRITE)||(wcstate==CH6_TS_WRITE)||(wcstate==CH7_TS_WRITE)||(wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_16	<={stream_order,stream_info_16[27:0]};
				3'd1:
					stream_info_16	<={stream_info_16[31:28],stream_order,stream_info_16[23:0]};
				3'd2:
					stream_info_16	<={stream_info_16[31:24],stream_order,stream_info_16[19:0]};
				3'd3:
					stream_info_16	<={stream_info_16[31:20],stream_order,stream_info_16[15:0]};
				3'd4:
					stream_info_16	<={stream_info_16[31:16],stream_order,stream_info_16[11:0]};
				3'd5:
					stream_info_16	<={stream_info_16[31:12],stream_order,stream_info_16[7:0]};
				3'd6:
					stream_info_16	<={stream_info_16[31:8],stream_order,stream_info_16[3:0]};
				3'd7:
					stream_info_16	<={stream_info_16[31:4],stream_order};

				default:
					stream_info_16	<=stream_info_16;
			endcase
		end
		else
			stream_info_16	<=	stream_info_16;
	end



	always@(posedge clk)begin
		if(rst)
			rcstate		<=RD_IDLE;
		else
			rcstate		<=rnstate;
	end

	reg	ts_ram_valid_r;

	always@(posedge clk)begin
		ts_ram_valid_r	<=	ts_ram_valid;
		ts_ram_clear_r1	<=	ts_ram_clear;
		ts_ram_clear_r2	<=	ts_ram_clear_r1;
		ts_ram_clear_r3	<=	ts_ram_clear_r2;
	end

	always@(*)begin
		case(rcstate)
			RD_IDLE:
//				if(ts_ram_clear_r2 & !ts_ram_clear_r3)
//					rnstate	=	RD_START;
//				else
//					rnstate	=	RD_IDLE;
//			RD_START:
			if(rattle_1_full)
					rnstate	=	RD_CLEAR_RAM_1;
//				else if(rattle_2_full)
//					rnstate	=	RD_CLEAR_RAM_2;
				else
					rnstate	=	RD_IDLE;
//					rnstate	=	RD_START;
			RD_CLEAR_RAM_1:
				rnstate	= 	RD_TS_RAM_1;
			RD_TS_RAM_1:
				if(ram1_raddr==13'h1fff	)
					rnstate	=	RD_PCIE_DONE_1;
				else
					rnstate	=	RD_TS_RAM_1;
			RD_PCIE_DONE_1:
				rnstate		= RD_WAIT_1_1;
			RD_WAIT_1_1:
				rnstate		= RD_WAIT_1_2;
			RD_WAIT_1_2:
				rnstate		= RD_WAIT_1_3;
			RD_WAIT_1_3:
				rnstate		= RD_WAIT_1_4;
			RD_WAIT_1_4:
				if(rattle_2_full)
					rnstate	=	RD_CLEAR_RAM_2;
				else
					rnstate	=	RD_WAIT_1_4;
			RD_CLEAR_RAM_2:
				rnstate	=	RD_TS_RAM_2;
			RD_TS_RAM_2:
				if(ram2_raddr==13'h1fff	)
					rnstate	=	RD_PCIE_DONE_2;
				else
					rnstate	=	RD_TS_RAM_2;
			RD_PCIE_DONE_2:
				rnstate		= RD_WAIT_2_1;
			RD_WAIT_2_1:
				rnstate		= RD_WAIT_2_2;
			RD_WAIT_2_2:
				rnstate		= RD_WAIT_2_3;
			RD_WAIT_2_3:
				rnstate		= RD_WAIT_2_4;
			RD_WAIT_2_4:
				rnstate	=	RD_IDLE;
		default:
			rnstate	=	RD_IDLE;
		endcase
	end

	always@(posedge clk)begin
		if(rnstate==RD_CLEAR_RAM_1)
			ram1_raddr	<=1;
		else if(rnstate==RD_TS_RAM_1)
			ram1_raddr	<=ram1_raddr+1;
		else
			ram1_raddr	<=0;
	end

	always@(posedge clk)begin
		if(rnstate==RD_CLEAR_RAM_2)
			ram2_raddr	<=1;
		else if(rnstate==RD_TS_RAM_2)
			ram2_raddr	<=ram2_raddr+1;
		else
			ram2_raddr	<=0;
	end



	always@(posedge clk)begin
		if(rst)begin
			ts_ram_wr	<=0;
			ts_ram_waddr	<=0;
			ts_ram_wdata	<=0;
		end
//		else if(rcstate==RD_IDLE && ts_ram_valid)begin
//		else if(RD_CLEAR_RAM_1==rcstate ||RD_CLEAR_RAM_2==rcstate)begin
//		else if(ts_ram_clear_r2	&!ts_ram_clear_r3)begin
//			ts_ram_wr	<=1;
//			ts_ram_waddr	<=0;
//			ts_ram_wdata	<=0;
//		end
		else if(rcstate==RD_TS_RAM_1)begin
			ts_ram_wr	<=1;
			ts_ram_waddr	<=ts_ram_waddr+1;
			ts_ram_wdata	<={ram1_rdata[103:96],ram1_rdata[111:104],ram1_rdata[119:112],ram1_rdata[127:120],
												ram1_rdata[71:64],ram1_rdata[79:72],ram1_rdata[87:80],ram1_rdata[95:88],
												ram1_rdata[39:32],ram1_rdata[47:40],ram1_rdata[55:48],ram1_rdata[63:56],
												ram1_rdata[7:0],ram1_rdata[15:8],ram1_rdata[23:16],ram1_rdata[31:24]};
		end
		else if(rcstate==RD_PCIE_DONE_1)begin
			ts_ram_wr	<=1;
			ts_ram_waddr	<=ts_ram_waddr+1;
			ts_ram_wdata	<={ram1_rdata[103:96],ram1_rdata[111:104],ram1_rdata[119:112],ram1_rdata[127:120],
												ram1_rdata[71:64],ram1_rdata[79:72],ram1_rdata[87:80],ram1_rdata[95:88],
												ram1_rdata[39:32],ram1_rdata[47:40],ram1_rdata[55:48],ram1_rdata[63:56],
												ram1_rdata[7:0],ram1_rdata[15:8],ram1_rdata[23:16],ram1_rdata[31:24]};
		end
		else if(rcstate==RD_WAIT_1_1)begin
			ts_ram_wr	<=1;
			ts_ram_waddr	<=0;
			ts_ram_wdata	<={ram1_rdata[103:96],ram1_rdata[111:104],ram1_rdata[119:112],ram1_rdata[127:120],
												ram1_rdata[71:64],ram1_rdata[79:72],ram1_rdata[87:80],ram1_rdata[95:88],
												ram1_rdata[39:32],ram1_rdata[47:40],ram1_rdata[55:48],ram1_rdata[63:56],
												ram1_rdata[7:0],ram1_rdata[15:8],ram1_rdata[23:16],ram1_rdata[31:24]};
		end
		else if(rcstate==RD_TS_RAM_2)begin
			ts_ram_wr	<=1;
			ts_ram_waddr	<=ts_ram_waddr+1;
			ts_ram_wdata	<={ram2_rdata[103:96],ram2_rdata[111:104],ram2_rdata[119:112],ram2_rdata[127:120],
												ram2_rdata[71:64],ram2_rdata[79:72],ram2_rdata[87:80],ram2_rdata[95:88],
												ram2_rdata[39:32],ram2_rdata[47:40],ram2_rdata[55:48],ram2_rdata[63:56],
												ram2_rdata[7:0],ram2_rdata[15:8],ram2_rdata[23:16],ram2_rdata[31:24]};
		end
		else if(rcstate==RD_PCIE_DONE_2)begin
			ts_ram_wr	<=1;
			ts_ram_waddr	<=ts_ram_waddr+1;
			ts_ram_wdata	<={ram2_rdata[103:96],ram2_rdata[111:104],ram2_rdata[119:112],ram2_rdata[127:120],
												ram2_rdata[71:64],ram2_rdata[79:72],ram2_rdata[87:80],ram2_rdata[95:88],
												ram2_rdata[39:32],ram2_rdata[47:40],ram2_rdata[55:48],ram2_rdata[63:56],
												ram2_rdata[7:0],ram2_rdata[15:8],ram2_rdata[23:16],ram2_rdata[31:24]};
		end
		else if(rcstate==RD_WAIT_2_1)begin
			ts_ram_wr	<=1;
			ts_ram_waddr	<=0;
			ts_ram_wdata	<={ram2_rdata[103:96],ram2_rdata[111:104],ram2_rdata[119:112],ram2_rdata[127:120],
												ram2_rdata[71:64],ram2_rdata[79:72],ram2_rdata[87:80],ram2_rdata[95:88],
												ram2_rdata[39:32],ram2_rdata[47:40],ram2_rdata[55:48],ram2_rdata[63:56],
												ram2_rdata[7:0],ram2_rdata[15:8],ram2_rdata[23:16],ram2_rdata[31:24]};
		end
		else begin
			ts_ram_wr	<=0;
			ts_ram_waddr	<=0;
			ts_ram_wdata	<=0;
		end
	end

	always@(posedge clk)begin
	if(rst)
		ts_ram_valid	<=0;
	else if(rcstate==RD_WAIT_1_1 || rcstate==RD_WAIT_2_1)
		ts_ram_valid	<=1;
	else
		ts_ram_valid	<=0;
	end

	reg	[3:0]tsmf_cc;
	reg	[3:0]tsmf_cnt;
	wire test_flag;


	always@(posedge clk)begin
		if(rst)
			tsmf_cnt	<=0;
		else if(ts_ram_wr && ts_ram_waddr==1 && ts_ram_wdata[23:0]==24'hfe1f47)
			tsmf_cnt	<=ts_ram_wdata[27:24];
		else
			tsmf_cnt		<=tsmf_cnt;
	end

	always@(posedge clk)begin
		if(rst)
			tsmf_cc	<=0;
		else if(ts_ram_wr && ts_ram_waddr==1 && ts_ram_wdata[23:0]==24'hfe1f47)
			tsmf_cc	<=ts_ram_wdata[27:24]-tsmf_cnt;
		else
			tsmf_cc	<=	tsmf_cc;
	end


	assign			test_flag	=tsmf_cc==1?1'b0:1'b1;


endmodule
