`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:45:39 08/19/2019 
// Design Name: 
// Module Name:    ts_ip_rej 
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
module ts_ip_rej(
	clk,
	rst,
	
	ts_din,
	ts_din_en,
	
	ts_dout,
	ts_dout_en,
	
	ip_port_con_din,//»•µÙ√¸¡ÓÕ∑
	ip_port_con_din_en

    );
    input clk;
    input rst;
    input [31:0]ts_din;
    input	ts_din_en;
    output [31:0]ts_dout;
    output ts_dout_en;
    
    reg[31:0]ts_dout;
    reg		ts_dout_en;
    
    input	ip_port_con_din_en;
    input [7:0]ip_port_con_din;
    
    
    //¥Ê¥¢ gbe+ip+port+
    reg[55:0]ip_port_out_cc1;
    reg[55:0]ip_port_out_cc2;
    reg[55:0]ip_port_out_cc3;
    reg[55:0]ip_port_out_cc4;
    reg[55:0]ip_port_out_cc5;
    reg[55:0]ip_port_out_cc6;
    reg[55:0]ip_port_out_cc7;
    reg[55:0]ip_port_out_cc8;
    reg[55:0]ip_port_out_cc9;
    reg[55:0]ip_port_out_cc10;
    reg[55:0]ip_port_out_cc11;
    reg[55:0]ip_port_out_cc12;
    reg[55:0]ip_port_out_cc13;
    reg[55:0]ip_port_out_cc14;
    reg[55:0]ip_port_out_cc15;
    
    reg	[6:0]con_cnt;
    
    reg	[5:0]ts_cnt;
    
    reg[51:0]gbe_ip_port;
    reg [31:0]ts_din_r,ts_din_rr;
    reg	ts_din_en_r,ts_din_en_rr;
    reg	[3:0]out_channel;
    reg			 pass_flag;
    
    always@(posedge clk)begin
    	if(ip_port_con_din_en)
    		con_cnt	<=con_cnt+1;
    	else
    		con_cnt	<=0;
    end
    
    always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt[6:3]==4'b0000)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc1	<={ip_port_out_cc1[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc1	<={ip_port_out_cc1[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc1	<={ip_port_out_cc1[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc1	<={ip_port_out_cc1[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc1	<={ip_port_out_cc1[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc1	<={ip_port_out_cc1[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc1	<={ip_port_out_cc1[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc1	<={ip_port_out_cc1[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc1	<=ip_port_out_cc1;
    			endcase
    		end
    		else
    			ip_port_out_cc1	<=ip_port_out_cc1;
    	end
    	else
    		ip_port_out_cc1	<=ip_port_out_cc1;
    end
    
    always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc2	<=0;
    		else	if(con_cnt[6:3]==4'b0001)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc2	<={ip_port_out_cc2[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc2	<={ip_port_out_cc2[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc2	<={ip_port_out_cc2[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc2	<={ip_port_out_cc2[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc2	<={ip_port_out_cc2[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc2	<={ip_port_out_cc2[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc2	<={ip_port_out_cc2[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc2	<={ip_port_out_cc2[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc2	<=ip_port_out_cc2;
    			endcase
    		end
    		else
    			ip_port_out_cc2	<=ip_port_out_cc2;
    	end
    	else
    		ip_port_out_cc2	<=ip_port_out_cc2;
    end
    
    always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc3	<=0;
    		else	if(con_cnt[6:3]==4'b0010)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc3	<={ip_port_out_cc3[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc3	<={ip_port_out_cc3[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc3	<={ip_port_out_cc3[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc3	<={ip_port_out_cc3[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc3	<={ip_port_out_cc3[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc3	<={ip_port_out_cc3[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc3	<={ip_port_out_cc3[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc3	<={ip_port_out_cc3[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc3	<=ip_port_out_cc3;
    			endcase
    		end
    		else
    			ip_port_out_cc3	<=ip_port_out_cc3;
    	end
    	else
    		ip_port_out_cc3	<=ip_port_out_cc3;
    end
    
    
    always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc4	<=0;
    		else	if(con_cnt[6:3]==4'b0011)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc4	<={ip_port_out_cc4[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc4	<={ip_port_out_cc4[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc4	<={ip_port_out_cc4[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc4	<={ip_port_out_cc4[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc4	<={ip_port_out_cc4[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc4	<={ip_port_out_cc4[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc4	<={ip_port_out_cc4[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc4	<={ip_port_out_cc4[51:0],ip_port_con_din[3:0]};		
    			default:
    				ip_port_out_cc4	<=ip_port_out_cc4;
    			endcase
    		end
    		else
    			ip_port_out_cc4	<=ip_port_out_cc4;
    	end
    	else
    		ip_port_out_cc4	<=ip_port_out_cc4;
    end
    
    
    always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc5	<=0;
    		else	if(con_cnt[6:3]==4'b0100)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc5	<={ip_port_out_cc5[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc5	<={ip_port_out_cc5[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc5	<={ip_port_out_cc5[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc5	<={ip_port_out_cc5[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc5	<={ip_port_out_cc5[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc5	<={ip_port_out_cc5[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc5	<={ip_port_out_cc5[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc5	<={ip_port_out_cc5[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc5	<=ip_port_out_cc5;
    			endcase
    		end
    		else
    			ip_port_out_cc5	<=ip_port_out_cc5;
    	end
    	else
    		ip_port_out_cc5	<=ip_port_out_cc5;
    end
    
    always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc6	<=0;
    		else	if(con_cnt[6:3]==4'b0101)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc6	<={ip_port_out_cc6[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc6	<={ip_port_out_cc6[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc6	<={ip_port_out_cc6[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc6	<={ip_port_out_cc6[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc6	<={ip_port_out_cc6[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc6	<={ip_port_out_cc6[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc6	<={ip_port_out_cc6[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc6	<={ip_port_out_cc6[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc6	<=ip_port_out_cc6;
    			endcase
    		end
    		else
    			ip_port_out_cc6	<=ip_port_out_cc6;
    	end
    	else
    		ip_port_out_cc6	<=ip_port_out_cc6;
    end
    
    always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc7	<=0;
    		else	if(con_cnt[6:3]==4'b0110)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc7	<={ip_port_out_cc7[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc7	<={ip_port_out_cc7[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc7	<={ip_port_out_cc7[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc7	<={ip_port_out_cc7[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc7	<={ip_port_out_cc7[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc7	<={ip_port_out_cc7[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc7	<={ip_port_out_cc7[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc7	<={ip_port_out_cc7[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc7	<=ip_port_out_cc7;
    			endcase
    		end
    		else
    			ip_port_out_cc7	<=ip_port_out_cc7;
    	end
    	else
    		ip_port_out_cc7	<=ip_port_out_cc7;
    end
    
    always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc8	<=0;
    		else	if(con_cnt[6:3]==4'b0111)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc8	<={ip_port_out_cc8[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc8	<={ip_port_out_cc8[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc8	<={ip_port_out_cc8[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc8	<={ip_port_out_cc8[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc8	<={ip_port_out_cc8[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc8	<={ip_port_out_cc8[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc8	<={ip_port_out_cc8[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc8	<={ip_port_out_cc8[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc8	<=ip_port_out_cc8;
    			endcase
    		end
    		else
    			ip_port_out_cc8	<=ip_port_out_cc8;
    	end
    	else
    		ip_port_out_cc8	<=ip_port_out_cc8;
    end

		always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc9	<=0;
    		else	if(con_cnt[6:3]==4'b1000)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc9	<={ip_port_out_cc9[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc9	<={ip_port_out_cc9[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc9	<={ip_port_out_cc9[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc9	<={ip_port_out_cc9[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc9	<={ip_port_out_cc9[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc9	<={ip_port_out_cc9[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc9	<={ip_port_out_cc9[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc9	<={ip_port_out_cc9[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc9	<=ip_port_out_cc9;
    			endcase
    		end
    		else
    			ip_port_out_cc9	<=ip_port_out_cc9;
    	end
    	else
    		ip_port_out_cc9	<=ip_port_out_cc9;
    end


		always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc10	<=0;
    		else	if(con_cnt[6:3]==4'b1001)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc10	<={ip_port_out_cc10[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc10	<={ip_port_out_cc10[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc10	<={ip_port_out_cc10[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc10	<={ip_port_out_cc10[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc10	<={ip_port_out_cc10[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc10	<={ip_port_out_cc10[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc10	<={ip_port_out_cc10[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc10	<={ip_port_out_cc10[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc10	<=ip_port_out_cc10;
    			endcase
    		end
    		else
    			ip_port_out_cc10	<=ip_port_out_cc10;
    	end
    	else
    		ip_port_out_cc10	<=ip_port_out_cc10;
    end
    
    
    always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc11	<=0;
    		else	if(con_cnt[6:3]==4'b1010)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc11	<={ip_port_out_cc11[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc11	<={ip_port_out_cc11[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc11	<={ip_port_out_cc11[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc11	<={ip_port_out_cc11[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc11	<={ip_port_out_cc11[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc11	<={ip_port_out_cc11[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc11	<={ip_port_out_cc11[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc11	<={ip_port_out_cc11[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc11	<=ip_port_out_cc11;
    			endcase
    		end
    		else
    			ip_port_out_cc11	<=ip_port_out_cc11;
    	end
    	else
    		ip_port_out_cc11	<=ip_port_out_cc11;
    end
    
    
    always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc12	<=0;
    		else	if(con_cnt[6:3]==4'b1011)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc12	<={ip_port_out_cc12[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc12	<={ip_port_out_cc12[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc12	<={ip_port_out_cc12[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc12	<={ip_port_out_cc12[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc12	<={ip_port_out_cc12[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc12	<={ip_port_out_cc12[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc12	<={ip_port_out_cc12[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc12	<={ip_port_out_cc12[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc12	<=ip_port_out_cc12;
    			endcase
    		end
    		else
    			ip_port_out_cc12	<=ip_port_out_cc12;
    	end
    	else
    		ip_port_out_cc12	<=ip_port_out_cc12;
    end
    
    always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc13	<=0;
    		else	if(con_cnt[6:3]==4'b1100)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc13	<={ip_port_out_cc13[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc13	<={ip_port_out_cc13[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc13	<={ip_port_out_cc13[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc13	<={ip_port_out_cc13[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc13	<={ip_port_out_cc13[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc13	<={ip_port_out_cc13[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc13	<={ip_port_out_cc13[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc13	<={ip_port_out_cc13[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc13	<=ip_port_out_cc13;
    			endcase
    		end
    		else
    			ip_port_out_cc13	<=ip_port_out_cc13;
    	end
    	else
    		ip_port_out_cc13	<=ip_port_out_cc13;
    end
    
    always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc14	<=0;
    		else	if(con_cnt[6:3]==4'b1101)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc14	<={ip_port_out_cc14[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc14	<={ip_port_out_cc14[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc14	<={ip_port_out_cc14[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc14	<={ip_port_out_cc14[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc14	<={ip_port_out_cc14[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc14	<={ip_port_out_cc14[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc14	<={ip_port_out_cc14[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc14	<={ip_port_out_cc14[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc14	<=ip_port_out_cc14;
    			endcase
    		end
    		else
    			ip_port_out_cc14	<=ip_port_out_cc14;
    	end
    	else
    		ip_port_out_cc14	<=ip_port_out_cc14;
    end

		always@(posedge clk)begin
    	if(ip_port_con_din_en)begin
    		if(con_cnt==0)
    			ip_port_out_cc15	<=0;
    		else	if(con_cnt[6:3]==4'b1110)begin
    			case(con_cnt[2:0])
    				3'd0:
    					ip_port_out_cc15	<={ip_port_out_cc15[51:0],ip_port_con_din[3:0]};
    				3'd1:
    					ip_port_out_cc15	<={ip_port_out_cc15[47:0],ip_port_con_din};	
    				3'd2:
    					ip_port_out_cc15	<={ip_port_out_cc15[47:0],ip_port_con_din};
    				3'd3:
    					ip_port_out_cc15	<={ip_port_out_cc15[47:0],ip_port_con_din};
    				3'd4:
    					ip_port_out_cc15	<={ip_port_out_cc15[47:0],ip_port_con_din};
    				3'd5:
    					ip_port_out_cc15	<={ip_port_out_cc15[47:0],ip_port_con_din};
    				3'd6:
    					ip_port_out_cc15	<={ip_port_out_cc15[47:0],ip_port_con_din};	
    				3'd7:
    					ip_port_out_cc15	<={ip_port_out_cc15[51:0],ip_port_con_din[3:0]};	
    			default:
    				ip_port_out_cc15	<=ip_port_out_cc15;
    			endcase
    		end
    		else
    			ip_port_out_cc15	<=ip_port_out_cc15;
    	end
    	else
    		ip_port_out_cc15	<=ip_port_out_cc15;
    end


		always@(posedge clk)begin
			if(ts_din_en|ts_din_en_r)
				ts_cnt	<=ts_cnt+1;
			else
				ts_cnt	<=0;
		end
		
		always@(posedge clk)begin
			if(ts_din_en)begin
				case(ts_cnt)
					6'd0:
						gbe_ip_port	<={gbe_ip_port[47:0],ts_din[3:0]};
					6'd1:
						gbe_ip_port	<={gbe_ip_port[19:0],ts_din};
					6'd2:
						gbe_ip_port	<={gbe_ip_port[35:0],ts_din[15:0]};	
				default:
					gbe_ip_port	<=gbe_ip_port;
				endcase
			end
			else
				gbe_ip_port	<=0;
		end
		
		always@(posedge clk)begin
			if(ts_cnt==3)begin
				case(gbe_ip_port)
					ip_port_out_cc1[55:4]:begin
						out_channel<=ip_port_out_cc1[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc2[55:4]:begin
						out_channel<=ip_port_out_cc2[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc3[55:4]:begin
						out_channel<=ip_port_out_cc3[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc4[55:4]:begin
						out_channel<=ip_port_out_cc4[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc5[55:4]:begin
						out_channel<=ip_port_out_cc5[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc6[55:4]:begin
						out_channel<=ip_port_out_cc6[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc7[55:4]:begin
						out_channel<=ip_port_out_cc7[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc8[55:4]:begin
						out_channel<=ip_port_out_cc8[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc9[55:4]:begin
						out_channel<=ip_port_out_cc9[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc10[55:4]:begin
						out_channel<=ip_port_out_cc10[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc11[55:4]:begin
						out_channel<=ip_port_out_cc11[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc12[55:4]:begin
						out_channel<=ip_port_out_cc12[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc13[55:4]:begin
						out_channel<=ip_port_out_cc3[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc14[55:4]:begin
						out_channel<=ip_port_out_cc14[3:0];
						pass_flag	<=1;
					end
					ip_port_out_cc15[55:4]:begin
						out_channel<=ip_port_out_cc15[3:0];
						pass_flag	<=1;
					end
					default:begin
						out_channel<=0;
						pass_flag	<=0;
					end
				endcase
			end
			else if(ts_cnt>3)
			begin
				out_channel<=out_channel;
				pass_flag	<=pass_flag;
			end
			else begin
				out_channel<=0;
				pass_flag	<=0;
			end
				
		end
		
		always@(posedge clk)begin
			ts_din_r	<=ts_din;
			ts_din_rr	<=ts_din_r;
			ts_din_en_r	<=ts_din_en;
		end
		
		always@(posedge clk)begin
			if(pass_flag)begin
				if(ts_cnt==4)begin
					ts_dout	<={28'h0,out_channel};
					ts_dout_en	<=1;
				end
				else if(ts_cnt>4)begin
					ts_dout	<=ts_din_rr;
					ts_dout_en	<=1;
				end
				else begin
						ts_dout	<=0;
						ts_dout_en	<=0;
				end
			end
			else begin
				ts_dout	<=0;
				ts_dout_en	<=0;
			end
		end

endmodule
