`ifndef MEMORY_V
`define MEMORY_V

module Memory(
    input i_CLK,
    input [15:0] i_Data,
    input [15:0] i_Address,
    input i_Write_EN,
    input i_RESET_n,
    output reg [15:0] o_Data
);
    // ========================================
    // Memory Map Address Ranges
    // ========================================
    // RAM:         0x0000 - 0x3FFF (16KB)
    // Future:      0x4000 - 0x7FFF (available for more peripherals)
    
    // ========================================
    // Address Decode Signals
    // ========================================
    wire w_RAM_Select;
    
    assign w_RAM_Select         = (i_Address[15:14] == 2'b00);  // 0x0000 - 0x3FFF
    
    // ========================================
    // Peripheral Data Buses
    // ========================================
    wire [15:0] w_RAM_Data;
    
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
    // Read Data Multiplexer
    // ========================================
    always @(*) begin
        case(1'b1)
            w_RAM_Select:         o_Data = w_RAM_Data;
            default:              o_Data = 16'h0000;
        endcase
    end

endmodule
`endif
