`ifndef INSTRUCTIONDECODER_V
`define INSTRUCTIONDECODER_V

module InstructionDecoder(
    input  [15:0] i_Instruction,
    input         i_ALU_Zero,            // ALU output is zero
    input         i_ALU_Neg,             // ALU output is negative
    output        o_Is_C_Instruction,    // 0 = A-instruction, 1 = C-instruction
    output        o_ALU_Src_Memory,      // 0 = use A register, 1 = use Memory content (a-bit)
    output        o_ALU_Zero_X,          // ALU control: zero the X input
    output        o_ALU_Negate_X,        // ALU control: negate the X input
    output        o_ALU_Zero_Y,          // ALU control: zero the Y input
    output        o_ALU_Negate_Y,        // ALU control: negate the Y input
    output        o_ALU_Function,        // ALU control: function select (0=AND, 1=ADD)
    output        o_ALU_Negate_Out,      // ALU control: negate the output
    output        o_Write_A,             // Write to A register
    output        o_Write_D,             // Write to D register
    output        o_Write_Memory,        // Write to Memory
    output        o_PC_Load,             // Load PC (jump)
    output        o_PC_Inc               // Increment PC (no jump)
);

    // Instruction Type (bit 15)
    assign o_Is_C_Instruction = i_Instruction[15];

    // ALU Y-input source: A register or Memory (bit 12, a-bit)
    assign o_ALU_Src_Memory = o_Is_C_Instruction ? i_Instruction[12] : 1'b0;

    // ALU control bits (bits 11-6, c1-c6)
    assign o_ALU_Zero_X     = o_Is_C_Instruction ? i_Instruction[11] : 1'b0;  // c1: zx
    assign o_ALU_Negate_X   = o_Is_C_Instruction ? i_Instruction[10] : 1'b0;  // c2: nx
    assign o_ALU_Zero_Y     = o_Is_C_Instruction ? i_Instruction[9]  : 1'b0;  // c3: zy
    assign o_ALU_Negate_Y   = o_Is_C_Instruction ? i_Instruction[8]  : 1'b0;  // c4: ny
    assign o_ALU_Function   = o_Is_C_Instruction ? i_Instruction[7]  : 1'b0;  // c5: f
    assign o_ALU_Negate_Out = o_Is_C_Instruction ? i_Instruction[6]  : 1'b0;  // c6: no

    // Destination bits (bits 5-3, d1-d3)
    assign o_Write_A      = ~o_Is_C_Instruction | (o_Is_C_Instruction & i_Instruction[5]);  // d1: A destination
    assign o_Write_D      = o_Is_C_Instruction ? i_Instruction[4] : 1'b0;                   // d2: D destination
    assign o_Write_Memory = o_Is_C_Instruction ? i_Instruction[3] : 1'b0;                   // d3: M destination

    // Jump control logic (bits 2-0, j1-j3)
    wire w_Jump_LT = o_Is_C_Instruction ? i_Instruction[2] : 1'b0;  // j1: jump if ALU output < 0
    wire w_Jump_EQ = o_Is_C_Instruction ? i_Instruction[1] : 1'b0;  // j2: jump if ALU output = 0
    wire w_Jump_GT = o_Is_C_Instruction ? i_Instruction[0] : 1'b0;  // j3: jump if ALU output > 0
    
    // Compute jump condition
    wire w_Is_Positive = ~i_ALU_Zero & ~i_ALU_Neg;  // Positive: not zero and not negative
    wire w_Do_Jump = (w_Jump_LT & i_ALU_Neg) | (w_Jump_EQ & i_ALU_Zero) | (w_Jump_GT & w_Is_Positive);
    
    assign o_PC_Load = w_Do_Jump;
    assign o_PC_Inc  = ~w_Do_Jump;

endmodule
`endif
