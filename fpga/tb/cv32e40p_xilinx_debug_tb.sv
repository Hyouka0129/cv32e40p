// testbench for the testharness module
module cv32e40p_xilinx_debug_tb;

  // Signals for the testharness module
  logic clk_i;
  logic rst_ni;
  logic tck_i;
  logic tms_i;
  logic td_i;
  logic td_o;
  logic trst_ni;
  logic debug_req_i;
  logic debug_req_valid_i;

  // Instantiate the testharness module
  cv32e40p_xilinx_debug i_cv32e40p_xilinx_debug (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .tck_i,
    .tms_i,
    .td_i,
    .td_o,
    .debug_req_i
  );

  // Clock generation (50% duty cycle)
  always #5 clk_i = ~clk_i;
  always #20 tck_i = ~tck_i;
  // Testbench initial block
  initial begin
    // Initialize signals
    clk_i = 0;
    rst_ni = 0;
    tck_i = 0;
    tms_i = 0;
    td_i = 0;
    trst_ni = 0;
    debug_req_valid_i = 0;
    debug_req_i = 0;
    // Apply reset for a few cycles
    #10 rst_ni = 1;
    trst_ni = 1;
    // Run simulation for 100 time units and finish
    #5000
    debug_req_valid_i = 1;
    debug_req_i = 1;
    #10;
    debug_req_i = 0;
    #10000 $finish;
  end

  // Dump waveforms for debugging (if needed)
  initial begin
    $fsdbDumpfile("wave.fsdb");
    $fsdbDumpvars("+all");
    $fsdbDumpMDA();
  end

endmodule
