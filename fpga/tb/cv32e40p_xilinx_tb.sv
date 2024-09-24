// testbench for the testharness module
module cv32e40p_xilinx_tb;

  // Signals for the testharness module
  logic clk_i;
  logic rst_ni;
  logic tck_i;
  logic tms_i;
  logic td_i;
  logic td_o;
  logic trst_ni;

  // Instantiate the testharness module
  cv32e40p_xilinx i_cv32e40p_xilinx (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .tck_i,
    .tms_i,
    .td_i,
    .td_o,
    .trst_ni
  );

  // Clock generation (50% duty cycle)
  always #5 clk_i = ~clk_i;

  // Testbench initial block
  initial begin
    // Initialize signals
    clk_i = 0;
    rst_ni = 0;
    tck_i = 0;
    tms_i = 0;
    td_i = 0;
    trst_ni = 0;

    // Apply reset for a few cycles
    #10 rst_ni = 1;
    trst_ni = 1;
    // Run simulation for 100 time units and finish
    #10000 $finish;
  end

  // Dump waveforms for debugging (if needed)
  initial begin
    $fsdbDumpfile("wave.fsdb");
    $fsdbDumpvars("+all");
    $fsdbDumpMDA();
  end

endmodule
