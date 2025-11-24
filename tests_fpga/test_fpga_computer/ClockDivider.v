`ifndef CLOCK_DIVIDER_V
`define CLOCK_DIVIDER_V

module ClockDivider #(
    parameter DIV = 2_000_000  // 50M / 2 = 1 Hz
)(
    input clk_in,
    input reset,
    output reg clk_out
);

    reg [31:0] counter;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == DIV - 1) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

`endif
