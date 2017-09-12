module down_counter(
    input clk,
    input reset,
    input [7:0] data,
    output qd,
    output [7:0]cnt_remain
    );
    parameter mod = 1;
    reg [7:0]cnt,cnt_ex;
    assign qd = !cnt;
    assign cnt_remain = cnt;
    initial cnt = data;
    initial cnt_ex = cnt;
    always @( negedge clk)
            if (!reset) begin 
                    cnt = data;
                    cnt = data -1;// 异步清 0，低电平有效
                    end
            else begin 
                cnt_ex = cnt;
                cnt = cnt - 1; // 减法计数
                end
        
endmodule




