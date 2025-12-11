`ifndef MEMORY_V
`define MEMORY_V

module Memory(
    input i_CLK,
    input [15:0] i_Data,
    input [15:0] i_Address,
    input i_Write_EN,
    input i_RESET_n,
    input i_Serial_RX,
    output reg [15:0] o_Data,
    output [9:0] o_LEDS
);
    // ========================================
    // Memory Map Address Ranges
    // ========================================
    // RAM:         0x0000 - 0x3FFF (16KB)
    // LEDs:        0x4000          (1 word)
    // UART_DATA:   0x4001          (read received byte, pops FIFO)
    // UART_STATUS: 0x4002          (bit 0 = empty flag)
    // Future:      0x4003 - 0x7FFF (available for more peripherals)
    
    // ========================================
    // Address Decode Signals
    // ========================================
    wire w_RAM_Select;
    wire w_LED_Select;
    wire w_UART_Data_Select;
    wire w_UART_Status_Select;
    
    assign w_RAM_Select         = (i_Address[15:14] == 2'b00);  // 0x0000 - 0x3FFF
    assign w_LED_Select         = (i_Address == 16'h4000);      // 0x4000
    assign w_UART_Data_Select   = (i_Address == 16'h4001);      // 0x4001
    assign w_UART_Status_Select = (i_Address == 16'h4002);      // 0x4002
    
    // ========================================
    // Peripheral Data Buses
    // ========================================
    wire [15:0] w_RAM_Data;
    wire [15:0] w_LED_Data;
    wire [15:0] w_UART_Data;
    wire [15:0] w_UART_Status;
    
    // ========================================
    // RAM Instance
    // ========================================
    RAM ram (
        .i_CLK(i_CLK),
        .i_RESET_n(i_RESET_n),
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
    // UART Peripheral Instance
    // ========================================
    wire w_UART_Empty;
    wire [7:0] w_UART_Rx_Byte;
    
    UART uart (
        .i_CLK(i_CLK),
        .i_RESET_n(i_RESET_n),
        .i_RX(i_Serial_RX),
        .i_Read_EN(w_UART_Data_Select),
        .o_UART_Empty(w_UART_Empty),
        .o_Data(w_UART_Rx_Byte)
    );
    
    assign w_UART_Data   = {8'b0, w_UART_Rx_Byte};
    assign w_UART_Status = {15'b0, w_UART_Empty};

    // ========================================
    // Read Data Multiplexer
    // ========================================
    always @(*) begin
        case(1'b1)
            w_UART_Data_Select:   o_Data = w_UART_Data;
            w_UART_Status_Select: o_Data = w_UART_Status;
            w_LED_Select:         o_Data = w_LED_Data;
            w_RAM_Select:         o_Data = w_RAM_Data;
            default:              o_Data = 16'h0000;
        endcase
    end

    // ========================================
    // LEDs Output Assignment
    // ========================================
    assign o_LEDS = w_LED_Data[9:0];

endmodule
`endif
