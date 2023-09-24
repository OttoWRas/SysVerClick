module click_demux_2 #(
    parameter PHASE_INIT_A = 0,
    parameter PHASE_INIT_B = 0,
    parameter PHASE_INIT_C = 0,
    parameter PHASE_INIT_SEL = 0
) (
    ifc_click.in inA,
    ifc_click.out outB,
    ifc_click.out outC,
    ifc_click_nodata.in sel, // THIS IS TO FORCE SEL_DATA TO ONLY BE A SINGLE BIT
    input sel_data         // AS THIS WOULD BREAK OTHERWISE.
);

reg phase_a, phase_b, phase_c;

assign sel.ack = phase_a;
assign inA.ack = phase_a;

wire click_in = !(outB.ack ^ phase_b) && !(outC.ack ^ phase_c);

always @(posedge click_in, posedge rst)
    begin
        if (rst) begin
            phase_a <= PHASE_INIT_A;
        end else begin
            phase_a <= #5 !phase_a;
        end
    end

wire click_out = (inA.req ^ phase_a) && (sel.req ^ phase_a);

always @(posedge click_out, posedge rst)
    begin
        if (rst) begin
            phase_b <= PHASE_INIT_B;
            phase_c <= PHASE_INIT_C;
        end else begin
            phase_b <= #5  sel_data ^ phase_b;
            phase_c <= #5 !sel_data ^ phase_c;
        end
    end

assign outB.data = inA.data;
assign outC.data = inA.data;

endmodule