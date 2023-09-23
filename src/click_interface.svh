`ifndef CLICK_INTERFACE
`define CLICK_INTERFACE

interface ifc_click #(parameter int DATA_WIDTH = 7);
    logic req;
    logic ack;
    logic [DATA_WIDTH:0] data;
    
    modport in (input req, data,
                output ack);
                
    modport out(input ack,
                output req, data);

endinterface

interface ifc_click_nodata #(parameter int DATA_WIDTH = 7);
    logic req;
    logic ack;
    
    modport in (input req,
                output ack);
                
    modport out(input ack,
                output req);

endinterface

`endif //CLICK_BASE