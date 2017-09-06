module SDC(
	input CLK100MHZ,
	input [63:0]data,
	output [7:0]AN,
	output [7:0]CN
	);
	reg [7:0]AN;
	reg [7:0]CN;
	wire clk;
	reg [2:0]n;
	devider#(5000) f_100Hz(CLK100MHZ,clk);
	initial 
	   begin
	       AN <= 8'b11111111;
	       CN <= 8'b11111111; 
	       n <= 3'b000;
	   end
	   reg [7:0]temp[7:0] = data[63:0];
	always @(posedge clk)
	begin
		case(n)
			0:begin  AN <= 8'b01111111;  CN <= temp[7]; n <= n + 1; end
			1:begin  AN <= 8'b10111111;  CN <= temp[6]; n <= n + 1; end
			2:begin  AN <= 8'b11011111;  CN <= temp[5]; n <= n + 1; end
			3:begin  AN <= 8'b11101111;  CN <= temp[4]; n <= n + 1; end
			4:begin  AN <= 8'b11110111;  CN <= temp[3]; n <= n + 1; end
			5:begin  AN <= 8'b11111011;  CN <= temp[2]; n <= n + 1; end
			6:begin  AN <= 8'b11111101;  CN <= temp[1]; n <= n + 1; end
			7:begin  AN <= 8'b11111110;  CN <= temp[0]; n <= n + 1; end
		endcase
	end
endmodule