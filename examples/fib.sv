`include "ClickBase.svh"

module Fibonacci # (
    parameter DATA_WIDTH = 15
) (
    input i_rst, i_go, i_ack,
    output o_req,
    output [DATA_WIDTH:0] o_data
    );    

clickBase C0(), C1(), C2(), C3(), C4(), C5(),
          C6(), C7(), C8(), C9(), C10();
clickBaseNoData C11();

click_element_decoupled #(
        .DATA_WIDTH (DATA_WIDTH),
        .DATA_INIT (1),
        .PHASE_INIT_A (0),
        .PHASE_INIT_B (0)
    ) L0 (
        .rst(i_rst),
        .in(C0.in),
        .out(C1.out)
    );
    
click_element_decoupled #(
        .DATA_WIDTH (DATA_WIDTH),
        .DATA_INIT (0),
        .PHASE_INIT_A (0),
        .PHASE_INIT_B (1)
    ) L1 (
        .rst(i_rst),
        .in(C1.in),
        .out(C2.out)
    );

click_barrier B0 (
        .rst(i_rst),
        .go(i_go),
        .in(C2.in),
        .out(C3.out)
);

click_fork F0 (
        .rst(i_rst),
        .in(C3.in),
        .outA(C4.out),
        .outB(C5.out)
);


click_element_decoupled #(
        .DATA_WIDTH (DATA_WIDTH),
        .DATA_INIT (1),
        .PHASE_INIT_A (0),
        .PHASE_INIT_B (0)
    ) L2 (
        .rst(i_rst),
        .in(C4.in),
        .out(C6.out)
    );


click_element_decoupled #(
        .DATA_WIDTH (DATA_WIDTH),
        .DATA_INIT (1),
        .PHASE_INIT_A (0),
        .PHASE_INIT_B (1)
    ) L3 (
        .rst(i_rst),
        .in(C6.in),
        .out(C7.out)
    );

click_barrier B1 (
        .rst(i_rst),
        .go(i_go),
        .in(C7.in),
        .out(C8.out)
);

click_fork F1 (
        .rst(i_rst),
        .in(C8.in),
        .outA(C9.out),
        .outB(C10.out)
);

click_join J1 (
        .rst(i_rst),
        .inA(C10.in),
        .inB(C5.in),
        .outC(C11.out)
);

delay_module #(
        .DELAY_SIZE(4)
) D0 (
        .a(C11.req),
        .b(C0.req)
);

    assign C11.ack = C0.ack;
    assign C0.data = C10.data + C5.data; 
    assign C9.ack = i_ack;
    assign o_req = C9.req;
    assign o_data = C9.data;
endmodule