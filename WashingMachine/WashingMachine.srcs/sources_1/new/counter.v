`timescale 1ns/1ps
module down_counter(
    input clk,
    input reset,
    input [7:0] data,
    output qd,
    output [7:0]cnt_remain
    );
    parameter [7:0]mod = 8'b00000000;
    reg [7:0]cnt;
    assign qd = !cnt;
    assign cnt_remain = cnt + mod;
    initial cnt = data;
    always @( negedge clk)
            if (!reset)
                cnt = data - 1;// �첽�� 0���͵�ƽ��Ч
            else 
                cnt = cnt - 1; // ��������
endmodule




