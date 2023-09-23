`include "click_interface.svh"

module click_mux_2 #(
    parameter PHASE_INIT_A = 0,
    parameter PHASE_INIT_B = 0,
    parameter PHASE_INIT_C = 0,
    parameter PHASE_INIT_SEL = 0
) (
    ifc_click.in inA,
    ifc_click.in inB,
    ifc_click.out outC,
    ifc_click_nodata.in sel, // THIS IS TO FORCE SEL_DATA TO ONLY BE A SINGLE BIT
    input sel_data         // AS THIS WOULD BREAK OTHERWISE.
);

logic phase_a, phase_b, phase_c, phase_sel;
bit click_a, click_b, click_sel;

assign inA.ack = phase_a;
assign inB.ack = phase_b;
assign sel.ack = phase_sel;

assign click_a = inA.req ^ phase_a;
assign click_b = inb.req ^ phase_b;
assign click_sel = sel.req ^ phase_sel;

wire #5 click_in  = !(outC.req ^ outC.ack);
wire #5 click_out = (click_a && click_sel && sel_data) || (click_b && click_sel && !sel_data);


always @(posedge click_in, posedge rst)
begin
    if (rst) begin
        phase_a <= PHASE_INIT_A;
        phase_b <= PHASE_INIT_B;
        phase_sel <= PHASE_INIT_SEL;
    end else begin
        phase_a <= #5 phase_a ^ sel_data;
        phase_b <= #5 phase_b ^ !sel_data;
        phase_sel <= #5 !sel.req;
    end
end

always @(posedge click_out, posedge rst)
begin
    if (rst)
        phase_c <= PHASE_INIT_C;
    else
        phase_c <= #5 !phase_c;
end

assign outC.data = sel_data ? inA.data : inB.data;

endmodule;