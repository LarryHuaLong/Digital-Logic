module devider(input CLK100MHZ,
     output clk
     );
     parameter [31:0]N = 1000000;//default frequency
     reg clk;
     reg [31:0]count = 0;
     initial clk = 0;
     initial count = 0;
     always @(posedge CLK100MHZ)
        if(count == N)
            begin
                count = 0;
                clk = ~clk;
            end
        else count = count + 1;
endmodule