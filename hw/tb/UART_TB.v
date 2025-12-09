`timescale 1ns / 1ps
`define CLK_FREQ 50000000

module UART_TB;

    parameter DATA_BITS = 8;
    parameter BAUD_RATE = 9600;
    
    // Calculations for bit timing and clock period
    localparam BIT_PERIOD = 1000000000 / BAUD_RATE;
    localparam CLK_PERIOD = 20;

    reg                     r_CLK;
    reg                     r_RESET_n;
    reg                     r_RX;
    reg                     r_Read_EN;
    wire                    w_UART_Empty; // 1 = Empty, 0 = Data Available
    wire [DATA_BITS-1:0]    w_Data;

    // Instantiate Unit Under Test (UUT)
    UART #(
        .DATA_BITS(DATA_BITS),
        .BAUD_RATE(BAUD_RATE)
    ) uut (
        .i_CLK(r_CLK),
        .i_RESET_n(r_RESET_n),
        .i_RX(r_RX),
        .i_Read_EN(r_Read_EN),
        .o_UART_Empty(w_UART_Empty),
        .o_Data(w_Data)
    );

    // Clock Generation
    always #(CLK_PERIOD/2) r_CLK = ~r_CLK;

    // Task to send a byte (Simulates PC/Putty sending data)
    task UART_WRITE_BYTE;
        input [7:0] i_Data;
        integer     i;
        begin
            r_RX = 1'b0; // Start Bit
            #(BIT_PERIOD);
            for (i=0; i<8; i=i+1) begin
                r_RX = i_Data[i];
                #(BIT_PERIOD);
            end
            r_RX = 1'b1; // Stop Bit
            #(BIT_PERIOD);
        end
    endtask

    initial begin
        $dumpfile("UART_TB.vcd"); 
      $dumpvars(0, UART_TB);
      
        // 1. Initialization
        r_CLK = 0;
        r_RESET_n = 0;
        r_RX = 1;      // UART IDLE state is High
        r_Read_EN = 0;

        // Release Reset
        #(CLK_PERIOD*10);
        r_RESET_n = 1;
        #(CLK_PERIOD*10);

        // Pre-check: FIFO should be empty at the start (Empty = 1)
        if (w_UART_Empty !== 1'b1) begin
            $display("ERROR: FIFO should be empty (1) at start! Got: %b", w_UART_Empty);
            $stop;
        end else begin
            $display("INFO: FIFO initialized correctly (Empty=1).");
        end

        // ----------------------------------------------------------
        // Test 1: Send single byte (0x37) and read it
        // ----------------------------------------------------------
        $display("\nTest 1: Sending 0x37...");
        fork 
            // Process A: Send data via RX line
            begin
                UART_WRITE_BYTE(8'h37);
            end
            
            // Process B: Wait for data and Read
            begin
                // Wait until Empty drops to 0 (meaning Data Arrived!)
                wait(w_UART_Empty == 1'b0);
                $display("Status: Data arrived (Empty flag went to 0).");
                
                // Stabilization
                @(posedge r_CLK); 
                
                // Perform Read (Read Strobe)
                r_Read_EN = 1'b1;
                @(posedge r_CLK);
                r_Read_EN = 1'b0;
                
                // Check Data
                if (w_Data == 8'h37) $display("PASS: Read correct byte 0x37");
                else $display("FAIL: Expected 0x37, got 0x%h", w_Data);
            end
        join

        // Verify FIFO is empty again (1)
        #(CLK_PERIOD*5);
        if (w_UART_Empty == 1'b1) 
            $display("PASS: FIFO is empty again (1).");
        else 
            $display("FAIL: FIFO should be empty (1) after reading, got %b", w_UART_Empty);


        // ----------------------------------------------------------
        // Test 2: Fill FIFO with two bytes (0x55, 0xAA)
        // ----------------------------------------------------------
        #(CLK_PERIOD*20);
        $display("\nTest 2: Sending 0x55 then 0xAA...");
        
        UART_WRITE_BYTE(8'h55);
        UART_WRITE_BYTE(8'hAA);

        // Wait for data availability (Empty=0)
        wait(w_UART_Empty == 1'b0);
        
        // First Read (Should be 0x55)
        @(posedge r_CLK);
        r_Read_EN = 1;
        @(posedge r_CLK);
        r_Read_EN = 0;
        
        if (w_Data == 8'h55) $display("PASS: 1st byte is 0x55");
        
        // Critical Check: More data remains, so Empty must stay 0
        #(CLK_PERIOD);
        if (w_UART_Empty == 1'b0) $display("PASS: Empty flag is still 0 (More data remains).");
        else $display("FAIL: Empty flag jumped to 1 prematurely!");

        // Second Read (Should be 0xAA)
        @(posedge r_CLK);
        r_Read_EN = 1;
        @(posedge r_CLK);
        r_Read_EN = 0;
        
        if (w_Data == 8'hAA) $display("PASS: 2nd byte is 0xAA");

        // Final Check: All read, Empty must go back to 1
        #(CLK_PERIOD*5);
        if (w_UART_Empty == 1'b1) $display("PASS: FIFO is empty (1) now.");
        else $display("FAIL: Flag stuck on 0?");

        $finish;
    end

endmodule