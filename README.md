# ⚡ 5-Stage Pipelined RISC Processor

**Design and Verification of a 32-bit Pipelined RISC Processor using Verilog HDL**

A hardware design project focused on implementing a five-stage pipelined RISC processor, exploring processor microarchitecture, instruction execution, pipeline hazards and RTL verification.

---

## 📌 Project Overview

Modern processors employ instruction pipelining to improve instruction throughput by allowing multiple instructions to occupy different execution stages simultaneously.

This project aims to design and implement a simplified 32-bit RISC processor using **Verilog HDL**, featuring a classic five-stage pipeline architecture.

The processor will incorporate datapath design, control logic, forwarding mechanisms and hazard detection to handle instruction dependencies and execution conflicts.

The design will be progressively developed, simulated and verified before FPGA implementation.

## 🏗️ Architecture

The processor follows a conventional five-stage pipeline:

| Stage | Name | Function |
|:---:|---|---|
| IF | Instruction Fetch | Fetches instructions from instruction memory |
| ID | Instruction Decode | Decodes instructions and reads registers |
| EX | Execute | Performs arithmetic and logical operations |
| MEM | Memory Access | Handles data memory operations |
| WB | Write Back | Writes execution results into registers |

## 🎯 Design Objectives

- Design a modular 32-bit RISC datapath.
- Implement a five-stage instruction pipeline.
- Develop a centralized control unit.
- Implement data forwarding mechanisms.
- Design hazard detection and pipeline stall logic.
- Simulate and verify processor functionality.
- Explore FPGA implementation using the Tang Nano 9K.

## 🔧 Planned Instruction Support

The initial instruction subset includes:

| Category | Instructions |
|---|---|
| Arithmetic | ADD, SUB, ADDI |
| Logical | AND, OR, XOR |
| Memory | LW, SW |
| Branch | BEQ, BNE |

## 🧩 Key Hardware Components

- Arithmetic Logic Unit (ALU)
- Register File
- Instruction Memory
- Data Memory
- Control Unit
- Pipeline Registers
- Forwarding Unit
- Hazard Detection Unit

## 🛠️ Technology Stack

| Tool | Purpose |
|---|---|
| Verilog HDL | RTL design |
| Visual Studio Code | Development environment |
| Icarus Verilog | RTL simulation |
| GTKWave | Waveform analysis |
| Gowin IDE | FPGA synthesis and implementation |
| Tang Nano 9K | FPGA development board |
| Git & GitHub | Version control |

## 📂 Project Structure

```text
5-Stage-Pipelined-RISC-Processor/
│
├── rtl/
│   └── alu/
│       └── alu.v
│
├── testbench/
│   └── alu/
│       └── alu_tb.v
│
├── simulation/
│   └── waveforms/
│       └── alu.vcd
│
├── docs/
├── constraints/
├── README.md
└── .gitignore
```

*Note: The structure represents the intended project organization and will expand as development progresses.*

## 📊 Development Progress

| Milestone | Status |
|---|---|
| Development environment setup | ✅ Completed |
| 32-bit ALU implementation | ✅ Completed |
| ALU testbench | ✅ Completed |
| ALU simulation | ✅ Completed |
| GTKWave waveform verification | ✅ Completed |
| Register File | 🔄 In Progress |
| Control Unit | ⏳ Pending |
| Single-cycle datapath | ⏳ Pending |
| Pipeline implementation | ⏳ Pending |
| Forwarding logic | ⏳ Pending |
| Hazard detection | ⏳ Pending |
| Processor verification | ⏳ Pending |
| FPGA implementation | ⏳ Pending |

## 📈 Future Enhancements

- Branch prediction
- Cache integration
- Performance benchmarking
- Pipeline performance analysis

## 🎓 Learning Outcomes

This project explores:

- Digital design and RTL development
- Processor microarchitecture
- Instruction-level parallelism
- Pipeline data dependencies
- Hazard detection and resolution
- RTL simulation and debugging
- FPGA-based hardware implementation

---

## 👩‍💻 Author

**Mahdiya Rifqua**

B.Tech | Computer Science and Medical Engineering

Interested in RTL Design, Digital Systems, Computer Architecture and FPGA Development.

---

**Project Status:** 🚧 Under Active Development