`ifndef REGISTER_V
`define REGISTER_V

module Register(
    input clk,
    input [15:0] in,
    input load,
    output [15:0] out);

    reg [15:0] value;

    always @(posedge clk) begin
        if (load) begin
            value <= in;
        end
    end

    assign out = value;

endmodule
`endif 