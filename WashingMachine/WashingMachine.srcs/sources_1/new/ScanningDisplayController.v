module SDC(
	input CLK100MHZ;
	input [7:0][7:0]data;
	output [7:0]AN;
	output [7:0]CN;
	);
	reg clk,n;
	divider#(1000000) f_100Hz(CLK100MHZ,clk);
	initial n = 0;
	always @(posedge clk)
	begin
		case(n)
			0:begin  AN = 8'b01111111;  CN = data[7];  end
			1:begin  AN = 8'b10111111;  CN = data[6];  end
			2:begin  AN = 8'b11011111;  CN = data[5];  end
			3:begin  AN = 8'b11101111;  CN = data[4];  end
			4:begin  AN = 8'b11110111;  CN = data[3];  end
			5:begin  AN = 8'b11111011;  CN = data[2];  end
			6:begin  AN = 8'b11111101;  CN = data[1];  end
			7:begin  AN = 8'b11111110;  CN = data[0];  end
			default:n = 0;
		endcase
		n = n + 1;
	end
endmodule