`ifndef MOD_M_COUNTER_V
`define MOD_M_COUNTER_V

module ModMcounter #(
    parameter MOD = 16
)(
    input i_CLK,
    input i_RESET_n,
    output o_Max_Tick,
    output [$clog2(MOD)-1:0] o_Count
);
    // parameters
    localparam COUNT_BITS = $clog2(MOD);
    // signal declarations
    reg [COUNT_BITS-1:0] r_Count;
    wire [COUNT_BITS-1:0] w_Next_Count;

    // body
    always @(posedge i_CLK or negedge i_RESET_n) begin
        if (~i_RESET_n) r_Count <= 0;
        else r_Count <= w_Next_Count;
    end

    // next count logic
    assign w_Next_Count = r_Count == MOD - 1 ? 0 : r_Count + 1;

    // output logic
    assign o_Max_Tick = r_Count == MOD - 1;
    assign o_Count = r_Count;   

endmodule
`endif 