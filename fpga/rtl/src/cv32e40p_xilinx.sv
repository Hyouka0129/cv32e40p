module cv32e40p_xilinx (
    input   clk_i,
    input   rst_ni
);
    
    
    
    cv32e40p_top #(
        .COREV_PULP(0),
        .COREV_CLUSTER(0),
        .FPU(0),
        .FPU_ADDMUL_LAT(0),
        .FPU_OTHERS_LAT(0),
        .ZFINX(0),
        .NUM_MHPMCOUNTERS(0) 
    )   i_ri5cy (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .pulp_clock_en_i('0),
        .scan_cg_en_i('0),
        .boot_addr_i(32'b00010000),
        .mtvec_addr_i(32'b00000000),
        .dm_halt_addr_i(dm_halt_addr_i),
        .hart_id_i(hart_id_i),
        .dm_exception_addr_i(dm_exception_addr_i),
        .instr_req_o(instr_req_o),
        .instr_gnt_i(instr_gnt_i),
        .instr_rvalid_i(instr_rvalid_i),
        .instr_addr_o(instr_addr_o),
        .instr_rdata_i(instr_rdata_i),
        .data_req_o(data_req_o),
        .data_gnt_i(data_gnt_i),
        .data_rvalid_i(data_rvalid_i),
        .data_we_o(data_we_o),
        .data_be_o(data_be_o),
        .data_addr_o(data_addr_o),
        .data_wdata_o(data_wdata_o),
        .data_rdata_i(data_rdata_i),
        .irq_i(irq_i),
        .irq_ack_o(irq_ack_o),
        .irq_id_o(irq_id_o),
        .debug_req_i(debug_req_i),
        .debug_havereset_o(debug_havereset_o),
        .debug_running_o(debug_running_o),
        .debug_halted_o(debug_halted_o),
        .fetch_enable_i(fetch_enable_i),
        .core_sleep_o(core_sleep_o)
    );

endmodule