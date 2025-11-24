`ifndef LEDS_V
`define LEDS_V

module LEDs (
    input clk,
    input [15:0] in,
    input load, reset,
    output [15:0] out
);

    reg [9:0] leds;

    always @(posedge clk or posedge reset) begin
			if (reset) leds <= 10'b0;
			else if (load) begin
				leds <= in[9:0];          // ← Load value only when requested
			end
    end

    assign out = {6'b0, leds};        // Output 16 bits, upper 6 bits are zero

endmodule
`endif
