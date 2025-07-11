`ifndef CPU_V
`define CPU_V

`include "../gates/Mux16.v"
`include "../arithmetic/ALU.v"
`include "../memory/PC.v"
`include "../memory/Register.v"
`include "InstructionDecoder.v"
`include "JmpControlUnit.v"

module CPU(
    input clk,
    input reset,
    input [15:0] instruction,
    input [15:0] inM,
    output [15:0] outM,
    output [15:0] addressM,
    output writeM,
    output [15:0] pc
);

    // == Fetch-Decode stage ==
    wire opcode, aOrM, zX, nX, zY, nY, f, nO;
    wire wA, wD, jL, jE, jG;
    wire [15:0] aRegIn;

    // Instruction Decoder
    InstructionDecoder instDecoder (
        .instruction(instruction),
        .opcode(opcode),
        .aOrM(aOrM),
        .zX(zX),
        .nX(nX),
        .zY(zY),
        .nY(nY),
        .f(f),
        .nO(nO),
        .wA(wA),
        .wD(wD),
        .wM(writeM),
        .jL(jL),
        .jE(jE),
        .jG(jG)
    );

    // Mux16 for A register input selection
    Mux16 aRegInMux (.a(instruction), .b(outM), .sel(opcode), .out(aRegIn));

    // A Register
    Register aReg (
        .clk(clk),
        .in(aRegIn),
        .load(wA),
        .out(addressM)
    );

    // PC (Program Counter)
    PC pc (
        .clk(clk),
        .load(pcLoad),
        .inc(pcInc),
        .reset(reset),
        .in(addressM),
        .out(pc)
    );

    // == Fetch-Decode stage - end ==

    // == Execute stage ==
    wire zR, nG, pcInc, pcLoad;
    wire [15:0] aluInY, aluInX;

    // Mux16 for ALU input selection
    Mux16 aluInYMux (
        .a(addressM),
        .b(inM),
        .sel(aOrM),
        .out(aluInY)
    );

    // ALU
    ALU alu (
        .x(aluInX),
        .y(aluInY),
        .zx(zX),
        .nx(nX),
        .zy(zY),
        .ny(nY),
        .f(f),
        .no(nO),
        .out(outM),
        .zr(zR),
        .ng(nG)
    );

    // D Register
    Register dReg (
        .clk(clk),
        .in(outM),
        .load(wD),
        .out(aluInX)
    );

    // JMP Control Unit
    JmpControlUnit jmpCtrl (
        .zr(zR),
        .ng(nG),
        .jL(jL),
        .jE(jE),
        .jG(jG),
        .pcInc(pcInc),
        .pcLoad(pcLoad)
    );

    // == Execute stage - end ==

endmodule
`endif 
        


