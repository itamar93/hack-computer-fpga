`ifndef REGISTER_V
`define REGISTER_V

module Register(
    input i_CLK,
    input [15:0] i_Data,
    input i_Load,
    output [15:0] o_Data
    );

    reg [15:0] r_Data;

    always @(posedge i_CLK) begin
        if (i_Load) begin
            r_Data <= i_Data;
        end
    end

    assign o_Data = r_Data;

endmodule
`endif 