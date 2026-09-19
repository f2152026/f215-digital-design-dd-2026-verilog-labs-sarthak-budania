// tb.v
// Self-checking testbench for alu.
// Tests both addition and subtraction operations.

module tb;

  // DUT inputs
  reg [3:0] t_a;
  reg [3:0] t_b;
  reg       t_op;

  // DUT output
  wire [3:0] t_result;

  // Expected result
  reg [3:0] expected;

  // Error counter
  integer errors;

  // Instantiate DUT
  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;

  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, tb);
    end
  end

  initial begin

    errors = 0;

    // ------------------------------------------------
    // Test 1: Addition
    // ------------------------------------------------

    t_a = 4;
    t_b = 3;
    t_op = 0;

    #1;

    expected = t_a + t_b;

    if (t_result !== expected) begin
      $display("FAIL: ADD a=%d b=%d got=%d expected=%d",
               t_a, t_b, t_result, expected);
      errors = errors + 1;
    end
    else begin
      $display("PASS: ADD a=%d b=%d result=%d",
               t_a, t_b, t_result);
    end


    // ------------------------------------------------
    // Test 2: Switch operation while keeping a and b
    // fixed. This tests the sensitivity list.
    // ------------------------------------------------

    t_op = 1;

    #1;

    expected = t_a - t_b;

    if (t_result !== expected) begin
      $display("FAIL: SUB a=%d b=%d got=%d expected=%d",
               t_a, t_b, t_result, expected);
      errors = errors + 1;
    end
    else begin
      $display("PASS: SUB a=%d b=%d result=%d",
               t_a, t_b, t_result);
    end


    // ------------------------------------------------
    // Test 3: Addition with different operands
    // ------------------------------------------------

    t_a = 7;
    t_b = 2;
    t_op = 0;

    #1;

    expected = t_a + t_b;

    if (t_result !== expected) begin
      $display("FAIL: ADD a=%d b=%d got=%d expected=%d",
               t_a, t_b, t_result, expected);
      errors = errors + 1;
    end
    else begin
      $display("PASS: ADD a=%d b=%d result=%d",
               t_a, t_b, t_result);
    end


    // ------------------------------------------------
    // Test 4: Subtraction with different operands
    // ------------------------------------------------

    t_op = 1;

    #1;

    expected = t_a - t_b;

    if (t_result !== expected) begin
      $display("FAIL: SUB a=%d b=%d got=%d expected=%d",
               t_a, t_b, t_result, expected);
      errors = errors + 1;
    end
    else begin
      $display("PASS: SUB a=%d b=%d result=%d",
               t_a, t_b, t_result);
    end


    // ------------------------------------------------
    // Test 5: Another subtraction
    // ------------------------------------------------

    t_a = 10;
    t_b = 3;
    t_op = 1;

    #1;

    expected = t_a - t_b;

    if (t_result !== expected) begin
      $display("FAIL: SUB a=%d b=%d got=%d expected=%d",
               t_a, t_b, t_result, expected);
      errors = errors + 1;
    end
    else begin
      $display("PASS: SUB a=%d b=%d result=%d",
               t_a, t_b, t_result);
    end


    // ------------------------------------------------
    // Final summary
    // ------------------------------------------------

    $display("----------------------------------------");

    if (errors == 0)
      $display("PASS: All tests passed.");
    else
      $display("FAIL: %0d tests failed.", errors);

    $display("----------------------------------------");

    $finish;

  end

  // Monitor
  initial
    $monitor($time,
             " a=%d b=%d op=%b | result=%d",
             t_a, t_b, t_op, t_result);

endmodule