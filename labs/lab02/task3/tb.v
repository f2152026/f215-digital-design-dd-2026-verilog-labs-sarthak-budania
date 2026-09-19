// tb.v
// Self-checking testbench for comp2.
// Tests all 16 possible combinations of A and B.

module tb;

  // DUT inputs
  reg [1:0] t_a;
  reg [1:0] t_b;

  // DUT outputs
  wire t_gt;
  wire t_lt;
  wire t_eq;

  // Expected outputs
  reg exp_gt;
  reg exp_lt;
  reg exp_eq;

  // Error counter
  integer errors;

  // Loop variables
  integer a;
  integer b;

  // Instantiate DUT
  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  // Waveform dump configuration
  string vcd_file;

  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Test all 16 input combinations
  initial begin

    errors = 0;

    for (a = 0; a < 4; a = a + 1) begin

      for (b = 0; b < 4; b = b + 1) begin

        t_a = a;
        t_b = b;

        #1;

        // Calculate expected result independently
        if (a > b) begin
          exp_gt = 1;
          exp_lt = 0;
          exp_eq = 0;
        end
        else if (a < b) begin
          exp_gt = 0;
          exp_lt = 1;
          exp_eq = 0;
        end
        else begin
          exp_gt = 0;
          exp_lt = 0;
          exp_eq = 1;
        end

        // Compare actual and expected outputs
        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin

          $display("FAIL at time %0t: A=%b B=%b got GT=%b LT=%b EQ=%b expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b,
                   t_gt, t_lt, t_eq,
                   exp_gt, exp_lt, exp_eq);

          errors = errors + 1;

        end

      end

    end

    // Final summary
    $display("========================================");

    if (errors == 0)
      $display("PASS: All 16 combinations passed.");
    else
      $display("FAIL: %0d out of 16 combinations failed.", errors);

    $display("========================================");

    $finish;

  end

  // Monitor signals
  initial
    $monitor($time,
             " A=%b B=%b | GT=%b LT=%b EQ=%b",
             t_a, t_b, t_gt, t_lt, t_eq);

endmodule