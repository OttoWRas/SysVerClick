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