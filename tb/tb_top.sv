module tb_top;

    logic clk_i;
    logic rst_ni;

    logic pulp_clock_en_i;
    logic scan_cg_en_i;

    logic [31:0] boot_addr_i;
    logic [31:0] mtvec_addr_i;
    logic [31:0] dm_halt_addr_i;
    logic [31:0] hart_id_i;
    logic [31:0] dm_exception_addr_i;

    logic        instr_req_o;
    logic        instr_gnt_i;
    logic        instr_rvalid_i;
    logic [31:0] instr_addr_o;
    logic [31:0] instr_rdata_i;

    logic        data_req_o;
    logic        data_gnt_i;
    logic        data_rvalid_i;
    logic        data_we_o;
    logic [3:0]  data_be_o;
    logic [31:0] data_addr_o;
    logic [31:0] data_wdata_o;
    logic [31:0] data_rdata_i;

    logic [31:0] irq_i;
    logic        irq_ack_o;
    logic [4:0]  irq_id_o;

    logic debug_req_i;
    logic debug_havereset_o;
    logic debug_running_o;
    logic debug_halted_o;

    logic fetch_enable_i;
    logic core_sleep_o;

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
        .pulp_clock_en_i(pulp_clock_en_i),
        .scan_cg_en_i(scan_cg_en_i),
        .boot_addr_i(boot_addr_i),
        .mtvec_addr_i(mtvec_addr_i),
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

    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

    initial begin
        rst_ni = 0;
        pulp_clock_en_i = 1;
        scan_cg_en_i = 0;
        boot_addr_i = 32'h0000_0000;
        mtvec_addr_i = 32'h0000_0000;
        dm_halt_addr_i = 32'h0000_0000;
        hart_id_i = 32'h0000_0000;
        dm_exception_addr_i = 32'h0000_0000;
        instr_gnt_i = 0;
        instr_rvalid_i = 0;
        instr_rdata_i = 32'h0000_0000;
        data_gnt_i = 0;
        data_rvalid_i = 0;
        data_rdata_i = 32'h0000_0000;
        irq_i = 32'h0000_0000;
        debug_req_i = 0;
        fetch_enable_i = 1;

        #20;
        rst_ni = 1;

        #1000;
        $finish;
    end
    initial begin
        $fsdbDumpfile("wave.fsdb");
        $fsdbDumpvars("+all");
        $fsdbDumpMDA();
    end


endmodule
