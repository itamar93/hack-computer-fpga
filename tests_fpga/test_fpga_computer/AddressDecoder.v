`ifndef ADDRESSDECODER_V
`define ADDRESSDECODER_V

module AddressDecoder(
    input [15:0] address,
    output reg [1:0] slaveSel
);

    always @(*) begin
        // Default values
        slaveSel = 2'b10;

        // Determine readSelect based on address
        casez (address)
            16'b00??????????????: slaveSel = 2'b00;      // 0x0000 - 0x3FFF
            16'h4000: slaveSel = 2'b01;     // 0x4000
            default: ; // Defaults already set above
        endcase
    end
	 
endmodule
`endif