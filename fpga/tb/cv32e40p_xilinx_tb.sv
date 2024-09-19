// testbench for the testharness module
module cv32e40p_xilinx_tb;

  // Signals for the testharness module
  logic clk_i;
  logic rst_ni;

  // Instantiate the testharness module
  cv32e40p_xilinx i_cv32e40p_xilinx (
    .clk_i(clk_i),
    .rst_ni(rst_ni)
  );

  // Clock generation (50% duty cycle)
  always #5 clk_i = ~clk_i;

  // Testbench initial block
  initial begin
    // Initialize signals
    clk_i = 0;
    rst_ni = 0;

    // Apply reset for a few cycles
    #10 rst_ni = 1;

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
