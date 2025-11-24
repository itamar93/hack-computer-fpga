`timescale 1ns/1ps

`include "../rtl/arithmetic/Add16.v"
module tb_Add16;

  reg [15:0] a, b, yexpected;
  reg clk;
  wire [15:0] y;

  // Declare variables for test vectors and error counting
  integer vectornum, errors;  
  reg [47:0] testvectors [0:10000]; 

  // Instantiate the Mux16 module
  Add16 uut (
    .a(a),
    .b(b),
    .out(y)
  );

  // Clock generation
  always begin
    clk = 1'b1; #5; clk = 1'b0; #5;
  end

  initial begin
    $display("====================================================");
    $display("Testbench for Add16 started");
    $display("====================================================");

    $readmemh("../testbenches/Add16/test_vectors.tv", testvectors); 
    vectornum = 0; errors = 0;
  end

  always @ (posedge clk) begin
    {a, b, yexpected} = testvectors[vectornum]; 
  end

  always @ (negedge clk) begin
    $display("Test vector %0d: a = %0d, b = %0d, expected y = %0d", vectornum, $signed(a), $signed(b), $signed(yexpected));
    if (y !== yexpected) begin
    $display("Error at vector %0d: expected %0d, got %0d", vectornum, $signed(yexpected), $signed(y));
      errors = errors + 1;
    end else begin
      $display("Test vector %0d passed: got %0d", vectornum, $signed(y));
    end

    vectornum = vectornum + 1;

    if (^testvectors[vectornum] === 1'bx) begin 
      $display("====================================================");
      $display("Testbench for Add16 completed");
      $display("Total errors: %0d", errors);
      $display("====================================================");
      $finish;
    end
  end
endmodule
