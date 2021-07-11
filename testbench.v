module testbench;
	reg 			clk, rst_n;
	reg 			dht11;
  	wire[7:0] 		Out1,Out2,Out3,Out4;
	wire 			TH,TL;
    wire [31:0] 	data_valid;

  dht11 dut(.clk(clk), .rst_n(rst_n), .dht11(dht11), 
				.Out1(Out1), .Out2(Out2), .Out3(Out3), .Out4(Out4), 
            .TH(TH), .TL(TL),.data_valid(data_valid));
	
	initial begin 
		clk = 0; 
		$monitor ("time: ", $time, 
                  "clk=%b, rst=%b, dht11=%b, Out1=%b, Out2=%b, Out3=%b, Out4=%b, TH=%b, TL=%b, data_valid=%b\n;", clk, rst_n, dht11, Out1, Out2, Out3, Out4, TH, TL, data_valid);
                  
      $dumpfile("dump.vcd");
		$dumpvars;
		
	end
	
	always #5 clk = ~clk;
	initial begin
			 #10  rst_n=0; dht11=1;
			 #10	rst_n=1; dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10  	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10  dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
			 #10	dht11=1;
			 #10	dht11=0;
      
			 #200 $finish;
	end

endmodule