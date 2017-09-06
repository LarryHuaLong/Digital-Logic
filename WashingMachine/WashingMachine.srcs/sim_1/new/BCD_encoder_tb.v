`timescale 10ns/1ps
module BCD_encoder_tb;
	reg [7:0]DEC_2BIT;
	wire [3:0]BCD_decade;
	wire [3:0]BCD_unit;
	
	BCD_encoder encoder1(DEC_2BIT,BCD_decade,BCD_unit);
	
	initial 
		begin 
			   DEC_2BIT = 8'd09;
			#5 DEC_2BIT = 8'd19;
			#5 DEC_2BIT = 8'd99;
			#5 DEC_2BIT = 8'd90;
			#5 DEC_2BIT = 8'd54;
			#5 DEC_2BIT = 8'd88;
			#5 $finish;
		end
endmodule