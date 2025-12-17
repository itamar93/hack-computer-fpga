`ifndef HACK_COMPUTER_V
`define HACK_COMPUTER_V

module HackComputer(
    input i_CLK,
    input i_RESET_n
);
    
    // internal signals
    wire [15:0] w_Instruction; // instruction from ROM
    wire [15:0] w_PC; // program counter
    wire [15:0] w_Mem_In; // memory input
    wire [15:0] w_Mem_Out; // memory output
    wire [15:0] w_Address_Mem; // memory address
    wire w_Write_Mem; // memory write

    // ROM
    ROM rom (
        .i_Address(w_PC),
        .o_Instruction(w_Instruction)
    );

    // CPU
    CPU cpu (
        .i_CLK(i_CLK),
        .i_RESET_n(i_RESET_n),
        .i_Instruction(w_Instruction),
        .i_Mem(w_Mem_Out),
        .o_Mem(w_Mem_In),
        .o_Address_Mem(w_Address_Mem),
        .o_Write_Mem(w_Write_Mem),
        .o_PC(w_PC)
    );

    // Memory 
    Memory memory (
        .i_CLK(i_CLK),
        .i_Address(w_Address_Mem),
        .i_Data(w_Mem_In),
        .i_Write_EN(w_Write_Mem),
        .i_RESET_n(i_RESET_n),
        .o_Data(w_Mem_Out)
    );

endmodule
`endif
