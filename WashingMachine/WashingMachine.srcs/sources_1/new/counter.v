module down_counter(
    input clk,
    input reset,
    input [7:0] data,
    output qd
    );
    
    reg [7:0]cnt;
    assign qd = !cnt;
    initial cnt = 0;
    always @( posedge clk)
    begin
        if (!reset) cnt = data; // ͬ���� 0���͵�ƽ��Ч
        else cnt = cnt - 1; // ��������
    end
endmodule