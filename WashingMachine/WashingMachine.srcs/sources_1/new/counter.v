module down_counter(
    input clk,
    input reset,
    input [7:0] data,
    output qd,
    output [7:0]cnt_remain
    );
    parameter mode = 0;
    reg [7:0]cnt,cnt_ex;
    assign qd = !cnt;
    assign cnt_remain = mode ? cnt/60 : cnt;
    initial cnt = data;
    always @( negedge clk)
            if (!reset) cnt <= data - 1;// ͬ���� 0���͵�ƽ��Ч
            else cnt <= cnt - 1; // ��������
        
endmodule




