`ifndef PC_V
`define PC_V

module PC(
    input i_CLK,
    input i_Load,
    input i_Inc,
    input i_RESET_n,
    input [15:0] i_Address,
    output reg [15:0] o_Address
);

    always @(posedge i_CLK or negedge i_RESET_n) begin
        if (~i_RESET_n) o_Address <= 16'b0;
        else if (i_Load) o_Address <= i_Address;
        else if (i_Inc) o_Address <= o_Address + 1;
        else o_Address <= o_Address;
    end

endmodule
`endif 