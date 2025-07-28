`timescale 1ns/1ps

module tb_ROM;
    reg [15:0] address;
    wire [15:0] out;
    
    // crea te a clock signal
    reg clk;

    // Instantiate the ROM module
    ROM dut (
        .clk(clk),
        .address(address),
        .out(out)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        $display("Starting ROM simulation...");
        clk = 0;
        address = 0;

        // Wait for memory to initialize
        #10;

        // Read a few values
        repeat (150) begin
            #10;
            $display("At time %0t, address = %0d => out = %0h", $time, address, out);
            address = address + 1;
        end

        $display("Simulation finished.");
        $finish;
    end
endmodule