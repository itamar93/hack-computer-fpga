`ifndef FIFO_V
`define FIFO_V

module FIFO #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 16
)(
    input                     i_CLK,
    input                     i_RESET_n,
    input  [DATA_WIDTH-1:0]   i_Data,
    input                     i_Write_EN,
    input                     i_Read_EN,
    output                    o_Empty,
    output                    o_Full,
    output reg [DATA_WIDTH-1:0] o_Data
);
    // parameters
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Internal signals
    // storage
    reg [DATA_WIDTH-1:0] r_Mem [0:DEPTH-1];
    // write/read pointers
    reg [ADDR_WIDTH-1:0] r_Write_Ptr;
    reg [ADDR_WIDTH-1:0] r_Read_Ptr;
    // count of elements in the FIFO
    reg [ADDR_WIDTH:0]   r_Count;

    // body
    always @(posedge i_CLK or negedge i_RESET_n) begin
        if (!i_RESET_n) begin
            r_Write_Ptr <= 0;
            r_Read_Ptr  <= 0;
            r_Count     <= 0;
            o_Data      <= 0;
        end else begin
            // WRITE
            if (i_Write_EN && !o_Full) begin
                r_Mem[r_Write_Ptr] <= i_Data;
                r_Write_Ptr        <= r_Write_Ptr + 1'b1;
            end

            // READ
            if (i_Read_EN && !o_Empty) begin
                o_Data      <= r_Mem[r_Read_Ptr];
                r_Read_Ptr  <= r_Read_Ptr + 1'b1;
            end

            // COUNT update logic
            case ({i_Write_EN && !o_Full, i_Read_EN && !o_Empty})
                2'b01: r_Count <= r_Count - 1'b1; // read only
                2'b10: r_Count <= r_Count + 1'b1; // write only
                default: r_Count <= r_Count;      // both or none
            endcase
        end
    end

    assign o_Empty = (r_Count == 0);
    assign o_Full  = (r_Count == DEPTH);

endmodule

`endif
