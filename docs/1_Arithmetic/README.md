In this unit, I implemented the Arithmetic Logic Unit (ALU) of the HACK computer.  
> The code is located here: [ALU code](../../rtl/arithmetic/ALU.v)

Below is the block diagram along with its interfaces:

![ALU Block Diagram](../img/arithmetics/ALU_block_diagram.png)

The ALU should obey the following truth table:

![ALU Truth Table](../img/arithmetics/ALU_Truth_Table.png)

The design of the ALU can be implemented using the following sub-blocks:

![ALU Internal Design](../img/arithmetics/inside_implementation_ALU.png)

For FPGA efficiency, I did not build the ALU in a purely structural manner as taught in the Nand2Tetris course. Instead, I used a mixed design of structural and behavioral models. In this implementation, I created the 'Mux16' and 'Add16' blocks.

Below is a snippet from the ALU's testbench output with the first test vector marked, along with the corresponding line marked in the truth table:

![ALU testbench](../img/arithmetics/ALU_testbench.png)

![ALU Truth Table first line marked](../img/arithmetics/ALU_Truth_Table_0.png)

[Back to Table Of Contents](./../../README.md)
