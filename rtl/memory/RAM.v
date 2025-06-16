`ifndef RAM_V
`define RAM_V

module RAM # (parameter DEPTH = 14, WIDTH = 16)(
    input clk,
    input [WIDTH-1:0] in,
    input [DEPTH-1:0] address,
    input load,
    output [WIDTH-1:0] out
);

    reg [WIDTH-1:0] memory [2**DEPTH-1:0];

    always @(posedge clk) begin
        if (load) begin
            memory[address] <= in;
        end
    end

    assign out = memory[address];

endmodule
`endif