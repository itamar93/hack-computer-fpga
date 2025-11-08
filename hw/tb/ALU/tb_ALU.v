`timescale 1ns/1ps
`include "../rtl/arithmetic/ALU.v"

module tb_ALU;

    reg [15:0] x, y;
    reg zx, nx, zy, ny, f, no;

    reg expected_zr, expected_ng;
    reg [15:0] expected_out;

    wire [15:0] out;
    wire zr, ng;

    // Declare variables for test vectors and error counting
    integer vectornum, errors;  
    reg [55:0] testvectors [0:10000]; 

    // Instantiate the ALU module
    ALU dut (.x(x), .y(y), .zx(zx), .nx(nx), .zy(zy), .ny(ny), .f(f), .no(no), .out(out), .zr(zr), .ng(ng));
    
    // Clock generation
    reg clk;
    always begin
        clk = 1'b1; #5; clk = 1'b0; #5;
    end

    initial begin
        $display("====================================================");
        $display("Testbench for ALU started");
        $display("====================================================");

        $readmemb("../testbenches/ALU/test_vectors.tv", testvectors); 
        vectornum = 0; errors = 0;
    end

    always @ (posedge clk) begin
        {x, y, zx, nx, zy, ny, f, no, expected_out, expected_zr, expected_ng} = testvectors[vectornum]; 
    end

    always @ (negedge clk) begin
        $display("Test vector %0d: x = %h, y = %h, zx = %b, nx = %b, zy = %b, ny = %b, f = %b, no = %b, expected out = %h, expected zr = %b, expected ng = %b", 
                 vectornum, x, y, zx, nx, zy, ny, f, no, expected_out, expected_zr, expected_ng);
        
        if (out !== expected_out || zr !== expected_zr || ng !== expected_ng) begin
            $display("Error at vector %0d: expected out = %h, got out = %h; expected zr = %b, got zr = %b; expected ng = %b, got ng = %b", 
                     vectornum, expected_out, out, expected_zr, zr, expected_ng, ng);
            errors = errors + 1;
        end else begin
            $display("Test vector %0d passed: got out = %h", vectornum, out);
        end

        vectornum = vectornum + 1;

        if (^testvectors[vectornum] === 1'bx) begin 
            $display("====================================================");
            $display("Testbench for ALU completed");
            $display("Total errors: %0d", errors);
            $display("====================================================");
            $finish;
        end
    end
endmodule