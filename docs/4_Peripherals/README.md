# Peripherals & Memory-Mapped I/O

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    HackComputer                          │
│  ┌─────────┐    ┌─────┐    ┌──────────────────────────┐ │
│  │   ROM   │───▶│ CPU │◀──▶│        Memory.v          │ │
│  └─────────┘    └─────┘    │  ┌─────┐ ┌─────┐ ┌─────┐ │ │
│                            │  │ RAM │ │LEDs │ │UART │ │ │
│                            │  └─────┘ └─────┘ └─────┘ │ │
│                            └──────────────────────────┘ │
│                                           ▲             │
│                                      i_Serial_RX        │
└─────────────────────────────────────────────────────────┘
```

## Memory Map

| Address | Peripheral | Access | Description |
|---------|------------|--------|-------------|
| `0x0000 - 0x3FFF` | RAM | R/W | 16KB data memory |
| `0x4000` | LEDs | R/W | LED output register (bits 9:0) |
| `0x4001` | UART_DATA | R | Read received byte (pops FIFO) |
| `0x4002` | UART_STATUS | R | Bit 0 = empty flag (1 = no data) |

## How MMIO Works

The CPU accesses peripherals exactly like RAM - using `@address` and `M=` / `=M` operations. The `Memory.v` module decodes the address and routes reads/writes to the appropriate peripheral.

```verilog
// Address decoding in Memory.v
assign w_RAM_Select         = (i_Address[15:14] == 2'b00);  // 0x0000 - 0x3FFF
assign w_LED_Select         = (i_Address == 16'h4000);
assign w_UART_Data_Select   = (i_Address == 16'h4001);
assign w_UART_Status_Select = (i_Address == 16'h4002);
```

## Example: UART Read

```asm
// Wait for UART data
(WAIT)
@16386      // 0x4002 = UART_STATUS
D=M
@WAIT
D;JNE       // Loop while empty

// Read byte and display on LEDs
@16385      // 0x4001 = UART_DATA
D=M
@16384      // 0x4000 = LEDs
M=D
```

