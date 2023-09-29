`include "ifc_click.svh"

module click_merge #(
    parameter PHASE_INIT_A = 0,
    parameter PHASE_INIT_B = 0,
    parameter PHASE_INIT_C = 0
) (
    input rst,
    ifc_click inA,
    ifc_click inB,
    ifc_click outC
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