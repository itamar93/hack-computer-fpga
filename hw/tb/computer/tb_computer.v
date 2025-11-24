`timescale 1ns/1ps
`include "../rtl/computer/computer.v"

module tb_computer;

    reg clk;
    reg reset;
    wire [15:0] ledsOut;
    wire [15:0] instTAP;

    // Instantiate the DUT (Device Under Test)
    computer dut (
        .clk(clk),
        .reset(reset),
        .ledsOut(ledsOut),
        .instruction(instTAP)
    );

    // Clock generation: 100 MHz clock (10 ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("=== Computer LED Test ===");

        // Optional: Enable waveform output
        $dumpfile("computer.vcd");
        $dumpvars(0, tb_computer);

        // Apply reset
        reset = 1;
        #20;
        reset = 0;

        // Run the simulation for enough time
        repeat (300) begin
            #10;
            $display("Time %t ns: instTAP: %b ,LEDs = %b", $time, instTAP, ledsOut);
        end

        $finish;
    end

endmodule
