`ifndef ROM_V
`define ROM_V

module ROM # (parameter DEPTH = 15, WIDTH = 16)(
    input clk,
    input [DEPTH-1:0] address,
    output [WIDTH-1:0] out
);

    reg [WIDTH-1:0] memory [2**DEPTH-1:0];

    initial begin
        $readmemb("../rtl/memory/rom_data2.bin", memory);
    end

    assign out = memory[address];

endmodule
`endif