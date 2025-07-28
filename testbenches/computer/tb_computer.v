`timescale 1ns/1ps
`include "../rtl/computer/computer.v"
module tb_computer;

    reg clk;
    reg reset;
    wire [15:0] memOut;
    wire [15:0] instTAP;

    // Instantiate DUT
    computer dut (
        .clk(clk),
        .reset(reset),
        .memOut(memOut),
        .instTAP(instTAP)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Instruction ROM image (preloaded into ROM manually)
    reg [15:0] rom_data [0:3];
    integer i;

    initial begin
        $display("=== Computer LED Test ===");

        // Initialize ROM program:
        // 0: @0x000F         // Load value 0x000F into A
        // 1: D=A             // D = A
        // 2: @0x4000         // Load LED address
        // 3: M=D             // M[0x4000] = D (write to LEDs)

        rom_data[0] = 16'b0000000000001111;  // @0x000F
        rom_data[1] = 16'b1110110000010000;  // D=A
        rom_data[2] = 16'b0100000000000000;  // @0x4000
        rom_data[3] = 16'b1110001100001000;  // M=D

        // Write ROM file for use in ROM.v
        // Adjust path if ROM.v expects it elsewhere
        $writememb("../rtl/memory/rom_data2.bin", rom_data);

        // Start simulation
        clk = 0;
        reset = 1;
        #10 reset = 0;
        // Wait for instructions to execute
        #40;

        // Check result
        $display("Final LED output = 0x%04h (expected 0x000F)", memOut);
        if (memOut === 16'h000F)
            $display("PASS: LEDs updated correctly");
        else
            $display("FAIL: LEDs output mismatch");

        $finish;
    end

endmodule
