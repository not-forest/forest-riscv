# RISC-V CPU on FPGA Project

This project involves implementing a RISC-V CPU on an FPGA using Quartus. A 32-bit CPU is based on the RV32I integer instruction set. Future plans include adding extensions and additional features.

### Base Implementation

- [x] **Project Environment**
  - Install Quartus and required FPGA development tools.
  - Configure FPGA development board (Tested on Cyclone IV).
  
- [ ] **Design 32-bit CPU Core**
  - Implement 32-bit program counter.
  - Develop instruction fetch, decode, and execute stages.
  - Implement basic ALU operations.

- [ ] **RV32I Instruction Set**
  - [ ] **Integer Operations**
    - Implement `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL`, `SRA`.
  - [ ] **Branching**
    - Implement `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU`.
  - [ ] **Immediate Operations**
    - Implement `ADDI`, `SLTI`, `SLTIU`, `XORI`, `ORI`, `ANDI`.
  - [ ] **Load and Store**
    - Implement `LB`, `LH`, `LW`, `LBU`, `LHU`, `SB`, `SH`, `SW`.
  - [ ] **Miscellaneous**
    - Implement `JAL`, `JALR`, `ECALL`, `EBREAK`.

- [ ] **Program Memory**
  - Configure ROM to store program code.
  - Implement ROM initialization with sample programs.

### Extensions and Enhancements

- [ ] **Additional RISC-V Extensions**
  - [ ] **M (Multiply/Divide) Extension**
    - Implement `MUL`, `MULH`, `MULHSU`, `MULHU`, `DIV`, `DIVU`, `REM`, `REMU`.
  - [ ] **A (Atomic) Extension**
    - Implement `LR.W`, `SC.W`, `AMOSWAP.W`, `AMOADD.W`, `AMOXOR.W`, `AMOAND.W`, `AMOOR.W`, `AMOMIN.W`, `AMOMAX.W`, `AMOMINU.W`, `AMOMAXU.W`.
  - [ ] **F (Floating-Point) Extension**
    - Implement floating-point operations (if applicable).

- [ ] **I/O and Peripherals**
  - Develop and integrate I/O modules.
  - Implement external memory interfaces (e.g., SDRAM).

- [ ] **Testing and Validation**
  - Develop and run test cases for each instruction.
  - Validate performance and correctness on FPGA.

- [ ] **Documentation and Examples**
  - Write detailed documentation for CPU design and instruction set.
  - Provide examples and tutorials for using the CPU.

## Getting Started

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/riscv-fpga-cpu.git
   cd riscv-fpga-cpu
