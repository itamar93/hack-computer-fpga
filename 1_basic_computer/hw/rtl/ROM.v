`ifndef ROM_V
`define ROM_V

`include "Include.v"

module ROM #(
    parameter DEPTH = 2**15, 
    parameter WIDTH = 16
)(
    input [$clog2(DEPTH)-1:0] i_Address,  // 15-bit address for 32K depth
    output [WIDTH-1:0] o_Instruction
);
    // Memory array
    reg [WIDTH-1:0] r_Memory [0:DEPTH-1];

    // Initialize ROM with data
    initial begin
        $readmemh(`ROM_DATA_PATH, r_Memory);
    end

    // async read
    assign o_Instruction = r_Memory[i_Address];

endmodule
`endif