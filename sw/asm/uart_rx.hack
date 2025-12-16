// ==============================
// while true:
//   if not UART_STATUS:
//      rx_byte = UART_DATA
//      LEDS <- rx_byte
// ==============================
(LOOP)
@16385 // 0x4001 UART_STATUS
D=M
@READ_BYTE
D;JEQ
@LOOP
0;JMP

(READ_BYTE)
@16386 // 0x4002 UART_DATA
D=M
@16384 // 0x4000 LEDS
M=D
@LOOP
0;JMP