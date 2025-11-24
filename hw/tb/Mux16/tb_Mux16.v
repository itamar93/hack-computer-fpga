`timescale 1ns/1ps

`include "../rtl/gates/Mux16.v"
module tb_Mux16;

  reg [15:0] a, b, yexpected;
  reg sel, clk;
  wire [15:0] y;

  // Declare variables for test vectors and error counting
  integer vectornum, errors;  
  reg [51:0] testvectors [0:10000]; 

  // Instantiate the Mux16 module
  Mux16 uut (
    .a(a),
    .b(b),
    .sel(sel),
    .out(y)
  );

  // Clock generation
  always begin
    clk = 1'b1; #5; clk = 1'b0; #5;
  end

  initial begin
    $display("====================================================");
    $display("Testbench for Mux16 started");
    $display("====================================================");

    $readmemh("../testbenches/Mux16/test_vectors.tv", testvectors); 
    vectornum = 0; errors = 0;
  end

  always @ (posedge clk) begin
    {a, b, sel, yexpected} = {testvectors[vectornum][51:36], testvectors[vectornum][35:20], testvectors[vectornum][16], testvectors[vectornum][15:0]}; 
  end

  always @ (negedge clk) begin
    $display("Test vector %0d: a = %h, b = %h, sel = %b, expected y = %h", vectornum, a, b, sel, yexpected);
    if (y !== yexpected) begin
      $display("Error at vector %0d: expected %h, got %h", vectornum, yexpected, y);
      errors = errors + 1;
    end else begin
      $display("Test vector %0d passed: got %h", vectornum, y);
    end

    vectornum = vectornum + 1;

    if (^testvectors[vectornum] === 1'bx) begin 
      $display("====================================================");
      $display("Testbench for Mux16 completed");
      $display("Total errors: %0d", errors);
      $display("====================================================");
      $finish;
    end
  end
endmodule
