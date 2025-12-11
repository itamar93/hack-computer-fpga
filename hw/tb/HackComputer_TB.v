`timescale 1ns/1ps

module HackComputer_TB;

    // ------------------------------------------------------------------------
    // Parameters – ADJUST CLKS_PER_BIT TO MATCH YOUR BAUD GENERATOR
    // ------------------------------------------------------------------------
    localparam integer CLK_PERIOD   = 20;   
    localparam integer CLKS_PER_BIT = 50_000_000 / (16*9600);   // <-- Replace with your real value

    // ------------------------------------------------------------------------
    // DUT interface
    // ------------------------------------------------------------------------
    reg  r_CLK;
    reg  r_RESET_n;
    reg  r_Serial_RX;
    wire [9:0] w_LEDS;

    HackComputer uut (
        .i_CLK      (r_CLK),
        .i_RESET_n  (r_RESET_n),
        .o_LEDS     (w_LEDS),
        .i_Serial_RX(r_Serial_RX)
    );

    // ------------------------------------------------------------------------
    // Clock generation
    // ------------------------------------------------------------------------
    always #(CLK_PERIOD/2) r_CLK = ~r_CLK;

    // ------------------------------------------------------------------------
    // Simple UART TX task (from TB to DUT RX)
    // ------------------------------------------------------------------------
    task UART_WRITE_BYTE(input [7:0] i_Data);
        integer i;
        begin
            // Start bit
            r_Serial_RX <= 1'b0;
            repeat (CLKS_PER_BIT) @(posedge r_CLK);

            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                r_Serial_RX <= i_Data[i];
                repeat (CLKS_PER_BIT) @(posedge r_CLK);
            end

            // Stop bit (at least 1 bit)
            r_Serial_RX <= 1'b1;
            repeat (CLKS_PER_BIT) @(posedge r_CLK);
        end
    endtask

    // ------------------------------------------------------------------------
    // Reset + main stimulus
    // ------------------------------------------------------------------------
    initial begin
        r_CLK       = 1'b0;
        r_RESET_n   = 1'b1;
        r_Serial_RX = 1'b1;   // idle line

        // Apply reset
        #(CLK_PERIOD*10);
        r_RESET_n = 1'b0;
        #(CLK_PERIOD*10);
        r_RESET_n = 1'b1;

        // --------------------------------------------------------------------
        // Let the Hack boot and reach "wait for UART" point
        // --------------------------------------------------------------------
        // You can tune this depending on your ROM program length
        repeat (2000) @(posedge r_CLK);

        // --------------------------------------------------------------------
        // Send some UART bytes as if coming from PC
        // --------------------------------------------------------------------
        $display("[%0t] Sending 'A' (0x41) over UART", $time);
        UART_WRITE_BYTE(8'h41);  // 'A'

        repeat (500) @(posedge r_CLK);

        $display("[%0t] Sending 'B' (0x42) over UART", $time);
        UART_WRITE_BYTE(8'h42);  // 'B'

        repeat (500) @(posedge r_CLK);

        $display("[%0t] Sending 0x0D (CR)", $time);
        UART_WRITE_BYTE(8'h0D);  // e.g. Enter / command terminator

        // Let the HackReact to the data
        repeat (5000) @(posedge r_CLK);

        $display("[%0t] Simulation finished", $time);
        $finish;
    end

    // ------------------------------------------------------------------------
    // VCD dump
    // ------------------------------------------------------------------------
    initial begin
        $display("=== Starting Hack Computer simulation ===");
        $dumpfile("HackComputer_TB.vcd");
        $dumpvars(0, HackComputer_TB);
    end

endmodule
