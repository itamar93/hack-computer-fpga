`ifndef UART_V
`define UART_V

`include "Include.v"

module UART #(
    parameter DATA_BITS   = 8,
    parameter STOP_BITS   = 1,
    parameter BAUD_RATE   = 9600
)(
    input  wire                  i_CLK,
    input  wire                  i_RESET_n,
    input  wire                  i_RX, // from external device
    input  wire                  i_Read_EN, // read enable from CPU
    output wire                  o_UART_Empty, // no data to read from UART
    output wire [DATA_BITS-1:0]  o_Data // data to read from UART
);

    // ------------------------------------------------------------------------
    // Parameters / localparams related to baud rate
    // ------------------------------------------------------------------------
    localparam MOD = `CLK_FREQ / (BAUD_RATE * 16);

    // ------------------------------------------------------------------------
    // internal signals
    wire w_Sample_Tick;
    wire w_RX_DV;
    wire [DATA_BITS-1:0] w_Rx_Data;

    ModMcounter #(
        .MOD(MOD)
    ) mod_m_counter (
        .i_CLK(i_CLK),
        .i_RESET_n(i_RESET_n),
        .o_Max_Tick(w_Sample_Tick),
        .o_Count() // not used
    );

    UartRx #(
        .DATA_BITS(DATA_BITS),
        .OVERSAMPLE(16),
        .STOP_BITS(STOP_BITS)
    ) uart_rx (
        .i_CLK(i_CLK),
        .i_RESET_n(i_RESET_n),
        .i_RX(i_RX),
        .i_Sample_Tick(w_Sample_Tick),
        .o_RX_DV(w_RX_DV),
        .o_Rx_Data(w_Rx_Data)
    );

    FIFO #(
        .DATA_WIDTH(DATA_BITS),
        .DEPTH(16)
    ) fifo (
        .i_CLK(i_CLK),
        .i_RESET_n(i_RESET_n),
        .i_Data(w_Rx_Data),
        .i_Write_EN(w_RX_DV),
        .i_Read_EN(i_Read_EN),
        .o_Empty(o_UART_Empty),
        .o_Full(),
        .o_Data(o_Data)
    );

endmodule
`endif