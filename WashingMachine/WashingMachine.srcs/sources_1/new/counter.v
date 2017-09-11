module down_counter(
    input clk,reset,
    input [7:0] data,
    output qd
    );
    reg [7:0]cnt;
    assign qd = !cnt;
    initial reset = 0;
    always @( posedge clk)
    begin
        if (!reset) cnt = data; // 同步清 0，低电平有效
        else cnt = cnt - 1; // 减法计数
    end
endmodule