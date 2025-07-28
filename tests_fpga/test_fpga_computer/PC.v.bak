`ifndef PC_V
`define PC_V

module PC(
    input clk, load, inc, reset,
    input [15:0] in,
    output reg [15:0] out
);

    always @(posedge clk) begin
        if (reset) out <= 16'b0;
        else if (load) out <= in;
        else if (inc) out <= out + 1;
        else out <= out;
    end

endmodule
`endif