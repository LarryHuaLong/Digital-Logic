module down_counter(
    input clk,
    input reset,
    input [7:0] data,
    output qd,
    output [7:0]cnt_remain
    );
    reg [7:0]cnt,cnt_ex;
    assign qd = !cnt;
    assign cnt_remain = cnt_ex;
    initial cnt = 8'b00000000;
    always @( negedge clk)
        begin 
            cnt_ex <= cnt;
            if (!reset) cnt <= data - 1;// ͬ���� 0���͵�ƽ��Ч
            else cnt <= cnt - 1; // ��������
        end
endmodule




