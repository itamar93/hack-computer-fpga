`ifndef COMPUTER_V
`define COMPUTER_V

`include "CPU.v"
`include "ROM.v"
`include "RAM.v"
`include "AddressDecoder.v"
`include "LEDs.v"
`include "Mux16.v"

module computer(
    input clk,
    input reset,
	 output [9:0] ledsOut
);
    
    // internal signals
    wire [15:0] instruction;
    wire [15:0] memIn;
    wire [15:0] memOut;
    wire [15:0] memAddress;
    wire memWrite, clk_out;
    wire [15:0] pc;
    wire [15:0] ramOut;
	 wire [15:0] outMemMux1;
	 wire [1:0] slaveSel;
	 
	 // Clock Divider
	 ClockDivider inner_clk (
			.clk_in(clk),
			.reset(reset),
			.clk_out(clk_out)
	 );


    // ROM
    ROM2 rom (
        .clock(clk_out),
        .address(pc),
        .q(instruction)
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
        .clock(clk_out),
        .address(memAddress[13:0]),
        .data(memIn),
        .wren(~slaveSel & memWrite),
        .q(ramOut)
    );

    // LEDs
    LEDs leds (
        .clk(clk_out),
        .in(memIn),
		  .reset(reset),
        .load(slaveSel & memWrite),
        .out(ledsOut)  
    );

    // Memory Output Mux
    Mux16 memMux1 (
        .a(ramOut),
        .b(ledsOut),
        .sel(slaveSel[0]),
        .out(outMemMux1)
    );
	 
    Mux16 memMux2 (
        .a(outMemMux1),
        .b(16'h0000),
        .sel(slaveSel[1]),
        .out(memOut)
    );

endmodule
`endif 