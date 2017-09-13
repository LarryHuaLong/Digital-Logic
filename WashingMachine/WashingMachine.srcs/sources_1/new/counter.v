`timescale 1ns/1ps
module down_counter(
    input clk,
    input reset,
    input [7:0] data,
    output qd,
    output [7:0]cnt_remain
    );
    
    reg [7:0]cnt,cnt_ex;
    assign qd = !cnt;
    assign cnt_remain = cnt + 1;
    initial cnt = data;
    always @( negedge clk)
            if (!reset) 
                cnt = data -1;// 异步清 0，低电平有效
            else 
                cnt = cnt - 1; // 减法计数
                
        
endmodule




