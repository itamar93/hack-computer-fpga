`timescale 1ns / 1ps

module tb_CPU;

    // Inputs
    reg clk;
    reg reset;
    reg [15:0] instruction;
    reg [15:0] inM;

    // Outputs
    wire [15:0] outM;
    wire [15:0] addressM;
    wire writeM;
    wire [15:0] pc;

    // Instantiate the DUT
    CPU dut (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .inM(inM),
        .outM(outM),
        .addressM(addressM),
        .writeM(writeM),
        .pc(pc)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Instruction ROM
    reg [15:0] rom [0:3];  // 4 instructions for this example
    integer i;

    initial begin
        // Initialize ROM contents
        rom[0] = 16'b0000001010101011;  // @21
        rom[1] = 16'b1110110000010000;  // D=A
        rom[2] = 16'b0100000000000000;  // @0x4000
        rom[3] = 16'b1110001100001000;  // M=D

        // Initialize inputs
        clk = 0;
        reset = 1;
        inM = 16'h0000;
        instruction = 16'h0000;

        $display("=== Starting CPU simulation ===");

        // Release reset after one cycle
        #10 reset = 0;

        // Feed instructions manually, one per clock cycle
        for (i = 0; i < 4; i = i + 1) begin
            instruction = rom[i];
            #10;
            $display("T=%0t | PC=%0d | Inst=0x%04h | outM=0x%04h | addrM=0x%04h | writeM=%b",
                     $time, pc, instruction, outM, addressM, writeM);
        end

        $display("=== End of CPU test ===");
        $finish;
    end

endmodule
