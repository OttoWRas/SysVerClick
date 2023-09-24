`ifndef CLICK_INTERFACE
`define CLICK_INTERFACE

interface ifc_click #(parameter type T = logic );
    logic req;
    logic ack;
    T data;
    
    modport in (input req, data,
                output ack);
                
    modport out(input ack,
                output req, data);

    modport in_no_data (input req,
                output ack);

    modport out_no_data(input ack,
                output req);

endinterface

`endif //CLICK_BASE