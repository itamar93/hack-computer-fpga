`ifndef COMPUTER_V
`define COMPUTER_V

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
        .wren(slaveSel[0] & memWrite),
        .q(ramOut)
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