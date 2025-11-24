`ifndef ALU_2BIT_V
`define ALU_2BIT_V

`include "Mux2.v"
`include "Add2.v"

module ALU_2bit(x, y, zx, nx, zy, ny, f, no, out, zr, ng);

        input [1:0] x, y;
        input zx, nx, zy, ny, f, no;
        output [1:0] out;
        output zr, ng;

        // wires declaration
        wire [1:0] outZx, outZxN, outNx;
        wire [1:0] outZy, outZyN, outNy;
        wire [1:0] outAdd, outAnd;
        wire [1:0] outF;

        // zero x if zx is set
        Mux2 muxZx(.a(x), .b(2'b0), .sel(zx), .out(outZx));
        // negate x if nx is set
        Mux2 muxZxN(.a(outZx), .b(~outZx), .sel(nx), .out(outZxN));

        // zero y if zy is set
        Mux2 muxZy(.a(y), .b(2'b0), .sel(zy), .out(outZy));
        // negate y if ny is set
        Mux2 muxZyN(.a(outZy), .b(~outZy), .sel(ny), .out(outZyN));

        // perform addition if f is 1
        Add2 add(.a(outZxN), .b(outZyN), .out(outAdd));
        // select function output
        Mux2 muxF(.a(outZyN & outZxN), .b(outAdd), .sel(f), .out(outF));

        // negate output if no is set
        Mux2 muxFN(.a(outF), .b(~outF), .sel(no), .out(out));

        // set zero flag if output is zero
        assign zr = (out == 2'b0) ? 1'b1 : 1'b0;
        // set negative flag if output is negative
        assign ng = out[1];

endmodule
`endif