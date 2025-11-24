`ifndef MEMORY_V
`define MEMORY_V

module Memory(
    input i_CLK,
    input [15:0] i_Data,
    input [15:0] i_Address,
    input i_Write_EN,
    input i_RESET_n,
    output reg [15:0] o_Data,
    output [9:0] o_LEDS
);
    // ========================================
    // Memory Map Address Ranges
    // ========================================
    // RAM:     0x0000 - 0x3FFF (16KB)
    // LEDs:    0x4000          (1 word)
    // Future:  0x4001 - 0x7FFF (available for more peripherals)
    
    // ========================================
    // Address Decode Signals
    // ========================================
    wire w_RAM_Select;
    wire w_LED_Select;
    // Add more select signals here for future peripherals
    
    assign w_RAM_Select = (i_Address[15:14] == 2'b00);  // 0x0000 - 0x3FFF
    assign w_LED_Select = (i_Address == 16'h4000);      // 0x4000
    
    // ========================================
    // Peripheral Data Buses
    // ========================================
    wire [15:0] w_RAM_Data;
    wire [15:0] w_LED_Data;
    // Add more data wires here for future peripherals
    
    // ========================================
    // RAM Instance
    // ========================================
    RAM ram (
        .i_CLK(i_CLK),
        .i_Data(i_Data),
        .i_Address(i_Address[13:0]),
        .i_Write_EN(w_RAM_Select & i_Write_EN),
        .o_Data(w_RAM_Data)
    );

    // ========================================
    // LEDs Peripheral Instance
    // ========================================
    LEDs leds (
        .i_CLK(i_CLK),
        .i_Data(i_Data),
        .i_Write_EN(w_LED_Select & i_Write_EN),
        .i_RESET_n(i_RESET_n),
        .o_Data(w_LED_Data)
    );

    // ========================================
    // Add More Peripheral Instances Here
    // ========================================
    // Example for future peripheral:
    // UART uart (
    //     .i_CLK(i_CLK),
    //     .i_Data(i_Data),
    //     .i_Write_EN(w_UART_Select & i_Write_EN),
    //     .i_RESET_n(i_RESET_n),
    //     .o_Data(w_UART_Data)
    // );

    // ========================================
    // Read Data Multiplexer
    // ========================================
    // Use always block with case for scalability
    always @(*) begin
        case(1'b1)
            w_LED_Select: o_Data = w_LED_Data;
            w_RAM_Select: o_Data = w_RAM_Data;
            // Add more cases here for future peripherals
            // w_UART_Select: o_Data = w_UART_Data;
            // w_SPI_Select:  o_Data = w_SPI_Data;
            default:      o_Data = 16'h0000;  // Return 0 for unmapped addresses
        endcase
    end

    // ========================================
    // LEDs Output Assignment
    // ========================================
    assign o_LEDS = w_LED_Data[9:0];

endmodule
`endif