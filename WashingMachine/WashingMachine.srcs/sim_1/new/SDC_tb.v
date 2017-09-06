`timescale 10ns/1ps

module SDC_tb;
    reg CLK100MHZ;
    reg [7:0][7:0]data;
    wire [7:0]AN;
    wire [7:0]CN;
    SDC sdc1(CLK100MHZ,AN,CN);
    initial CLK100MHZ = 0;
    always #5 CLK100MHZ = ~CLK100MHZ;
    initial 
        begin
            data[7] = 8'b1110000;
            data[6] = 8'b1011111;
            data[5] = 8'b1011011;
            data[4] = 8'b0110011;
            data[3] = 8'b1111001;
            data[2] = 8'b1101101;
            data[1] = 8'b0110000;
            data[0] = 8'b1111110;
            
        end
endmodule