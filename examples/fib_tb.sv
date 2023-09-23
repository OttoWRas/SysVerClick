module fibonacci_tb;

logic rst, go, ack;
tri [16:0] out_data;

initial begin
    $dumpfile("fibonacci_tb.vcd");
    $dumpvars(0,fibonacci_tb);
    rst = 1;
    go = 0;
    
    #5 rst = 0;
    #20 go = 1;
end

Fibonacci FIB (
    .i_rst(rst), .i_go(go), .o_data(out_data), .i_ack(ack), .o_req(ack)
);

endmodule