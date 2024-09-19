`include "axi/typedef.svh"
`include "axi/assign.svh"

module cv32e40p_xilinx (
    input   clk_i,
    input   rst_ni
);
    
    AXI_BUS #(
        .AXI_ADDR_WIDTH ( 32    ),
        .AXI_DATA_WIDTH ( 32    ),
        .AXI_ID_WIDTH   ( 1     ),
        .AXI_USER_WIDTH ( 1     )
    ) slave[1:0]();

    AXI_BUS #(
        .AXI_ADDR_WIDTH ( 32    ),
        .AXI_DATA_WIDTH ( 32    ),
        .AXI_ID_WIDTH   ( 1     ),
        .AXI_USER_WIDTH ( 1     )
    ) master[1:0]();
    
    localparam axi_pkg::xbar_cfg_t AXI_XBAR_CFG = '{
        NoSlvPorts:         2,
        NoMstPorts:         2,
        MaxMstTrans:        1, // Probably requires update
        MaxSlvTrans:        1, // Probably requires update
        FallThrough:        1'b0,
        LatencyMode:        axi_pkg::CUT_ALL_PORTS,
        AxiIdWidthSlvPorts: 1,
        AxiIdUsedSlvPorts:  1,
        UniqueIds:          1'b0,
        AxiAddrWidth:       32,
        AxiDataWidth:       32,
        NoAddrRules:        2
    };

    axi_pkg::xbar_rule_32_t [1:0] addr_map;

    localparam idx_rom      = 0;
    localparam idx_sram     = 1;
    localparam rom_base     = 32'h00010000;
    localparam rom_length   = 32'h00010000;
    localparam sram_base    = 32'h10000000;
    localparam sram_length  = 32'h10000000;

    assign addr_map = '{
        '{ idx: idx_rom,       start_addr: rom_base,        end_addr: rom_base + rom_length   },
        '{ idx: idx_sram,      start_addr: sram_base,       end_addr: sram_base + sram_length }
    };

    axi_xbar_intf #(
        .AXI_USER_WIDTH ( 1                         ),
        .Cfg            ( AXI_XBAR_CFG              ),
        .rule_t         ( axi_pkg::xbar_rule_32_t   )
    ) i_axi_xbar (
        .clk_i                 ( clk_i      ),
        .rst_ni                ( rst_ni     ),
        .test_i                ( 1'b0       ),
        .slv_ports             ( slave      ),
        .mst_ports             ( master     ),
        .addr_map_i            ( addr_map   ),
        .en_default_mst_port_i ( '0         ),
        .default_mst_port_i    ( '0         )
    );

    logic           instr_req;
    logic           instr_gnt;
    logic           instr_rvalid;
    logic [31:0]    instr_addr;
    logic [31:0]    instr_rdata;
    logic           data_req;
    logic           data_gnt;
    logic           data_rvalid;
    logic           data_we;
    logic [3:0]     data_be;
    logic [31:0]    data_addr;
    logic [31:0]    data_wdata;
    logic [31:0]    data_rdata;

    cv32e40p_top #(
        .COREV_PULP(0),
        .COREV_CLUSTER(0),
        .FPU(0),
        .FPU_ADDMUL_LAT(0),
        .FPU_OTHERS_LAT(0),
        .ZFINX(0),
        .NUM_MHPMCOUNTERS(0) 
    )   i_ri5cy (
        .clk_i                  (clk_i          ),
        .rst_ni                 (rst_ni         ),
        .pulp_clock_en_i        ('0             ),
        .scan_cg_en_i           ('0             ),
        .boot_addr_i            (32'b00010000   ),
        .mtvec_addr_i           (32'b00010000   ),
        .dm_halt_addr_i         (32'b00010000   ),
        .hart_id_i              ('0             ),
        .dm_exception_addr_i    (32'b00010000   ),
        .instr_req_o            (instr_req      ),
        .instr_gnt_i            (instr_gnt      ),
        .instr_rvalid_i         (instr_rvalid   ),
        .instr_addr_o           (instr_addr     ),
        .instr_rdata_i          (instr_rdata    ),
        .data_req_o             (data_req       ),
        .data_gnt_i             (data_gnt       ),
        .data_rvalid_i          (data_rvalid    ),
        .data_we_o              (data_we        ),
        .data_be_o              (data_be        ),
        .data_addr_o            (data_addr      ),
        .data_wdata_o           (data_wdata     ),
        .data_rdata_i           (data_rdata     ),
        .irq_i                  (32'b0          ),
        .irq_ack_o              (               ),
        .irq_id_o               (               ),
        .debug_req_i            (1'b0           ),
        .debug_havereset_o      (               ),
        .debug_running_o        (               ),
        .debug_halted_o         (               ),
        .fetch_enable_i         (1'b1           ),
        .core_sleep_o           (               )
    );

    `AXI_TYPEDEF_ALL(axi        ,
                logic [31:0]    ,
                logic           ,
                logic [31:0]    ,
                logic [3:0]     ,
                logic           )

    axi_req_t   instr_axi_req;
    axi_resp_t  instr_axi_resp;

    `AXI_ASSIGN_FROM_REQ(slave[0],instr_axi_req)
    `AXI_ASSIGN_TO_RESP(instr_axi_resp,slave[0])

    obi_axi_adapter #(
        .axi_req_t  (axi_req_t  ),
        .axi_resp_t (axi_resp_t ),
        .DATA_WIDTH (32         ),
        .ADDR_WIDTH (32         )
    ) i_obi_axi_adapter_instr (
        .obi_req_i      (instr_req      ),
        .obi_gnt_o      (instr_gnt      ),
        .obi_rvalid_o   (instr_rvalid   ),
        .obi_we_i       (1'b0           ),
        .obi_be_i       (4'b1111        ),
        .obi_addr_i     (instr_addr     ),
        .obi_wdata_i    ('0             ),
        .obi_rdata_o    (instr_rdata    ),
        .axi_req_o      (instr_axi_req  ),
        .axi_resp_i     (instr_axi_resp )
    );

    axi_req_t   data_axi_req;
    axi_resp_t  data_axi_resp;

    `AXI_ASSIGN_FROM_REQ(slave[1],data_axi_req)
    `AXI_ASSIGN_TO_RESP(data_axi_resp,slave[1])

    obi_axi_adapter #(
        .axi_req_t  (axi_req_t  ),
        .axi_resp_t (axi_resp_t ),
        .DATA_WIDTH (32         ),
        .ADDR_WIDTH (32         )
    ) i_obi_axi_adapter_data (
        .obi_req_i      (data_req      ),
        .obi_gnt_o      (data_gnt      ),
        .obi_rvalid_o   (data_rvalid   ),
        .obi_we_i       (data_we       ),
        .obi_be_i       (data_be       ),
        .obi_addr_i     (data_addr     ),
        .obi_wdata_i    (data_wdata    ),
        .obi_rdata_o    (data_rdata    ),
        .axi_req_o      (data_axi_req  ),
        .axi_resp_i     (data_axi_resp )
    );

    logic           rom_req;
    logic [31:0]    rom_addr;
    logic [31:0]    rom_rdata;
    

    bootrom i_bootrom (
        .clk_i   ( clk_i            ),
        .req_i   ( rom_req          ),
        .addr_i  ( rom_addr         ),
        .rdata_o ( rom_rdata        )
    );

    axi2mem #(
        .AXI_ID_WIDTH   ( 1     ),
        .AXI_ADDR_WIDTH ( 32    ),
        .AXI_DATA_WIDTH ( 32    ),
        .AXI_USER_WIDTH ( 1     )
    ) i_axi2rom (
        .clk_i  ( clk_i             ),
        .rst_ni ( rst_ni            ),
        .slave  ( master[idx_rom]   ),
        .req_o  ( rom_req           ),
        .we_o   (                   ),
        .addr_o ( rom_addr          ),
        .be_o   (                   ),
        .data_o (                   ),
        .data_i ( rom_rdata         )
    );

    logic           sram_req;
    logic           sram_we;
    logic [31:0]    sram_addr;
    logic [31:0]    sram_wdata;
    logic [3:0]     sram_be;
    logic [31:0]    sram_rdata;

    sram #(
        .DATA_WIDTH ( 32        ),
        .USER_EN    ( 0			),
        .SIM_INIT	( "zeros"	),
        .NUM_WORDS	( 1024	    )
    ) i_sram (
        .clk_i		( clk_i 	        ),
        .rst_ni		( rst_ni            ),
        .req_i		( sram_req		    ),
        .we_i	    ( sram_we		    ),
        .addr_i		( sram_addr[15:6]   ),
        .wuser_i	( '0		        ),
        .wdata_i	( sram_wdata		),
        .be_i		( sram_be		    ),
        .ruser_o	( 		            ),
        .rdata_o	( sram_rdata	  	)
    );

    axi2mem #(
        .AXI_ID_WIDTH   ( 1     ),
        .AXI_ADDR_WIDTH ( 32    ),
        .AXI_DATA_WIDTH ( 32    ),
        .AXI_USER_WIDTH ( 1     )
    ) i_axi2sram (
        .clk_i  ( clk_i             ),
        .rst_ni ( rst_ni            ),
        .slave  ( master[idx_sram]  ),
        .req_o  ( sram_req          ),
        .we_o   ( sram_we           ),
        .addr_o ( sram_addr         ),
        .be_o   ( sram_be           ),
        .data_o ( sram_wdata        ),
        .data_i ( rom_rdata         )
    );
endmodule