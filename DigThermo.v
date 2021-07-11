module DU1(
    input					clk,rst,us_clear,   
	 output reg[4:0]   	clk_cnt,
	 output reg[20:0]   	count_1us,
	 output reg				clk_1M
);

//to produce clock with 1us 
always @ (posedge clk or negedge rst) begin
    if (!rst) begin
        clk_cnt <= 5'd0;
        clk_1M  <= 1'b0;
    end 
    else if (clk_cnt < 5'd24) 
        clk_cnt <= clk_cnt + 1'b1;       
    else begin
        clk_cnt <= 5'd0;
        clk_1M  <= ~ clk_1M;
    end 
end

//1us counter
always @ (posedge clk_1M or negedge rst) begin
    if (!rst)
        count_1us <= 21'd0;
    else if (us_clear)
        count_1us <= 21'd0;
    else 
        count_1us <= count_1us + 1'b1;
end 
endmodule

//bcd to 7 segment display
module Seven_segment_decoder(
input [3:0] 			bcdin,
output reg [6:0] 		seven_seg
);

//common cathode
always @(bcdin)
 begin
  case (bcdin)
   4'b0000 : begin seven_seg = 7'b1111110; end
   4'b0001 : begin seven_seg = 7'b0110000; end
   4'b0010 : begin seven_seg = 7'b1101101; end
   4'b0011 : begin seven_seg = 7'b1111001; end
   4'b0100 : begin seven_seg = 7'b0110011; end
   4'b0101 : begin seven_seg = 7'b1011011; end
   4'b0110 : begin seven_seg = 7'b1011111; end
   4'b0111 : begin seven_seg = 7'b1110000; end
   4'b1000 : begin seven_seg = 7'b1111111; end
   4'b1001 : begin seven_seg = 7'b1110011; end
   default : begin seven_seg = 7'b0000000; end
  endcase
 end
 endmodule
 
module bintobcd(
input [7:0] 			bin,
output reg[11:0]   	bcdout	
);
reg [3:0]i;
     always @(bin)
        begin
            bcdout = 0; //initialize bcd to zero.
            for (i = 0; i < 8; i = i+1) //run for 8 iterations
            begin
                bcdout = {bcdout[11:0],bin[7-i]}; //concatenation                    
                //if a hex digit of 'bcd' is more than 4, add 3 to it.  
                if(i < 7 && bcdout[3:0] > 4) 
                    bcdout[3:0] = bcdout[3:0] + 3;
                if(i < 7 && bcdout[7:4] > 4)
                    bcdout[7:4] = bcdout[7:4] + 3;
					 if(i < 7 && bcdout[11:8] > 4)
                    bcdout[11:8] = bcdout[11:8] + 3;
            end
        end     
                
endmodule


module CU1(
    input               clk,rst,clk_1M,                           
	 input[4:0]   			clk_cnt,
	 input[20:0]   		count_1us,
	 inout               dht11,   
    output  reg  [31:0] data_valid,  
	 output  reg         us_clear,TH
); 

//define parameter     
parameter  POWER_ON_NUM     = 1000_000;              
parameter  S_POWER_ON      = 3'd0;       
parameter  S_LOW_20MS      = 3'd1;     
parameter  S_HIGH_20US     = 3'd2;    
parameter  S_LOW_83US      = 3'd3;      
parameter  S_HIGH_87US     = 3'd4;      
parameter  S_SEND_DATA     = 3'd5;      
parameter  S_DELAY         = 3'd6; 


reg[2:0]   ps;        
reg[2:0]   ns;             
reg[5:0]   data_count;                                       
reg[39:0]  data_temp;        


reg		  us_cnt_clr;        
reg        state;        
reg        dht_buffer;        
reg        dht_d0;        
reg        dht_d1;        

               
wire       dht_podge;        //data posedge
wire       dht_nedge;        //data negedge


assign dht11     	 = dht_buffer;
assign dht_podge   = ~dht_d1 & dht_d0; // catch posedge
assign dht_nedge   = dht_d1  & (~dht_d0); // catch negedge


always @ (posedge clk_1M or negedge rst) begin
    if (!rst)
        ps <= S_POWER_ON;
    else 
        ps <= ns;
end 

always @ (posedge clk_1M or negedge rst) begin
    if(!rst) 
	 begin
        ns <= S_POWER_ON;
        dht_buffer <= 1'bz;   
        state      <= 1'b0; 
        us_clear   <= 1'b0;
		  data_temp  <= 40'd0;
        data_count <= 6'd0;

	end 
    else 
	 begin
        case (ps)     
            S_POWER_ON :    //wait
				begin                
             if(count_1us < POWER_ON_NUM)
				 begin
					dht_buffer <= 1'bz; 
               us_clear   <= 1'b0;
				 end
             else 
				 begin            
               ns <= S_LOW_20MS;
					us_clear   <= 1'b1;
				 end
            end
                
            S_LOW_20MS:  // send 20 ms
				begin
             if(count_1us < 20000)
				 begin
              dht_buffer <= 1'b0; 
              us_clear   <= 1'b0;
             end
				 else
				 begin
				  ns   <= S_HIGH_20US;
              dht_buffer <= 1'bz; 
              us_clear   <= 1'b1;
                end    
            end 
               
            S_HIGH_20US:  // Hign 20 us
				begin                      
             if (count_1us < 20)
				 begin
              us_clear    <= 1'b0;
              if(dht_nedge)
				  begin   
					ns <= S_LOW_83US;
               us_clear   <= 1'b1; 
              end
            end
              else                      
                ns <= S_DELAY;
            end 
                
            S_LOW_83US:   
				begin                  
             if(dht_podge)                   
               ns <= S_HIGH_87US;  
            end 
                
            S_HIGH_87US:               // ready to receive data signal
				begin
             if(dht_nedge)
				 begin          
              ns <= S_SEND_DATA; 
              us_clear    <= 1'b1;
             end
             else
				 begin                
               data_count <= 6'd0;
               data_temp  <= 40'd0;
               state      <= 1'b0;
             end
            end 
                  
            S_SEND_DATA:    // have 40 bit
				begin                                
              case(state)
                0: begin               
                   if(dht_podge)
						 begin 
                     state    <= 1'b1;
                     us_clear <= 1'b1;
                   end            
                   else               
                    us_clear  <= 1'b0;
                   end
						 
                1: begin               
                   if(dht_nedge)
						 begin 
                     data_count <= data_count + 1'b1;
                     state    <= 1'b0;
							us_clear <= 1'b1;              
                     if(count_1us < 60)
                       data_temp <= {data_temp[38:0],1'b0}; //0
                     else                
							  data_temp <= {data_temp[38:0],1'b1}; //1
                    end 
                      else                                            //wait for high end
                       us_clear <= 1'b0;
                    end
                endcase
                
                if(data_count == 40)                                      //check data bit
					 begin  
                 ns <= S_DELAY;
                 if(data_temp[7:0] == data_temp[39:32] + data_temp[31:24] + data_temp[23:16] + data_temp[15:8])
                   data_valid <= data_temp[39:8];  
                end
            end 
                
            S_DELAY:                                      // after data received delay 2s
				begin
             if(count_1us < 2000_000)
              us_cnt_clr <= 1'b0;
             else
				 begin                 
              ns <= S_LOW_20MS;              // send signal again
              us_cnt_clr <= 1'b1;
             end
           end
            default :
					ps <= ps;
        endcase
    end 
end

//edge
always @ (posedge clk_1M or negedge rst) begin
    if (!rst) begin
        dht_d0 <= 1'b1;
        dht_d1 <= 1'b1;
    end 
    else begin
        dht_d0 <= dht11;
        dht_d1 <= dht_d0;
    end 
end 

always @(data_valid)
begin
	if ((data_valid[15:8] > 30))
	TH = 1;
	else
	TH=0;
	end

	

endmodule


module DigThermo(
    input               clk,rst,
	 inout               dht11,   
    output [6:0] 			Out1,Out2,Out3,Out4,
	 output 					TH
	 );
	 wire 					clk_1M,us_clear;
	 wire [20:0]   		count_1us;                       
	 wire [4:0]   			clk_cnt;
	 wire [7:0]   			A1,A2,A3,A4;
	 wire [31:0] 		   data_valid;  
	 
	 DU1 u1( .clk(clk),.rst(rst),.us_clear(us_clear),.clk_cnt(clk_cnt),.count_1us(count_1us),.clk_1M(clk_1M));
	 CU1 u2( .clk(clk),.rst(rst),.us_clear(us_clear),.clk_cnt(clk_cnt),.count_1us(count_1us),.clk_1M(clk_1M),.dht11(dht11),.data_valid(data_valid),.TH(TH)) ;                          
	 bintobcd u3( .bin(data_valid[31:24]), .bcdout(A1));
	 bintobcd u5( .bin(data_valid[15:8]), .bcdout(A3));
	 Seven_segment_decoder u7(.bcdin(A1[7:4]),.seven_seg(Out1));
	 Seven_segment_decoder u8(.bcdin(A1[3:0]),.seven_seg(Out2));
	 Seven_segment_decoder u9(.bcdin(A3[7:4]),.seven_seg(Out3));
	 Seven_segment_decoder u10(.bcdin(A3[3:0]),.seven_seg(Out4));
	 
endmodule