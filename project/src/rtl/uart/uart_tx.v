 
// *******************************************************************************************************
// ** 作者 ： 孤独的单刀                                                   			
// ** 邮箱 ： zachary_wu93@163.com
// ** 博客 ： https://blog.csdn.net/wuzhikaidetb 
// ** 日期 ： 2022/07/31	
// ** 功能 ： 1、基于FPGA的串口发送驱动模块；
//			  2、可设置波特率BPS、主时钟CLK_FRE；
//			  3、起始位1bit，数据位8bit，停止位1bit，无奇偶校验；                                           									                                                                          			
//			  4、每发送1个字节后拉高uart_tx_done一个周期，可用于后续发送多字节模块。                                           									                                                                          			
// *******************************************************************************************************	
 
module uart_tx
#(
	parameter	integer	BPS		= 921600	,	//发送波特率
	parameter 	integer	CLK_FRE	= 60_000_000	//主时钟频率
)
(
//系统接口
	input 			sys_clk			,			//系统时钟
	input 			sys_rst_n		,			//系统复位，低电平有效
//用户接口	
	input	[7:0] 	uart_tx_data	,			//需要通过UART发送的数据，在uart_tx_en为高电平时有效
	input			uart_tx_en		,			//发送有效，当其为高电平时，代表此时需要发送的数据有效
//UART发送	
	output	reg		uart_tx_done	,			//成功发送1BYTE数据后拉高一个周期
	output 	reg		uart_txd					//UART发送数据线tx
);
 
//param define
localparam	integer	BPS_CNT  = CLK_FRE / BPS;	//根据波特率计算传输每个bit需要计数多个系统时钟
localparam	integer	BITS_NUM = 10			;	//发送格式确定需要发送的bit数，10bit = 1起始位 + 8数据位 + 1停止位
 
//reg define
reg 		tx_state			;				//发送标志信号，拉高代表发送过程正在进行
reg [7:0]  	uart_tx_data_reg	;				//寄存要发送的数据
reg [31:0] 	clk_cnt				;				//计数器，用于计数发送一个bit数据所需要的时钟数
reg [3:0]  	bit_cnt				;				//bit计数器，标志当前发送了多少个bit
 
 
//当发送使能信号到达时,寄存待发送的数据以免后续变化、丢失
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		uart_tx_data_reg <=8'd0;
	else if(uart_tx_en)							//要发送有效的数据
		uart_tx_data_reg <= uart_tx_data;		//寄存需要发送的数据			
	else 
		uart_tx_data_reg <= uart_tx_data_reg;
end		
 
//当发送使能信号到达时,进入发送过程
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		tx_state <=1'b0;	
	else if(uart_tx_en)												
		tx_state <= 1'b1;						//发送信号有效则进入发送过程
	//发送完了最后一个数据则退出发送过程		
	else if((bit_cnt == BITS_NUM - 1'b1) && (clk_cnt == BPS_CNT - 1'b1))		
		tx_state <= 1'b0;                                          		
	else 
		tx_state <= tx_state;	
end
 
//发送数据完毕后拉高发送完毕信号一个周期，指示一个字节发送完毕
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		uart_tx_done <=1'b0;
	//发送数据完毕后拉高发送完毕信号一个周期 		
	else if((bit_cnt == BITS_NUM - 1'b1) && (clk_cnt == BPS_CNT - 1'b1))	                                         	
		uart_tx_done <=1'b1;										
	else 
		uart_tx_done <=1'b0;
end
 
//进入发送过程后，启动时钟计数器与发送个数bit计数器
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		clk_cnt <= 32'd0;
		bit_cnt <= 4'd0;
	end
	else if(tx_state) begin										//在发送状态
		if(clk_cnt < BPS_CNT - 1'd1)begin						//一个bit数据没有发送完
			clk_cnt <= clk_cnt + 1'b1;							//时钟计数器+1
			bit_cnt <= bit_cnt;									//bit计数器不变
		end					
		else begin												//一个bit数据发送完了	
			clk_cnt <= 32'd0;									//清空时钟计数器，重新开始计时
			bit_cnt <= bit_cnt+1'b1;							//bit计数器+1，表示发送完了一个bit的数据
		end					
	end					
	else begin													//不在发送状态
		clk_cnt <= 32'd0;                   					//清零
		bit_cnt <= 4'd0;                    					//清零
	end
end
 
//根据发送数据计数器来给uart发送端口赋值
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		uart_txd <= 1'b1;										//默认为高状态，空闲状态
	else if(tx_state)                                  			//处于发送状态
		case(bit_cnt)											//数据发送从低位到高位
			4'd0: uart_txd <= 1'b0;								//起始位，拉低
			4'd1: uart_txd <= uart_tx_data_reg[0];     			//发送最低位数据
			4'd2: uart_txd <= uart_tx_data_reg[1];     			//
			4'd3: uart_txd <= uart_tx_data_reg[2];     			//
			4'd4: uart_txd <= uart_tx_data_reg[3];     			//
			4'd5: uart_txd <= uart_tx_data_reg[4];     			//
			4'd6: uart_txd <= uart_tx_data_reg[5];     			//
			4'd7: uart_txd <= uart_tx_data_reg[6];     			//
			4'd8: uart_txd <= uart_tx_data_reg[7];     			//发送最高位数据
			4'd9: uart_txd <= 1'b1;								//终止位，拉高
			default:uart_txd <= 1'b1;			
		endcase			
	else 														//不处于发送状态
		uart_txd <= 1'b1;										//默认为高状态，空闲状态
end
 
endmodule 