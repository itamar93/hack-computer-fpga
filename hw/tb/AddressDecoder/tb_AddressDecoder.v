`timescale 1ns / 1ps

module tb_AddressDecoder;

    // Inputs
    reg [15:0] address;
    reg writeM;

    // Outputs
    wire ram_enable;
    wire leds_enable;
    wire readSelect;

    // DUT instantiation
    AddressDecoder dut (
        .address(address),
        .writeM(writeM),
        .ram_enable(ram_enable),
        .leds_enable(leds_enable),
        .readSelect(readSelect) 
    );

    // Test procedure
    initial begin
        $display("Starting AddressDecoder test...");

        // Default state - writeM low
        writeM = 0;
        address = 16'h0000;
        #10;
        $display("Addr=0x%h, writeM=0 => RAM=%b, LEDS=%b, readSelect=%b", address, ram_enable, leds_enable, readSelect);

        // Write to RAM region (0x0000 - 0x3FFF)
        writeM = 1;
        address = 16'h1234;
        #10;
        $display("Addr=0x%h => RAM=%b, LEDS=%b, readSelect=%b", address, ram_enable, leds_enable, readSelect);

        // Write to LED region (0x4000 - 0x400F)
        address = 16'h4000;
        #10;
        $display("Addr=0x%h => RAM=%b, LEDS=%b, readSelect=%b", address, ram_enable, leds_enable, readSelect);

        // Out of defined range (should not enable anything)
        address = 16'h5000;
        #10;
        $display("Addr=0x%h => RAM=%b, LEDS=%b, readSelect=%b", address, ram_enable, leds_enable, readSelect);

        // LED region upper bound test
        address = 16'h400F;
        #10;
        $display("Addr=0x%h => RAM=%b, LEDS=%b, readSelect=%b", address, ram_enable, leds_enable, readSelect);

        // Just outside LED region
        address = 16'h4010;
        #10;
        $display("Addr=0x%h => RAM=%b, LEDS=%b, readSelect=%b", address, ram_enable, leds_enable, readSelect);

        // RAM region boundary test
        address = 16'h3FFF;
        #10;
        $display("Addr=0x%h => RAM=%b, LEDS=%b, readSelect=%b", address, ram_enable, leds_enable, readSelect);

        // Edge test: writeM off
        writeM = 0;
        address = 16'h4000;
        #10;
        $display("Addr=0x%h, writeM=0 => RAM=%b, LEDS=%b, readSelect=%b", address, ram_enable, leds_enable, readSelect);

        $display("Test completed.");
        $finish;
    end

endmodule
