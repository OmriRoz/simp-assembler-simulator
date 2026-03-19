# SIMP Assembler & Simulator

This project implements a **two-pass assembler** and a **cycle-accurate simulator** for the SIMP instruction set architecture (ISA), developed as part of a computer architecture course.

## Overview

SIMP is a simplified RISC-style processor with:

* 16 registers
* 4096-word memory
* Support for interrupts, I/O devices, and disk operations

This project provides a complete toolchain:

* An assembler that converts `.asm` programs into machine code (`memin.txt`)
* A simulator that executes the machine code cycle-by-cycle and generates detailed output files

## Features

### Assembler

* Two-pass assembler:

  * First pass: label resolution
  * Second pass: instruction encoding
* Supports:

  * Labels and symbolic addressing
  * `.word` directive for memory initialization
  * Signed and hexadecimal immediates
  * Automatic handling of `bigimm` (multi-word instructions)
* Flexible parsing (whitespace, inline labels, comments)

### Simulator

* Full fetch-decode-execute loop
* Supports all SIMP instructions
* Cycle-accurate execution:

  * Single-cycle and multi-cycle instructions (`bigimm`)
* I/O device simulation:

  * LEDs
  * 7-segment display
  * Monitor (256x256 grayscale)
  * Disk (with DMA and interrupts)
* Interrupt handling:

  * `irq0` (timer)
  * `irq1` (disk)
  * `irq2` (external input)

## Project Structure

```
assembler/   - C implementation of the assembler
simulator/   - C implementation of the simulator
tests/       - Assembly test programs and outputs
docs/        - Project specification
```

## Test Programs

The project includes several assembly programs demonstrating different features:

* **factorial** – recursive computation using stack
* **sort** – bubble sort implementation
* **rectangle** – drawing on the monitor
* **disktest** – disk operations using interrupts

## How to Run

### Assemble

```
asm.exe program.asm memin.txt
```

### Simulate

```
sim.exe memin.txt diskin.txt irq2in.txt memout.txt regout.txt trace.txt hwregtrace.txt cycles.txt leds.txt display7seg.txt diskout.txt monitor.txt monitor.yuv
```


## Notes

This project was developed as part of a university course and is shared here for reference and educational purposes.
