`ifndef ALU_V
`define ALU_V


module ALU(
        input [15:0] i_X,
        input [15:0] i_Y,
        input i_ZX,
        input i_NX,
        input i_ZY,
        input i_NY,
        input i_F,
        input i_NO,
        output o_ZR,
        output o_NG,
        output [15:0] o_ALU
);

        // wires declaration
        wire [15:0] w_OutZx;
        wire [15:0] w_OutZxN;
        wire [15:0] w_OutZy;
        wire [15:0] w_OutZyN;
        wire [15:0] w_OutAdd;
        wire [15:0] w_OutF;

        // zero x if zx is set
        assign w_OutZx = i_ZX ? 16'b0 : i_X;
        // negate x if nx is set
        assign w_OutZxN = i_NX ? ~w_OutZx : w_OutZx;

        // zero y if zy is set
        assign w_OutZy = i_ZY ? 16'b0 : i_Y;
        // negate y if ny is set
        assign w_OutZyN = i_NY ? ~w_OutZy : w_OutZy;

        // f: ADD or AND
        Add16 add(.i_A(w_OutZxN), .i_B(w_OutZyN), .o_Add16(w_OutAdd));
        assign w_OutF = i_F ? w_OutAdd : w_OutZyN & w_OutZxN;

        // negate output if no is set
        assign o_ALU = i_NO ? ~w_OutF : w_OutF;

        // Flags
        assign o_ZR = (o_ALU == 16'b0) ? 1'b1 : 1'b0;
        assign o_NG = o_ALU[15];

endmodule
`endif