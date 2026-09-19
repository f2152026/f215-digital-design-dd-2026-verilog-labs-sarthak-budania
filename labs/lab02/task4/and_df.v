// and_df.v
// 2-input AND gate, DATAFLOW style.

module and_df (
  input  a,
  input  b,
  output wire y
);

  assign #1 y = a & b;

endmodule