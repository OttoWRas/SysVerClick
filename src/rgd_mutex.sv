module mutex #(
    parameter DEBUG = 0
) (
    input wire logic i_R1, i_R2,
    output wire logic o_G1, o_G2
);
    generate
        if (DEBUG == 1) begin
            semaphore access;
            logic R1, R2, O1, O2;
            
            initial begin
                O1 = 0;
                O2 = 0;
                access = new (1);
                fork
                    t_RG(R1, O1);
                    t_RG(R2, O2);
                join_none
            end
            
            assign R1 = i_R1;
            assign R2 = i_R2;
            assign o_G1 = O1;
            assign o_G2 = O2;

            task automatic t_RG (ref logic R, G);                
                forever begin
                    @(posedge R) begin
                        access.get(1);
                        G = 1;
                    end
                    @(negedge R) begin
                        G = 0;
                        access.put(1);
                    end
                end
            endtask //automatic
            
        end else begin
            wire O1, O2;

            assign O1 = !(i_R1 && O2);
            assign O2 = !(i_R2 && O1);

            assign o_G1 = O2 && !O1;
            assign o_G2 = O1 && !O2;
        end

    endgenerate
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
    
    // Channel A
    input wire logic inA_req,
    output wire logic outA_req,
    input wire logic inA_done,
    
    // Channel B
    input wire logic inB_req,
    output wire logic outB_req,
    input wire logic inB_done
);
    // Clock tick
    (* dont_touch = "yes" *) logic click_a, click_b;

    // Input registers
    (* dont_touch = "yes" *) logic phase_in_a;
    (* dont_touch = "yes" *) logic phase_in_b;

    // Output registers
    (* dont_touch = "yes" *) logic phase_out_a;
    (* dont_touch = "yes" *) logic phase_out_b;
    (* dont_touch = "yes" *) logic phase_out_c;
    (* dont_touch = "yes" *) logic phase_out_d;
    
    logic inA_done, inB_done;

    // Input state
    logic a_ready = phase_in_a ^ inA_done;
    logic b_ready = phase_in_b ^ inB_done;

    // Pulse trigger
    logic pulse_a = ((!phase_out_a && inA_req) && phase_in_a) 
    || ((phase_out_a && ! inA_req) &&  phase_in_a);

    logic pulse_b = ((!phase_out_c && inB_req) && phase_in_b) 
    || ((phase_out_c && ! inB_req) &&  phase_in_b);

    // Control path
    assign outA_req = phase_out_b;
    assign outB_req = phase_out_d;
    
    (* DONT_TOUCH = "yes" *) mutex u_M0 (
        a_ready, b_ready, click_a, click_b
    );

    always_ff @(posedge pulse_a, posedge rst)
        if (rst) begin
            phase_in_a <= PHASE_INIT_IN_A;
        end else if (pulse_a) begin
            phase_in_a <= !phase_in_a;
        end
    
    always_ff @(posedge pulse_b, posedge rst)
        if (rst) begin
            phase_in_b <= PHASE_INIT_IN_B;
        end else if (pulse_b) begin
            phase_in_b <= !phase_in_b;
        end

    always_ff @(posedge click_a, posedge rst)
        if (rst)
            phase_out_b <= PHASE_INIT_OUT_B;
        else
            phase_out_b <= !phase_out_b;

    always_ff @(negedge click_a, posedge rst)
        if (rst)
            phase_out_a <= PHASE_INIT_OUT_A;
        else
            phase_out_a <= !phase_out_a;

    always_ff @(posedge click_b, posedge rst)
        if (rst)
            phase_out_d <= PHASE_INIT_OUT_D;
        else 
            phase_out_d <= !phase_out_d;

    always_ff @(negedge click_b, posedge rst)
        if (rst)
            phase_out_c <= PHASE_INIT_OUT_C;
        else 
            phase_out_c <= !phase_out_c;


endmodule