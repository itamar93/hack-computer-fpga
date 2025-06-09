`timescale 1ns/1ps

module tb_Mux16;

  reg [15:0] a, b;
  reg sel;
  wire [15:0] y;

  // Instantiate the Mux16 module
  Mux16 uut (
    .a(a),
    .b(b),
    .sel(sel),
    .y(y)
  );

  $display("Testbench for Mux16 started");
  $display("====================================================");
  