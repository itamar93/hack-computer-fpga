`ifndef ALU_V
`define ALU_V

`include "../gates/Mux16.v"
`include "Add16.v"

// This module implements a 16-bit ALU
// It performs various arithmetic and logical operations based on control signals
// Inputs:
// - x, y: 16-bit inputs
// - zx, nx, zy, ny: control signals to zero or negate inputs
// - f: function select signal (0 for ADD, 1 for AND)
// - no: output negation control signal
// Outputs:
// - out: 16-bit output
// - zr: zero flag (1 if out is zero)
// - ng: negative flag (1 if out is negative)
module ALU(x, y, zx, nx, zy, ny, f, no, out, zr, ng);

        input [15:0] x, y;
        input zx, nx, zy, ny, f, no;
        output [15:0] out;
        output zr, ng;

        // wires declaration
        wire [15:0] outZx, outZxN, outNx;
        wire [15:0] outZy, outZyN, outNy;
        wire [15:0] outAdd, outAnd;
        wire [15:0] outF;

        // zero x if zx is set
        Mux16 muxZx(.a(x), .b(16'b0), .sel(zx), .out(outZx));
        // negate x if nx is set
        Mux16 muxZxN(.a(outZx), .b(~outZx), .sel(nx), .out(outZxN));

        // zero y if zy is set
        Mux16 muxZy(.a(y), .b(16'b0), .sel(zy), .out(outZy));
        // negate y if ny is set
        Mux16 muxZyN(.a(outZy), .b(~outZy), .sel(ny), .out(outZyN));

        // perform addition if f is 1
        Add16 add(.a(outZxN), .b(outZyN), .out(outAdd));
        // select function output
        Mux16 muxF(.a(outZyN & outZxN), .b(outAdd), .sel(f), .out(outF));

        // negate output if no is set
        Mux16 muxFN(.a(outF), .b(~outF), .sel(no), .out(out));

        // set zero flag if output is zero
        assign zr = (out == 16'b0) ? 1'b1 : 1'b0;
        // set negative flag if output is negative
        assign ng = out[15];

endmodule
`endif