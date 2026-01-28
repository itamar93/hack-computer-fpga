`ifndef CPU_V
`define CPU_V

/* Multi-Cycle implementation */
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
    // Internal signals
    // == Control Unit Signals ==
    wire [15:0] w_IR_Out;
    wire w_IR_Load;
    wire w_A_Src;
    wire w_A_Load;
    wire w_D_Load;
    wire w_ALU_Y_Src;
    wire w_PC_Inc;
    wire w_PC_Load;
    wire w_zx;
    wire w_nx;
    wire w_zy;
    wire w_ny;
    wire w_f;
    wire w_no;
    wire w_ALU_Out_Reg_Load;
    wire w_ALU_Zero;
    wire w_ALU_Neg;
    // == Data Path Signals ==
    wire [15:0] w_A_Reg_Src;
    wire [15:0] w_A_Reg_Out;
    wire [15:0] w_ALU_Y_Input;
    wire [15:0] w_ALU_Out;
    wire [15:0] w_ALU_Out_Reg_Out;
    wire [15:0] w_D_Reg_Out;

    // IR Register
    Register ir_register (
        .i_CLK(i_CLK),
        .i_Data(i_Instruction),
        .i_Load(w_IR_Load),
        .o_Data(w_IR_Out)
    );

    // Control Unit 
    ControlUnit control_unit (
        .i_CLK(i_CLK),
        .i_RESET_n(i_RESET_n),
        .i_Instruction(w_IR_Out),
        .i_zr(w_ALU_Zero),
        .i_ng(w_ALU_Neg),
        .o_IR_Load(w_IR_Load),
        .o_A_Src(w_A_Src),
        .o_A_Load(w_A_Load),
        .o_D_Load(w_D_Load),
        .o_ALU_Y_Src(w_ALU_Y_Src),
        .o_PC_Inc(w_PC_Inc),
        .o_PC_Load(w_PC_Load),
        .o_zx(w_zx),
        .o_nx(w_nx),
        .o_zy(w_zy),
        .o_ny(w_ny),
        .o_f(w_f),
        .o_no(w_no),
        .o_ALU_Out_Load(w_ALU_Out_Reg_Load),
        .o_Write_Mem(o_Write_Mem)
    );

    // A register source
    assign w_A_Reg_Src = w_A_Src ? w_IR_Out : w_ALU_Out; // 1 = IR, 0 = ALU

    // A Register
    Register a_register (
        .i_CLK(i_CLK),
        .i_Data(w_A_Reg_Src),
        .i_Load(w_A_Load),
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
    
    // ALU input Y source
    assign w_ALU_Y_Input = w_ALU_Y_Src ? i_Mem : w_A_Reg_Out; // 0 = A register, 1 = Memory content

    // ALU
    ALU alu (
        .i_X(w_D_Reg_Out),
        .i_Y(w_ALU_Y_Input),
        .i_ZX(w_zx),
        .i_NX(w_nx),
        .i_ZY(w_zy),
        .i_NY(w_ny),
        .i_F(w_f),
        .i_NO(w_no),
        .o_ALU(w_ALU_Out),
        .o_ZR(w_ALU_Zero),
        .o_NG(w_ALU_Neg)
    );

    // ALU Output Register
    Register alu_output_register (
        .i_CLK(i_CLK),
        .i_Data(w_ALU_Out),
        .i_Load(w_ALU_Out_Reg_Load),
        .o_Data(w_ALU_Out_Reg_Out)
    );

    // D Register
    Register d_register (
        .i_CLK(i_CLK),
        .i_Data(w_ALU_Out_Reg_Out),
        .i_Load(w_D_Load),
        .o_Data(w_D_Reg_Out)
    );

    // Output assignments
    assign o_Mem = w_ALU_Out_Reg_Out;
    assign o_Address_Mem = w_A_Reg_Out;

endmodule
`endif 
        


