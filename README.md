<h1 align="center">hack-computer-fpga</h1>

<p>
    Welcome! This project implements the HACK computer from <a href="https://www.nand2tetris.org/">Nand2Tetris</a> on real hardware, with additional enhancements.
</p>

---

> **Note:** This project is a work in progress.

---

## About this Project

This repository contains a Verilog implementation of the HACK computer, targeting the DE10-Lite development board based on the Altera MAX 10 FPGA.

## What is the HACK Computer?

The HACK computer is a simple 16-bit, von Neumann architecture designed for educational use. Its minimal instruction set and straightforward hardware make it ideal for learning computer system fundamentals.

---

## Project Structure

This projects 

| Folder           | Description                                                                                   |
|------------------|----------------------------------------------------------------------------------------------|
| **rtl**          | Verilog HDL source code for the HACK computer.                                               |
| **testbenches**  | Testbenches for verifying the RTL code.                                                      |
| **docs**         | Step-by-step documentation of the project.                                                   |
| **scripts**      | Utility scripts (e.g., `run_testbench.py` for running testbenches from the command line).    |
| **fpga_projects**| RTL code organized for easy import as a Quartus project.                                     |

---

## Table of Contents

- [SetUp Environment](docs/0_SetUp_Environment/README.md)
- [Arithmetics](docs/1_Arithmetic/README.md)
- [Memory](docs/2_Memory/README.md)
- [CPU](docs/3_Cpu/README.md)
- [Computer]
- [Peripherals]
