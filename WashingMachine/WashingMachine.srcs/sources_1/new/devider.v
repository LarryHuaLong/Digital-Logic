module devider(input CLK100MHZ,
     output clk
     );
     parameter N = 2000000;//Ä¬ÈÏÆµÂÊ50Hz
     reg [31:0]count = 0;
     reg clk;
     initial count = 0;
     initial clk = 0;
     always @(CLK100MHZ)
        if(count == N)
            begin
                count = 0;
                clk = ~clk;
            end
        else count = count + 1;
endmodule