`timescale 1ns / 1ps

module tb_LEDs;

    // Inputs
    reg clk;
    reg [15:0] in;
    reg load;

    // Output
    wire [15:0] out;

    // Instantiate the DUT
    LEDs dut (
        .clk(clk),
        .in(in),
        .load(load),
        .out(out)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        $display("=== Starting LEDs module test ===");

        // Initialize inputs
        clk = 0;
        load = 0;
        in = 16'h0000;

        // Wait one cycle
        #10;

        // Test 1: Load 0x03FF (all lower 10 bits set)
        in = 16'h03FF;
        load = 1;
        #10 load = 0;  // Remove load
        #10;
        $display("Test 1 | in = 0x%04h | out = 0x%04h (expected: 0x03FF)", in, out);

        // Test 2: Load with some upper bits set — should be ignored
        in = 16'hFCFF;  // upper 6 bits are set, lower 10 bits = 0x03FF
        load = 1;
        #10 load = 0;
        #10;
        $display("Test 2 | in = 0x%04h | out = 0x%04h (expected: 0x00FF)", in, out);

        // Test 3: Load 0x0001
        in = 16'h0001;
        load = 1;
        #10 load = 0;
        #10;
        $display("Test 3 | in = 0x%04h | out = 0x%04h (expected: 0x0001)", in, out);

        // Test 4: No load signal — output should stay the same
        in = 16'h03FF;
        load = 0;
        #10;
        $display("Test 4 | in = 0x%04h | out = 0x%04h (expected: 0x0001 - load remains 0)", in, out);

        $display("=== End of test ===");
        $finish;
    end

endmodule
