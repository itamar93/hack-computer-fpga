`ifndef ADD16_V
`define ADD16_V

// This module implements a 16-bit adder
// out = a + b
module Add16(
    input [15:0] i_A,
    input [15:0] i_B,
    output [15:0] o_Add16
);

    // logic
    assign o_Add16 = i_A + i_B;
endmodule
`endif