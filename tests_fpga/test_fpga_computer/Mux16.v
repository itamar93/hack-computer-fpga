`ifndef MUX16_V
`define MUX16_V

// This module implements a 16-bit multiplexer: 
// It gates two 16-bit inputs a and b, 1-bit selector sel,
// and outputs one of the inputs based on the selector.
module Mux16(a, b, sel, out);

    input [15:0] a, b;
    input sel;
    output [15:0] out;

    // logic
    assign out = sel ? b : a;

endmodule

`endif