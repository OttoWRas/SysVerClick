/* verilator lint_off UNOPTFLAT */

`include "ClickBase.svh"

module click_fork #(
    parameter PHASE_INIT = 0
) (
    input rst,
    clickBase in,
    clickBase outA,
    clickBase outB
);

reg phase;

assign outA.req = in.req;
assign outA.data = in.data;
assign outB.req = in.req;
assign outB.data = in.data;
assign in.ack = phase;

wire #5 click = (outB.ack && outA.ack && !phase) || (!outA.ack && !outB.ack && phase);

always @(posedge click, posedge rst)
begin
    if (rst)
        phase <= PHASE_INIT;
    else
        phase <= #5 !phase;
end

endmodule

module click_merge #(
    parameter PHASE_INIT_A = 0,
    parameter PHASE_INIT_B = 0,
    parameter PHASE_INIT_C = 0
) (
    input rst,
    clickBase inA,
    clickBase inB,
    clickBase outC
);

reg phase_a, phase_b, phase_c;

wire #5 inA_token = inA.req ^ phase_a;
wire #5 inB_token = inB.req ^ phase_b;
wire #5 outC_bubble = !(inA_token ^ inB_token);
wire #5 click = inA_token || inB_token;

assign #10 outC.data = !(inA_token || inB_token) ? (0) : (inA_token ?  inA.data : inB.data );
assign outC.req = phase_c;
assign inA.ack = phase_a;
assign inB.ack = phase_b;

always @(posedge click, posedge rst)
    begin
        if (rst) begin
            phase_c <= PHASE_INIT_C;
        end else begin
            phase_c <= #5 !phase_c;
        end
    end

always @(posedge outC_bubble, posedge rst)
    begin
        if (rst) begin
            phase_a <= PHASE_INIT_A;
            phase_b <= PHASE_INIT_B;
        end else begin
            phase_a <= #5 !phase_a;
            phase_b <= #5 !phase_b;
        end
    end

endmodule

module click_barrier (
    input rst, go,
    clickBase in,
    clickBase out
);

assign out.req = in.req && go;
assign in.ack = out.ack;
assign out.data = in.data;

endmodule

module click_join #(
    parameter PHASE_INIT = 0
) (
    input rst,
    clickBase inA,
    clickBase inB,
    clickBaseNoData outC
);

reg phase;

assign inA.ack = outC.ack;
assign inB.ack = outC.ack;
assign outC.req = phase;

wire #5 click = (inB.req && inA.req && !phase) || (!inA.req && !inB.req && phase);

always @(posedge click, posedge rst)
begin
    if (rst)
        phase <= PHASE_INIT;
    else
        phase <= #5 !phase;
end

endmodule