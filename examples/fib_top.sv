module Fib_top 
(
    input clk, i_rst, i_ack, i_go,
    output o_req,
    output [15:0] o_RESULT
);

wire rst, ack, go;

Fibonacci #(.DATA_WIDTH(15)) FIB (
    .i_rst(rst), .i_go(go), .i_ack(ack),
    .o_req(o_req),
    .o_data(o_RESULT)
);

Debouncer D0 (
    .i_switch(i_rst), .clk(clk),
    .o_switch(rst)
);

Debouncer D1 (
    .i_switch(i_ack), .clk(clk),
    .o_switch(ack)
);


Debouncer D2 (
    .i_switch(i_go), .clk(clk),
    .o_switch(go)
);

endmodule