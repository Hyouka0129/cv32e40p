`include "axi/typedef.svh"

`AXI_TYPEDEF_ALL(axi_32,
                logic [31:0]    ,
                logic           ,
                logic [31:0]    ,
                logic [3:0]     ,
                logic           )

module obi_axi_adapter #(
    parameter type axi_req_t    = axi_32_req_t,
    parameter type axi_resp_t   = axi_32_resp_t,
    parameter DATA_WIDTH        = 32,
    parameter ADDR_WIDTH        = 32
)(
    input   logic                       obi_req_i,
    output  logic                       obi_gnt_o,
    output  logic                       obi_rvalid_o,
    input   logic                       obi_we_i,
    input   logic   [DATA_WIDTH/8-1:0]  obi_be_i,
    input   logic   [ADDR_WIDTH-1:0]    obi_addr_i,
    input   logic   [DATA_WIDTH-1:0]    obi_wdata_i,
    output  logic   [DATA_WIDTH-1:0]    obi_rdata_o,
    output  axi_req_t                   axi_req_o,
    input   axi_resp_t                  axi_resp_i
);
    logic [2:0] a_size;
    
    always_comb begin : a_size
        a_size = 3'b010
        case (DATA_WIDTH)
            8:    a_size = 3'b000;
            16:   a_size = 3'b001;
            32:   a_size = 3'b010;
            64:   a_size = 3'b011;
            128:  a_size = 3'b100;
            256:  a_size = 3'b101;
            512:  a_size = 3'b110;
            1024: a_size = 3'b111;
            default: a_size = 3'b010;
        endcase
    end

    logic obi_gnt;

    always_comb begin : obi_gnt
        obi_gnt = 1'b1;
        if(axi_req_o.aw_valid && !axi_resp_i.aw_ready) begin
            obi_gnt = 1'b0;
        end
        if(axi_req_o.w_valid && !axi_resp_i.w_ready) begin
            obi_gnt = 1'b0;
        end
        if(axi_req_o.ar_valid && !axi_resp_i.ar_ready) begin
            obi_gnt = 1'b0;
        end
    end

    assign axi_req_o.aw_valid   = obi_req_i & obi_we_i;
    assign axi_req_o.aw.id      = '0;
    assign axi_req_o.aw.addr    = obi_addr_i;
    assign axi_req_o.aw.len     = '0;
    assign axi_req_o.aw.size    = a_size;
    assign axi_req_o.aw.burst   = 2'b00;
    assign axi_req_o.aw.lock    = 1'b0;
    assign axi_req_o.aw.cache   = 4'b0000;
    assign axi_req_o.aw.prot    = 3'b000;
    assign axi_req_o.aw.qos     = 4'b0000;
    assign axi_req_o.aw.region  = 4'b0000;
    assign axi_req_o.aw.atop    = 3'b000;
    assign axi_req_o.aw.user    = '0;
    
    assign axi_req_o.w_valid    = obi_req_i & obi_we_i;
    assign axi_req_o.w.data     = obi_wdata_i;
    assign axi_req_o.w.strb     = obi_be_i;
    assign axi_req_o.w.last     = axi_req_o.w_valid;
    assign axi_req_o.w.user     = '0;

    assign axi_req_o.b_ready    = 1'b1;

    assign axi_req_o.ar_valid   = obi_req_i & ~obi_we_i;
    assign axi_req_o.ar.id      = '0;
    assign axi_req_o.ar.addr    = obi_addr_i;
    assign axi_req_o.ar.len     = '0;
    assign axi_req_o.ar.size    = a_size;
    assign axi_req_o.ar.burst   = 2'b00;
    assign axi_req_o.ar.lock    = 1'b0;
    assign axi_req_o.ar.cache   = 4'b0000;
    assign axi_req_o.ar.prot    = 3'b000;
    assign axi_req_o.ar.qos     = 4'b0000;
    assign axi_req_o.ar.region  = 4'b0000;
    assign axi_req_o.ar.user    = '0;
    
    assign axi_req_o.r_ready    = 1'b1;

    assign obi_gnt_o            = obi_gnt;
    assign obi_rvalid_o         = axi_resp_i.r_valid;
    assign obi_rdata_o          = axi_resp_i.r.data;

endmodule