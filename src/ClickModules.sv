/* verilator lint_off UNOPTFLAT */

`include "ClickBase.svh"

module click_element #(
    parameter DATA_WIDTH = 7,
    parameter PHASE_INIT = 0
) (
    input rst,
    clickBase in,
    clickBase out
);

reg phase;
reg [DATA_WIDTH:0] data_sig;

assign out.req = phase;
assign in.ack = phase;
assign out.data = data_sig; 

wire #5 click = (!in.req && phase && out.req) || (!out.ack && !phase && in.req);

always @(posedge click, posedge rst) 
begin
    if (rst) begin
        phase <= 0;
        data_sig <= 0;
    end else begin 
        phase <= #5 !phase;
        data_sig <= #5 in.data;
    end
end

endmodule

module click_element_decoupled #(
    parameter DATA_WIDTH = 7,
    parameter DATA_INIT = 0,
    parameter PHASE_INIT_A = 0,
    parameter PHASE_INIT_B = 0
) (
    input rst,
    clickBase in,
    clickBase out
);

reg phase_a, phase_b;
reg [DATA_WIDTH:0] data_sig;

assign out.req = phase_b;
assign in.ack = phase_a;
assign out.data = data_sig; 

wire #5 click = (in.req ^ phase_a) && !(out.ack^ phase_b);

always @(posedge click, posedge rst) 
begin
    if (rst) begin
        phase_a <= PHASE_INIT_A;
        phase_b <= PHASE_INIT_B;
        data_sig <= DATA_INIT;
    end else begin 
        phase_a <= #5 !phase_a;
        phase_b <= #5 !phase_b;
        data_sig <= #5 in.data;
    end
end

endmodule

module delay_module #(
    parameter DELAY_SIZE = 1
) (
    input a,
    output b
);
    localparam [3:0] y_val  = {0,1,0,1,0,1,0,1,2,3,2,3,2,3,
    2,3,4,5,4,5,4,5,4,5,6,7,6,7,6,7};
    wire [DELAY_SIZE : 0] s_connect;
    assign s_connect[0] = a;
    genvar index;
    generate
        for (index = 0; index < DELAY_SIZE; index = index + 1) begin
            wire o;
            (* LOC = $sformatf("SLICE_X0Y%d", y_val[index]), DONT_TOUCH = "true" *) LUT1 #(.INIT(2'b10))  // Specify LUT Contents
            LUT1_inst (
               .I0(s_connect[index]),
               .O(o)   
            );
            assign #1 s_connect[index + 1] = o;
        end
    endgenerate
    assign b = s_connect[DELAY_SIZE]; 
endmodule


