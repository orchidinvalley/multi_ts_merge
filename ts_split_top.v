`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:39:09 08/29/2019 
// Design Name: 
// Module Name:    ts_split_top 
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
module ts_split_top(
	clk,
	rst,
	
	con_din,
	con_din_en,
	
	udp_din,
	udp_din_en,
	
	con_dout,
	con_dout_en,
	
	ts_ram_wr,
	ts_ram_waddr,
	ts_ram_wdata

	
    );
    
    input 	clk;
    input 	rst;
    
    input		[7:0]con_din;
    input		con_din_en;
    
    input 	[7:0]udp_din;
    input		udp_din_en;
    
    output	[7:0]con_dout;
    output	con_dout_en;
    
    reg			[7:0]con_dout;
    reg			con_dout_en;
    
   	output [12:0]ts_ram_waddr;
		output ts_ram_wr;
		output [127:0]ts_ram_wdata;



		wire [7:0] si_get_con;
		wire si_get_con_en;
		wire [7:0]nit_con;
	  wire nit_con_en;
		wire [7:0] freq_con;
		wire freq_con_en;
		wire [7:0] channel_con;
		wire channel_con_en;
		wire [7:0] ip_port_con;
		wire ip_port_con_en;
		wire [7:0] reply_con;
		wire reply_con_en;
		
		wire	[32:0]udp_ip_data;
		wire	udp_ip_data_en;
		
		wire	[31:0]ip_tsmf_data;
		wire	ip_tsmf_data_en;
		
		
		wire	[7:0]si_dout;
		wire	si_dout_en;


	command_treat command_treat_uut (
    .clk(clk), 
    .rst(rst), 
    .con_din(con_din), 
    .con_din_en(con_din_en), 
    .si_get_con(si_get_con), 
    .si_get_con_en(si_get_con_en), 
    .nit_con(nit_con), 
    .nit_con_en(nit_con_en), 
    .freq_con(freq_con), 
    .freq_con_en(freq_con_en), 
    .channel_con(channel_con), 
    .channel_con_en(channel_con_en), 
    .ip_port_con(ip_port_con), 
    .ip_port_con_en(ip_port_con_en), 
    .reply_con(reply_con), 
    .reply_con_en(reply_con_en)
    );


	



	udp_ts_split udp_ts_split_uut (
    .clk(clk), 
    .rst(rst), 
    .udp_din(udp_din), 
    .udp_din_en(udp_din_en), 
    .ts_dout(udp_ip_data), 
    .ts_dout_en(udp_ip_data_en)
    );
    
  si_get si_get_uut (
    .clk(clk), 
    .rst(rst), 
    .ts_din(udp_ip_data), 
    .ts_din_en(udp_ip_data_en), 
    .con_din(si_get_con), 
    .con_din_en(si_get_con_en), 
    .si_dout(si_dout), 
    .si_dout_en(si_dout_en)
    );
    
  ts_ip_rej ts_ip_rej_uut (
    .clk(clk), 
    .rst(rst), 
    .ts_din(udp_ip_data[31:0]), 
    .ts_din_en(udp_ip_data_en), 
    .ts_dout(ip_tsmf_data), 
    .ts_dout_en(ip_tsmf_data_en), 
    .ip_port_con_din(ip_port_con), 
    .ip_port_con_din_en(ip_port_con_en)
    );
    
    
    
   tsmf_split tsmf_split_uut (
    .clk(clk), 
    .rst(rst), 
    .ts_din(ip_tsmf_data), 
    .ts_din_en(ip_tsmf_data_en), 
    .freq_con_din(freq_con), 
    .freq_con_din_en(freq_con_en), 
    .channel_din(channel_con), 
    .channel_din_en(channel_con_en), 
    .ts_ram_wr(ts_ram_wr), 
    .ts_ram_waddr(ts_ram_waddr), 
    .ts_ram_wdata(ts_ram_wdata)
    );
    
    
    always@(posedge clk)begin
    	if(si_dout_en)begin
    		con_dout	<=	si_dout;
    		con_dout_en	<=	si_dout_en;
    	end
    	else begin
    		con_dout	<=	reply_con;
    		con_dout_en	<=	reply_con_en;
    	end
    end
    
  
    

endmodule
