`timescale 1ns/1ps

module tb_InstructionDecoder;

  reg [15:0] instruction;
  wire opcode, aOrM, zX, nX, zY, nY, f, nO, wA, wD, wM, jL, jE, jG;