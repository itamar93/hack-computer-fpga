`ifndef REGISTER_V
`define REGISTER_V

module Register(
    input clk,
    input in [15:0],
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