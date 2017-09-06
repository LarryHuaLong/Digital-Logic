`timescale 10ns/1ps

module SDC_tb;
    reg CLK100MHZ;
    reg [63:0]data;
    wire [7:0]AN;
    wire [7:0]CN;
    SDC sdc1(CLK100MHZ,data,AN,CN);
    initial CLK100MHZ = 0;
    always #5 CLK100MHZ = ~CLK100MHZ;
    
    reg [7:0]data_b[7:0];
    assign data = data_b;
    initial 
        begin
            data_b[7] = 8'b11111101;
            data_b[6] = 8'b10011111;
            data_b[5] = 8'b00100101;
            data_b[4] = 8'b00001101;
            data_b[3] = 8'b10011001;
            data_b[2] = 8'b01001001;
            data_b[1] = 8'b01000001;
            data_b[0] = 8'b00011111;
            
        end
endmodule