module click_join_3 #(
    parameter PHASE_INIT = 0
) (
    input rst,
    ifc_click inA,
    ifc_click inB,
    ifc_click inC,
    ifc_click_nodata out
);

reg phase;

assign inA.ack = out.ack;
assign inB.ack = out.ack;
assign inC.ack = out.ack;
assign out.req = phase;

wire #5 click = (inA.req ^ phase) && (inB.req ^ phase) && (inC.req ^ phase); 

always @(posedge click, posedge rst)
begin
    if (rst)
        phase <= PHASE_INIT;
    else
        phase <= #5 !phase;
end

endmodule