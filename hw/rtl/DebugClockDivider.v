`ifndef DEBUG_CLOCK_DIVIDER_V
`define DEBUG_CLOCK_DIVIDER_V

module DebugClockDivider #(
    parameter DIV = 50_000_000  // 50MHz / 50M = 1Hz
)(
    input i_CLK,
    input i_Debug_CLK_EN,
    output o_CLK
);
    // internal signals
    reg [31:0] r_Counter = 0; // counter for division
    reg r_CLK = 0; // internal clock

    // Clock division logic (only active in debug mode)
    always @(posedge i_CLK) begin
        if (i_Debug_CLK_EN) begin
            if (r_Counter == DIV - 1) begin
                r_CLK <= ~r_CLK;
                r_Counter <= 0;
            end else begin
                r_Counter <= r_Counter + 1;
            end
        end else begin
            r_Counter <= 0;
            r_CLK <= 0;
        end
    end
    
    // Output mux: debug mode uses divided clock, normal mode uses input clock
    assign o_CLK = i_Debug_CLK_EN ? r_CLK : i_CLK;
endmodule

`endif
