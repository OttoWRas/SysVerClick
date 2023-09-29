`include "ifc_click.svh"

module click_barrier (
    input rst, go,
    ifc_click in,
    ifc_click out
);

assign out.req = in.req && go;
assign in.ack = out.ack;
assign out.data = in.data;

endmodule