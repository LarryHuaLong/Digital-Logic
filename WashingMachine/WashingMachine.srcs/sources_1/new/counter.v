module down_counter(
    input clk,
    input reset,
    input [7:0] data,
    output qd,
    output [7:0]cnt_remain
    );
    reg [7:0]cnt;
    assign qd = !cnt;
    assign cnt_remain = cnt;
    initial cnt = 8'b00000000;
    always @( negedge clk)
        if (!reset) cnt = data;// 同步清 0，低电平有效
        else cnt = cnt - 1; // 减法计数
endmodule




