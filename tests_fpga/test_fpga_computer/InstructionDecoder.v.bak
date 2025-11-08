`ifndef INSTRUCTIONDECODER_V
`define INSTRUCTIONDECODER_V

module InstructionDecoder(
    input  [15:0] instruction,
    output        opcode,     // 0 = A-instruction, 1 = C-instruction
    output        aOrM,       // 0 = use A, 1 = use M (for C-instruction only)
    output        zX, nX, zY, nY, f, nO,  // ALU control signals
    output        wA, wD, wM,             // Destination write enables
    output        jL, jE, jG              // Jump bits
);

    assign opcode = instruction[15];

    assign aOrM = opcode ? instruction[12] : 1'b0;

    assign zX = opcode ? instruction[11] : 1'b0;
    assign nX = opcode ? instruction[10] : 1'b0;
    assign zY = opcode ? instruction[9]  : 1'b0;
    assign nY = opcode ? instruction[8]  : 1'b0;
    assign f  = opcode ? instruction[7]  : 1'b0;
    assign nO = opcode ? instruction[6]  : 1'b0;

    assign wA = ~opcode | (opcode & instruction[5]);
    assign wD = opcode ? instruction[4] : 1'b0;
    assign wM = opcode ? instruction[3] : 1'b0;

    assign jL = opcode ? instruction[2] : 1'b0;
    assign jE = opcode ? instruction[1] : 1'b0;
    assign jG = opcode ? instruction[0] : 1'b0;

endmodule
`endif
