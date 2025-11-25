`timescale 1ns/1ps

module tb_InstructionDecoder;

    // Inputs
    reg [15:0] i_Instruction;
    reg i_ALU_Zero;
    reg i_ALU_Neg;

    // Outputs
    wire o_Is_C_Instruction;
    wire o_ALU_Src_Memory;
    wire o_ALU_Zero_X;
    wire o_ALU_Negate_X;
    wire o_ALU_Zero_Y;
    wire o_ALU_Negate_Y;
    wire o_ALU_Function;
    wire o_ALU_Negate_Out;
    wire o_Write_A;
    wire o_Write_D;
    wire o_Write_Memory;
    wire o_PC_Load;
    wire o_PC_Inc;

    // Instantiate the Unit Under Test (UUT)
    InstructionDecoder uut (
        .i_Instruction(i_Instruction),
        .i_ALU_Zero(i_ALU_Zero),
        .i_ALU_Neg(i_ALU_Neg),
        .o_Is_C_Instruction(o_Is_C_Instruction),
        .o_ALU_Src_Memory(o_ALU_Src_Memory),
        .o_ALU_Zero_X(o_ALU_Zero_X),
        .o_ALU_Negate_X(o_ALU_Negate_X),
        .o_ALU_Zero_Y(o_ALU_Zero_Y),
        .o_ALU_Negate_Y(o_ALU_Negate_Y),
        .o_ALU_Function(o_ALU_Function),
        .o_ALU_Negate_Out(o_ALU_Negate_Out),
        .o_Write_A(o_Write_A),
        .o_Write_D(o_Write_D),
        .o_Write_Memory(o_Write_Memory),
        .o_PC_Load(o_PC_Load),
        .o_PC_Inc(o_PC_Inc)
    );

    initial begin
        // Display header
        $display("\n========== Instruction Decoder Test ==========\n");
        $display("Time\tInstr\t\tALU Flags\tType\taSrc\tALU Ctrl\tDest\tPC Ctrl");
        $display("----\t-----\t\t---------\t----\t----\t--------\t----\t-------");
        
        // Test A-instruction: @123 (0x007B)
        i_Instruction = 16'h007B;
        i_ALU_Zero = 0; i_ALU_Neg = 0;
        #10;
        $display("%0t\t%h\tzr=%b ng=%b\tA\t%b\t%b%b%b%b%b%b\t%b%b%b\tLoad=%b Inc=%b", 
                 $time, i_Instruction, i_ALU_Zero, i_ALU_Neg, o_ALU_Src_Memory,
                 o_ALU_Zero_X, o_ALU_Negate_X, o_ALU_Zero_Y, 
                 o_ALU_Negate_Y, o_ALU_Function, o_ALU_Negate_Out,
                 o_Write_A, o_Write_D, o_Write_Memory,
                 o_PC_Load, o_PC_Inc);
        
        // Test C-instruction: D=A (1110110000010000)
        i_Instruction = 16'hEC10;
        i_ALU_Zero = 0; i_ALU_Neg = 0;
        #10;
        $display("%0t\t%h\tzr=%b ng=%b\tC\t%b\t%b%b%b%b%b%b\t%b%b%b\tLoad=%b Inc=%b", 
                 $time, i_Instruction, i_ALU_Zero, i_ALU_Neg, o_ALU_Src_Memory,
                 o_ALU_Zero_X, o_ALU_Negate_X, o_ALU_Zero_Y, 
                 o_ALU_Negate_Y, o_ALU_Function, o_ALU_Negate_Out,
                 o_Write_A, o_Write_D, o_Write_Memory,
                 o_PC_Load, o_PC_Inc);
        
        // Test C-instruction: D=D+A (1110000010010000)
        i_Instruction = 16'hE090;
        i_ALU_Zero = 0; i_ALU_Neg = 0;
        #10;
        $display("%0t\t%h\tzr=%b ng=%b\tC\t%b\t%b%b%b%b%b%b\t%b%b%b\tLoad=%b Inc=%b", 
                 $time, i_Instruction, i_ALU_Zero, i_ALU_Neg, o_ALU_Src_Memory,
                 o_ALU_Zero_X, o_ALU_Negate_X, o_ALU_Zero_Y, 
                 o_ALU_Negate_Y, o_ALU_Function, o_ALU_Negate_Out,
                 o_Write_A, o_Write_D, o_Write_Memory,
                 o_PC_Load, o_PC_Inc);
        
        // Test C-instruction: M=D (1110001100001000)
        i_Instruction = 16'hE308;
        i_ALU_Zero = 0; i_ALU_Neg = 0;
        #10;
        $display("%0t\t%h\tzr=%b ng=%b\tC\t%b\t%b%b%b%b%b%b\t%b%b%b\tLoad=%b Inc=%b", 
                 $time, i_Instruction, i_ALU_Zero, i_ALU_Neg, o_ALU_Src_Memory,
                 o_ALU_Zero_X, o_ALU_Negate_X, o_ALU_Zero_Y, 
                 o_ALU_Negate_Y, o_ALU_Function, o_ALU_Negate_Out,
                 o_Write_A, o_Write_D, o_Write_Memory,
                 o_PC_Load, o_PC_Inc);
        
        $display("\n--- Jump Instruction Tests ---");
        
        // Test C-instruction: D;JGT (1110001100000001) - Jump if D > 0
        i_Instruction = 16'hE301;
        
        // Case 1: ALU result is positive (should jump)
        i_ALU_Zero = 0; i_ALU_Neg = 0;
        #10;
        $display("%0t\t%h\tzr=%b ng=%b\tC\t%b\t%b%b%b%b%b%b\t%b%b%b\tLoad=%b Inc=%b (JGT, positive - JUMP)", 
                 $time, i_Instruction, i_ALU_Zero, i_ALU_Neg, o_ALU_Src_Memory,
                 o_ALU_Zero_X, o_ALU_Negate_X, o_ALU_Zero_Y, 
                 o_ALU_Negate_Y, o_ALU_Function, o_ALU_Negate_Out,
                 o_Write_A, o_Write_D, o_Write_Memory,
                 o_PC_Load, o_PC_Inc);
        
        // Case 2: ALU result is zero (should not jump)
        i_ALU_Zero = 1; i_ALU_Neg = 0;
        #10;
        $display("%0t\t%h\tzr=%b ng=%b\tC\t%b\t%b%b%b%b%b%b\t%b%b%b\tLoad=%b Inc=%b (JGT, zero - NO JUMP)", 
                 $time, i_Instruction, i_ALU_Zero, i_ALU_Neg, o_ALU_Src_Memory,
                 o_ALU_Zero_X, o_ALU_Negate_X, o_ALU_Zero_Y, 
                 o_ALU_Negate_Y, o_ALU_Function, o_ALU_Negate_Out,
                 o_Write_A, o_Write_D, o_Write_Memory,
                 o_PC_Load, o_PC_Inc);
        
        // Case 3: ALU result is negative (should not jump)
        i_ALU_Zero = 0; i_ALU_Neg = 1;
        #10;
        $display("%0t\t%h\tzr=%b ng=%b\tC\t%b\t%b%b%b%b%b%b\t%b%b%b\tLoad=%b Inc=%b (JGT, negative - NO JUMP)", 
                 $time, i_Instruction, i_ALU_Zero, i_ALU_Neg, o_ALU_Src_Memory,
                 o_ALU_Zero_X, o_ALU_Negate_X, o_ALU_Zero_Y, 
                 o_ALU_Negate_Y, o_ALU_Function, o_ALU_Negate_Out,
                 o_Write_A, o_Write_D, o_Write_Memory,
                 o_PC_Load, o_PC_Inc);
        
        // Test C-instruction: D;JEQ (1110001100000010) - Jump if D = 0
        i_Instruction = 16'hE302;
        i_ALU_Zero = 1; i_ALU_Neg = 0;
        #10;
        $display("%0t\t%h\tzr=%b ng=%b\tC\t%b\t%b%b%b%b%b%b\t%b%b%b\tLoad=%b Inc=%b (JEQ, zero - JUMP)", 
                 $time, i_Instruction, i_ALU_Zero, i_ALU_Neg, o_ALU_Src_Memory,
                 o_ALU_Zero_X, o_ALU_Negate_X, o_ALU_Zero_Y, 
                 o_ALU_Negate_Y, o_ALU_Function, o_ALU_Negate_Out,
                 o_Write_A, o_Write_D, o_Write_Memory,
                 o_PC_Load, o_PC_Inc);
        
        // Test C-instruction: D;JLT (1110001100000100) - Jump if D < 0
        i_Instruction = 16'hE304;
        i_ALU_Zero = 0; i_ALU_Neg = 1;
        #10;
        $display("%0t\t%h\tzr=%b ng=%b\tC\t%b\t%b%b%b%b%b%b\t%b%b%b\tLoad=%b Inc=%b (JLT, negative - JUMP)", 
                 $time, i_Instruction, i_ALU_Zero, i_ALU_Neg, o_ALU_Src_Memory,
                 o_ALU_Zero_X, o_ALU_Negate_X, o_ALU_Zero_Y, 
                 o_ALU_Negate_Y, o_ALU_Function, o_ALU_Negate_Out,
                 o_Write_A, o_Write_D, o_Write_Memory,
                 o_PC_Load, o_PC_Inc);
        
        // Test C-instruction: 0;JMP (1110101010000111) - Unconditional jump
        i_Instruction = 16'hEA87;
        i_ALU_Zero = 0; i_ALU_Neg = 0;
        #10;
        $display("%0t\t%h\tzr=%b ng=%b\tC\t%b\t%b%b%b%b%b%b\t%b%b%b\tLoad=%b Inc=%b (JMP - ALWAYS JUMP)", 
                 $time, i_Instruction, i_ALU_Zero, i_ALU_Neg, o_ALU_Src_Memory,
                 o_ALU_Zero_X, o_ALU_Negate_X, o_ALU_Zero_Y, 
                 o_ALU_Negate_Y, o_ALU_Function, o_ALU_Negate_Out,
                 o_Write_A, o_Write_D, o_Write_Memory,
                 o_PC_Load, o_PC_Inc);
        
        #10;
        $display("\n========== Test completed successfully! ==========\n");
        $finish;
    end

endmodule
