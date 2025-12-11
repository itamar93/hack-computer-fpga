`ifndef ROM_V
`define ROM_V

`include "Include.v"

module ROM #(
    parameter DEPTH = 2**15, 
    parameter WIDTH = 16
)(
    input i_CLK,
    input [$clog2(DEPTH)-1:0] i_Address,  // 15-bit address for 32K depth
    output reg [WIDTH-1:0] o_Instruction
);
    // Memory array
    reg [WIDTH-1:0] r_Memory [0:DEPTH-1];

    // Initialize ROM with data
    initial begin
        $readmemh(`ROM_DATA_PATH, r_Memory);
    end

    always @(posedge i_CLK) begin
        o_Instruction <= r_Memory[i_Address];
    end

endmodule
`endif