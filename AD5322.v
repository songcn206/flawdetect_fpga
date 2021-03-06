//the driver of AD5322
//give the ChannelA_data and ChannelB_data,then put en to "1",
module AD5322(
	input clk,//less than 150MHz
	input rst_n,
	input en,
	input [11:0]ChannelA_data,
	input [11:0]ChannelB_data,
	output sclk,
	output dout,
	output sync_n,
	output ldac_n	
	);

	
	reg [15:0]buffer_A = 0;
	reg [15:0]buffer_B = 0;


	reg [5:0] cnt = 0;
	reg dout_r = 0;
	reg sync_n_r = 0;
	reg ldac_n_r = 0;
	
	//Sclk , clk/16
	reg [3:0]sclk_cnt;
	always @ ( posedge clk , negedge rst_n) begin
		if(!rst_n) begin
			sclk_cnt <= 0;
		end
		else if(cnt>0) begin//output sclk when sync_n is low
			sclk_cnt <= sclk_cnt + 1'b1;
		end
		else 
			sclk_cnt <= 0;		
	end
	assign sclk = (sclk_cnt >= 8) ? 1'b1 : 1'b0;
	
	//output data
	always @ ( posedge clk , negedge rst_n) begin
		if(!rst_n) begin
			buffer_A <= 0;
			buffer_B <= 0;
			cnt <= 0;   
 			dout_r <= 0;  
 			sync_n_r <= 0;
 			ldac_n_r <= 0;
		end
		
		else begin
			if(en && cnt == 0) begin	
				cnt <= 1;
				buffer_A <= {4'b0000,ChannelA_data};
				buffer_B <= {4'b1000,ChannelB_data};
	//buffer_A <= {4'b0000,12'b010011011000};
	//buffer_A <= {4'b0000,12'b000000000000};
	//buffer_B <= {4'b1000,12'd1241};
			end
			
			else if ((cnt>0) && (sclk_cnt==1))	begin
				if(cnt>0 && cnt<=16) begin
					sync_n_r <= 0;
					dout_r <= buffer_A[16-cnt];
				end
				
				else if(cnt>20 && cnt<=36) begin
					sync_n_r <= 0;
					dout_r <= buffer_B[36-cnt];
				end	
				
				else  begin
					sync_n_r <= 1;
					dout_r <= 0;
				end
				
				if (cnt>38 && cnt<=40)
					ldac_n_r <= 0;
				else 
					ldac_n_r <= 1;
					
				if(cnt<=40)
					cnt <= cnt + 1'b1;
				else
					cnt <= 0; 
			end
		end	
	end
	assign dout = dout_r;
	assign sync_n = sync_n_r;
	assign ldac_n = ldac_n_r;

endmodule 
