module mutex (
    input wire logic i_R1, i_R2,
    output wire logic o_G1, o_G2
);

    wire O1 = !(i_R1 && O2);
    wire O2 = !(i_R2 && O1);

    assign o_G1 = O2 && !O1;
    assign o_G2 = O1 && !O2;

endmodule

module rgd_mutex #(
    parameter PHASE_INIT_IN_A = 0,
    parameter PHASE_INIT_IN_B = 0,
    parameter PHASE_INIT_OUT_A = 0,
    parameter PHASE_INIT_OUT_B = 0,
    parameter PHASE_INIT_OUT_C = 0,
    parameter PHASE_INIT_OUT_D = 0
    ) (
    wire logic rst,
    ifc_click inA,
    ifc_click inB,
    ifc_click outA,
    ifc_click outB
);
    // Clock tick
    logic click_a, click_b;

    // Input registers
    logic phase_in_a;
    logic phase_in_b;

    // Output registers
    logic phase_out_a;
    logic phase_out_b;
    logic phase_out_c;
    logic phase_out_d;

    // Input state
    logic a_ready = phase_in_a ^ inA_done;
    logic b_ready = phase_in_b ^ inB_done;

    // Pulse trigger
    logic pulse_a = ((!phase_out_a && inA.req) && phase_in_a) 
    || ((phase_out_a && ! inA.req) &&  phase_in_a);

    logic pulse_b = ((!phase_out_b && inB.req) && phase_in_b) 
    || ((phase_out_b && ! inB.req) &&  phase_in_b);

    // Control path
    assign outA.req = phase_out_a;
    assign outB.req = phase_out_c;
    
    mutex u_M0 (
        a_ready, b_ready, click_a, click_b
    );

    always_ff @(posedge pulse_a, posedge rst)
        if (rst) begin
            phase <= PHASE_INIT;
        end else if (pulse_a) begin
            phase_in_a <= #5 !phase_in_a;
        end
    
    always_ff @(posedge pulse_b, posedge rst)
        if (rst) begin
            phase <= PHASE_INIT;
        end else if (pulse_b) begin
            phase_in_a <= #5 !phase_in_a;
        end

    always_ff @(posedge click_a, posedge rst)
        if (rst) begin
            phase_out_a <= PHASE_INIT_OUT_A;
            phase_out_b <= PHASE_INIT_OUT_B;
        end else if (click_a) begin
            phase_out_a <= #5 !phase_out_a;
        end

    always_ff @(negedge click_a)
        phase_out_b <= #5 !phase_out_b;

    always_ff @(posedge click_b, posedge rst)
        if (rst) begin
            phase_out_c <= PHASE_INIT_OUT_C;
            phase_out_d <= PHASE_INIT_OUT_D;
        end else if (click_B) begin
            phase_out_c <= #5 !phase_out_c;
        end

    always_ff @(negedge click_a)
        phase_out_d <= #5 !phase_out_d;

endmodule