`timescale 10ns/1ps

module SDC_tb;
    reg CLK100MHZ;
    reg [31:0]data;
    wire [7:0]AN;
    wire [7:0]CN;
    SDC sdc1(CLK100MHZ,data,AN,CN);
    initial CLK100MHZ = 0;
    always #5 CLK100MHZ = ~CLK100MHZ;
    
    
    assign data = data_b;
    initial data = 32'b0000_0001_0010_0011_0100_0101_0110_0111;
            
        
endmodule