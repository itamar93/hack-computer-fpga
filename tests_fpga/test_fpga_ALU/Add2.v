`ifndef ADD2_V
`define ADD2_V

module Add2(a, b, out);

    input [1:0] a, b;
    output [1:0] out;

    // logic
    assign out = a + b;

endmodule

`endif