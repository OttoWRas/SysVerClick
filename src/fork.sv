`include "click_interface.svh"

module click_fork #(
    parameter PHASE_INIT = 0
) (
    input rst,
    ifc_click in,
    ifc_click outA,
    ifc_click outB
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