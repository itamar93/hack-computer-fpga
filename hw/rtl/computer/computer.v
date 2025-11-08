`ifndef COMPUTER_V
`define COMPUTER_V

`include "../cpu/CPU.v"
`include "../memory/ROM.v"
`include "../memory/RAM.v"
`include "AddressDecoder.v"
`include "../peripherals/LEDs.v"
`include "../gates/Mux16.v"
`include "ClockDivider.v"

module computer(
    input clk,
    input reset,
	output [15:0] ledsOut,
    output [15:0] instruction
);
    
    // internal signals
    //wire [15:0] instruction;
    wire [15:0] memIn;
    wire [15:0] memOut;
    wire [15:0] memAddress;
    wire memWrite, clk_out;
    wire [15:0] pc;
    wire [15:0] ramOut;
    wire [15:0] outMemMux1;
    wire [2:0] slaveSel;
    wire slowClk;

    // Clock Divider
    ClockDivider inner_clk (
        .clk_in(clk),
        .reset(reset),
        .clk_out(slowClk)
    );

    // Clock Output Mux
    assign clk_out = 1'b1 ? clk : slowClk;


    // ROM
    ROM rom (
        .clk(clk_out),
        .address(pc),
        .out(instruction)
    );

    // CPU
    CPU cpu (
        .clk(clk_out),
        .reset(reset),
        .instruction(instruction),
        .inM(memOut),
        .outM(memIn),
        .addressM(memAddress),
        .writeM(memWrite),
        .pc(pc)
    );

    // Address Decoder 
    AddressDecoder addrDecoder (
        .address(memAddress),
        .slaveSel(slaveSel)
    );

    // RAM
    RAM ram (
        .clk(clk_out),
        .address(memAddress[13:0]),
        .in(memIn),
        .load(~slaveSel[0] & memWrite),
        .out(ramOut)
    );

    // LEDs
    LEDs leds (
        .clk(clk_out),
        .in(memIn),
		.reset(reset),
        .load(slaveSel[1] & memWrite),
        .out(ledsOut)  
    );

    // Memory Output Mux
    Mux16 memMux1 (
        .a(ramOut),
        .b(ledsOut),
        .sel(slaveSel[1]),
        .out(outMemMux1)
    );
	 
    Mux16 memMux2 (
        .a(outMemMux1),
        .b(16'h0000),
        .sel(slaveSel[2]),
        .out(memOut)
    );

endmodule
`endif 