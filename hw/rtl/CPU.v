`ifndef CPU_V
`define CPU_V

module CPU(
    input i_CLK,
    input i_RESET_n,
    input [15:0] i_Instruction,
    input [15:0] i_Mem,
    output [15:0] o_Mem,
    output [15:0] o_Address_Mem,
    output o_Write_Mem,
    output [15:0] o_PC
);
    // Internal signals from Instruction Decoder
    wire        w_Is_C_Instruction;    // 0 = A-instruction, 1 = C-instruction
    wire        w_ALU_Src_Memory;      // 0 = use A register, 1 = use Memory content
    wire        w_ALU_Zero_X;          // ALU control: zero X
    wire        w_ALU_Negate_X;        // ALU control: negate X
    wire        w_ALU_Zero_Y;          // ALU control: zero Y
    wire        w_ALU_Negate_Y;        // ALU control: negate Y
    wire        w_ALU_Function;        // ALU control: function select
    wire        w_ALU_Negate_Out;      // ALU control: negate output
    wire        w_Write_A;             // Write to A register
    wire        w_Write_D;             // Write to D register
    wire        w_PC_Inc;              // Increment PC
    wire        w_PC_Load;             // Load PC with jump address
    
    // Internal data paths
    wire [15:0] w_A_Reg_In;            // Input to A register
    wire [15:0] w_A_Reg_Out;           // Output from A register (address)
    wire [15:0] w_D_Reg_Out;           // Output from D register
    wire [15:0] w_ALU_Out;             // ALU output
    wire [15:0] w_ALU_In_Y;            // ALU Y input (A or M)
    
    // ALU status flags
    wire        w_ALU_Zero;            // ALU output is zero
    wire        w_ALU_Neg;             // ALU output is negative

    // == Fetch-Decode Stage ==
    
    // Instruction Decoder (includes jump control logic)
    InstructionDecoder instruction_decoder (
        .i_Instruction(i_Instruction),
        .i_ALU_Zero(w_ALU_Zero),
        .i_ALU_Neg(w_ALU_Neg),
        .o_Is_C_Instruction(w_Is_C_Instruction),
        .o_ALU_Src_Memory(w_ALU_Src_Memory),
        .o_ALU_Zero_X(w_ALU_Zero_X),
        .o_ALU_Negate_X(w_ALU_Negate_X),
        .o_ALU_Zero_Y(w_ALU_Zero_Y),
        .o_ALU_Negate_Y(w_ALU_Negate_Y),
        .o_ALU_Function(w_ALU_Function),
        .o_ALU_Negate_Out(w_ALU_Negate_Out),
        .o_Write_A(w_Write_A),
        .o_Write_D(w_Write_D),
        .o_Write_Memory(o_Write_Mem),
        .o_PC_Load(w_PC_Load),
        .o_PC_Inc(w_PC_Inc)
    );

    // A register input
    assign w_A_Reg_In = w_Is_C_Instruction ? w_ALU_Out : {1'b0, i_Instruction[14:0]};

    // A Register
    Register a_register (
        .i_CLK(i_CLK),
        .i_Data(w_A_Reg_In),
        .i_Load(w_Write_A),
        .o_Data(w_A_Reg_Out)
    );

    // Program Counter
    PC program_counter (
        .i_CLK(i_CLK),
        .i_Load(w_PC_Load),
        .i_Inc(w_PC_Inc),
        .i_RESET_n(i_RESET_n),
        .i_Address(w_A_Reg_Out),
        .o_Address(o_PC)
    );

    // == Execute Stage ==
    
    // ALU input Y
    assign w_ALU_In_Y = w_ALU_Src_Memory ? i_Mem : w_A_Reg_Out;

    // ALU
    ALU alu (
        .i_X(w_D_Reg_Out),
        .i_Y(w_ALU_In_Y),
        .i_ZX(w_ALU_Zero_X),
        .i_NX(w_ALU_Negate_X),
        .i_ZY(w_ALU_Zero_Y),
        .i_NY(w_ALU_Negate_Y),
        .i_F(w_ALU_Function),
        .i_NO(w_ALU_Negate_Out),
        .o_ALU(w_ALU_Out),
        .o_ZR(w_ALU_Zero),
        .o_NG(w_ALU_Neg)
    );

    // D Register
    Register d_register (
        .i_CLK(i_CLK),
        .i_Data(w_ALU_Out),
        .i_Load(w_Write_D),
        .o_Data(w_D_Reg_Out)
    );

    // Output assignments
    assign o_Mem = w_ALU_Out;
    assign o_Address_Mem = w_A_Reg_Out;

endmodule
`endif 
        


