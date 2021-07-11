
module dht11(
    input               clk,   
    input               rst_n,                                   
    input               dht11,   
  	output  reg  [7:0] 	Out1,Out2,Out3,Out4,
    output 	reg 		TH,TL,  
  output reg  [31:0] data_valid
); 

//reg define        
reg[5:0]   data_count;                                       
reg[39:0]  data_temp;        

  reg [3:0] i ;
  reg count_finish;
  

// state machine
always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) 
	 begin
		data_temp  <= 40'd0;
        data_count <= 6'd0;
    end 
    else 
				begin
                  data_count <= data_count + 1'b1;
              case(dht11)
                0: data_temp <= {data_temp[38:0],1'b0}                  ;
                1: data_temp <= {data_temp[38:0],1'b1}; 
              endcase
                
                if(data_count == 40)                                      //check data bit
					 begin
                       count_finish=1;
                   data_valid <= data_temp[39:8];  
                end
            end 
end

  
  always@(data_valid or count_finish)
    begin
      TH=0; TL=0;
    if(count_finish==1)
      begin
      for (i = 0; i < 8; i = i+1)
		begin
          Out1[i] = data_valid[24+i];
          Out2[i] = data_valid[16+i];
          Out3[i] = data_valid[8+i];
          Out4[i] = data_valid[i];
        end
       if ((data_valid[15:8] > 35))
           TH = 1;
       else
            TL = 1;
    end
    end
endmodule