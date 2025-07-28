`ifndef ADD16_V
`define ADD16_V

// This module implements a 16-bit adder
// out = a + b
module Add16(a, b, out);

    input [15:0] a, b;
    output [15:0] out;

    // logic
    assign out = a + b;

endmodule

`endif