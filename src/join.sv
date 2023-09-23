`include "click_interface.svh"

module click_join #(
    parameter PHASE_INIT = 0
) (
    input rst,
    ifc_click inA,
    ifc_click inB,
    ifc_click_nodata outC
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