`ifndef JMPCONTROLUNIT_V
`define JMPCONTROLUNIT_V

module JmpControlUnit(
    input zr, ng,        // ALU output flags
    input jL, jE, jG,     // Jump bits
    output pcInc, pcLoad
);

    wire isPos = ~zr & ~ng;   // Positive result: not zero and not negative
    wire isJmp = (jL & ng) | (jE & zr) | (jG & isPos);

    assign pcLoad = isJmp;
    assign pcInc  = ~isJmp;

endmodule
`endif
