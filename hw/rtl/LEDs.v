`ifndef LEDS_V
`define LEDS_V

module LEDs (
    input i_CLK,
    input [15:0] i_Data,
    input i_Write_EN,
    input i_RESET_n,
    output [15:0] o_Data
);

    reg [9:0] r_LEDS;

    always @(posedge i_CLK or negedge i_RESET_n) begin
        if (!i_RESET_n) r_LEDS <= 10'b0;
        else if (i_Write_EN) begin
            r_LEDS <= i_Data[9:0];          // Load value only when requested
        end
    end

    assign o_Data = {6'b0, r_LEDS};        // Output 16 bits, upper 6 bits are zero

endmodule
`endif
