<h1 align="center">hack-computer-fpga</h1>

<p>
    Hi everyone! In this project I will try to build the HACK computer from <a href="https://www.nand2tetris.org/">Nand2Tetris</a> and run it on real hardware
</p>

---

> **Note:** This project is still a work in progress.

---

## About this Project

This repository aims to implement the HACK computer, a simple yet powerful educational computer architecture introduced in the Nand2Tetris course. The goal is to design the HACK CPU and memory system in Verilog and deploy it on an FPGA, providing a hands-on experience with digital design and computer architecture.

## What is the HACK Computer?

The HACK computer is a 16-bit, von Neumann architecture designed for educational purposes. It features a minimal instruction set and a straightforward hardware design, making it ideal for learning the fundamentals of computer systems from the ground up.

---

## Project Structure

| Folder         | Description                                                                                   |
|----------------|----------------------------------------------------------------------------------------------|
| **rtl**        | Verilog HDL source code for the HACK computer.                                               |
| **testbenches**| Testbenches for verifying the RTL code.                                                      |
| **docs**       | Step-by-step documentation of the project.                                                   |
| **scripts**    | Useful scripts (e.g., `run_testbench.py` for running testbenches from the command line).     |
| **test_fpga**  | Simple implementations of blocks for FPGA testing.                                           |


---

## Table of Contents

- [SetUp Environment](docs/0_SetUp_Environment/README.md)
- [Arithmetics](docs/1_Arithmetic/README.md)