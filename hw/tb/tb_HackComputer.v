module tb_HackComputer;

    reg r_CLK;
    reg r_RESET_n;
    wire [9:0] w_LEDS;

    HackComputer uut (
        .i_CLK(r_CLK),
        .i_RESET_n(r_RESET_n),
        .i_Debug_CLK_EN(1'b1),
        .o_LEDS(w_LEDS)
    );

    initial begin
        r_CLK = 0;
        r_RESET_n = 1;
        #10;
        r_RESET_n = 0;
        #20;
        r_RESET_n = 1;
    end

    always #5 r_CLK = ~r_CLK;

    initial begin   
        $display("=== Starting Hack Computer simulation ===");
        $dumpfile("tb_HackComputer.vcd");
        $dumpvars(0, tb_HackComputer);
        #1000;
        $finish;
    end

endmodule