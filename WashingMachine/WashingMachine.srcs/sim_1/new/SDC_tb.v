`timescale 10ns/1ps

module SDC_tb;
    reg CLK100MHZ;
    reg [31:0]data1;
    reg [31:0]data2;
    wire [7:0]AN;
    wire [7:0]CN;
    SDC sdc1(CLK100MHZ,data1,data2,AN,CN);
    initial CLK100MHZ = 0;
    always #5 CLK100MHZ = ~CLK100MHZ;
    
    initial data1 = 32'b10011111_00100101_00001101_10011001;
    initial data2 = 32'b01001001_01000001_00011111_00000001;
            
        
endmodule