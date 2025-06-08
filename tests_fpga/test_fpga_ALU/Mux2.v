`ifndef MUX2_V
`define MUX2_V

module Mux2(a, b, sel, out);

    input [1:0] a, b;
    input sel;
    output [1:0] out;

    // logic
    assign out = sel ? b : a;

endmodule

`endif