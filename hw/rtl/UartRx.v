`ifndef UART_RX_V
`define UART_RX_V

`include "Include.v"

module UartRx #(
    parameter integer DATA_BITS   = 8,
    parameter integer OVERSAMPLE  = 16,  // must be even (for mid-bit sample)
    parameter integer STOP_BITS   = 1    // number of stop bits
)(
    input  wire                  i_CLK,
    input  wire                  i_RESET_n,
    input  wire                  i_RX,
    input  wire                  i_Sample_Tick,  // 1 pulse per oversample clock
    output wire                  o_RX_DV,
    output wire [DATA_BITS-1:0]  o_Rx_Data
);

    // ------------------------------------------------------------------------
    // FSM states
    // ------------------------------------------------------------------------
    localparam [2:0] IDLE    = 3'b000;
    localparam [2:0] START   = 3'b001;
    localparam [2:0] DATA    = 3'b010;
    localparam [2:0] STOP    = 3'b011;
    localparam [2:0] CLEANUP = 3'b100;

    // ------------------------------------------------------------------------
    // Parameters / localparams related to oversampling
    // ------------------------------------------------------------------------
    localparam integer HALF_BIT    = OVERSAMPLE/2;                 // mid-bit
    localparam integer STOP_TICKS  = OVERSAMPLE * STOP_BITS;       // total stop samples
    localparam integer SAMPLE_CNT_BITS = $clog2(STOP_TICKS);

    // ------------------------------------------------------------------------
    // Signal declarations
    // ------------------------------------------------------------------------
    reg [2:0]                     r_SM_Main;
    reg [SAMPLE_CNT_BITS-1:0]     r_Sample_Count;
    reg [DATA_BITS-1:0]           r_Rx_Data;
    reg [$clog2(DATA_BITS)-1:0]   r_Bit_Index;
    reg                           r_RX_DV;

    // RX synchronizer
    reg r_RX_sync_0, r_RX_sync_1;

    wire w_RX = r_RX_sync_1;

    // ------------------------------------------------------------------------
    // Synchronize asynchronous RX input
    // ------------------------------------------------------------------------
    always @(posedge i_CLK or negedge i_RESET_n) begin
        if (~i_RESET_n) begin
            r_RX_sync_0 <= 1'b1;
            r_RX_sync_1 <= 1'b1;
        end else begin
            // 2-FF synchronizer
            r_RX_sync_0 <= i_RX;
            r_RX_sync_1 <= r_RX_sync_0;
        end
    end

    // ------------------------------------------------------------------------
    // Main FSM
    // ------------------------------------------------------------------------
    always @(posedge i_CLK or negedge i_RESET_n) begin
        if (~i_RESET_n) begin
            r_SM_Main      <= IDLE;
            r_Sample_Count <= 0;
            r_Rx_Data      <= 0;
            r_Bit_Index    <= 0;
            r_RX_DV        <= 0;
        end else begin

            case (r_SM_Main)
                // ------------------------------------------------------------
                // IDLE: wait for RX low (start bit), aligned to sample tick
                // ------------------------------------------------------------
                IDLE: begin
                    r_Sample_Count <= 0;
                    r_Bit_Index    <= 0;
                    r_RX_DV        <= 0;
                    if (w_RX == 1'b0) begin
                        r_SM_Main      <= START;
                    end
                end

                // ------------------------------------------------------------
                // START: wait until mid-start-bit and confirm it is still low
                // ------------------------------------------------------------
                START: begin
                    if (i_Sample_Tick) begin
                        if (r_Sample_Count == (HALF_BIT-1)) begin
                            // Sample in the middle of the start bit
                            if (w_RX == 1'b0) begin
                                // Valid start bit
                                r_Sample_Count <= 0;
                                r_Bit_Index    <= 0;
                                r_SM_Main      <= DATA;
                            end else begin
                                // False start, go back to idle
                                r_SM_Main      <= IDLE;
                            end
                        end else begin
                            r_Sample_Count <= r_Sample_Count + 1;
                        end
                    end
                end

                // ------------------------------------------------------------
                // DATA: sample each bit in its middle (every OVERSAMPLE ticks)
                // ------------------------------------------------------------
                DATA: begin
                    if (i_Sample_Tick) begin
                        if (r_Sample_Count == (OVERSAMPLE-1)) begin
                            r_Sample_Count <= 0;

                            // Shift in sampled bit.
                            // NOTE: This preserves your original ordering:
                            //       newest bit into MSB, oldest shifts right.
                            r_Rx_Data <= {w_RX, r_Rx_Data[DATA_BITS-1:1]};

                            if (r_Bit_Index == (DATA_BITS-1)) begin
                                r_SM_Main <= STOP;
                            end else begin
                                r_Bit_Index <= r_Bit_Index + 1;
                            end
                        end else begin
                            r_Sample_Count <= r_Sample_Count + 1;
                        end
                    end
                end

                // ------------------------------------------------------------
                // STOP: wait for STOP_TICKS samples, checking line stays high
                //       (simple framing check at the end)
                // ------------------------------------------------------------
                STOP: begin
                    if (i_Sample_Tick) begin
                        if (r_Sample_Count == (STOP_TICKS-1)) begin
                            // At end of stop period, confirm line is high
                            if (w_RX == 1'b1) begin
                                r_RX_DV   <= 1;  // one clock pulse
                                r_SM_Main <= CLEANUP;
                            end else begin
                                // Framing error: discard byte and go to IDLE
                                r_SM_Main <= IDLE;
                            end
                            r_Sample_Count <= 0;
                        end else begin
                            r_Sample_Count <= r_Sample_Count + 1;
                        end
                    end
                end

                // ------------------------------------------------------------
                // CLEANUP: return to IDLE, r_RX_DV already pulsed this cycle
                // ------------------------------------------------------------
                CLEANUP: begin
                    r_SM_Main <= IDLE;
                    r_RX_DV   <= 0;
                end

                // ------------------------------------------------------------
                // Default: recover to IDLE on illegal state
                // ------------------------------------------------------------
                default: begin
                    r_SM_Main <= IDLE;
                    r_RX_DV   <= 0;
                end
            endcase
        end
    end

    // ------------------------------------------------------------------------
    // Outputs
    // ------------------------------------------------------------------------
    assign o_RX_DV   = r_RX_DV;
    assign o_Rx_Data = r_Rx_Data;

endmodule

`endif
