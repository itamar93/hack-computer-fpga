`ifndef RAM_V
`define RAM_V

module RAM # (
    parameter DEPTH = 2**14, 
    parameter WIDTH = 16
)(
    input i_CLK,
    input i_RESET_n,
    input [WIDTH-1:0] i_Data,
    input [$clog2(DEPTH)-1:0] i_Address,
    input i_Write_EN,
    output reg [WIDTH-1:0] o_Data
);

    // Memory array
    reg [WIDTH-1:0] r_Data [0:DEPTH-1];

    always @(posedge i_CLK) begin
        if (!i_RESET_n) begin
            r_Data <= 0;
        end else begin
            if (i_Write_EN) begin
                r_Data[i_Address] <= i_Data;
            end
            o_Data <= r_Data[i_Address];
        end
    end

endmodule
`endif