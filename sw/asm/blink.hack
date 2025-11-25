(LOOP)
    @10 // LEDS 00000_01010
    D=A
    @16384 //0x4000 LEDS addess
    M=D
    @21 // LEDS 00000_10101
    D=A
    @16384 //0x4000 LEDS addess
    M=D
    @LOOP
    0;JMP