# RISC-V CPU on FPGA

RISC-V CPU implementation written in VHDL. Design is tested on a Cyclone IV FPGA development board. Features a 32-bit CPU based on the RV32I integer instruction set. All vendor-specific modules are signed with '_vendor' suffix.

### Base Implementation

- [x] **Basic 32-bit CPU Core**
  - [x] instruction fetch, decode, and execute stages.
  - [x] all (x0..x31) general purpose registers + pc.
  - [x] basic RV32I ALU operations.

- [ ] **Advanced CPU features**
  - [x] Onboard JTAG CPU debugger.
  - [x] CPU pipeline stages.
  - [ ] Memory mapped I/Os.
  - [ ] Separated memory from CPU core. Program bootloader.
  - [ ] Onboard peripherals, DMA

- [x] **Base Integer RV32I Instruction Set**
  - [x] **Integer Operations**
    - ALU(reg + reg): `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL`, `SRA`.
  - [x] **Immediate Operations**
    - ALU(reg + imm): `ADDI`, `SLTI`, `SLTIU`, `XORI`, `ORI`, `ANDI`.
  - [x] **Branching**
    - Jumps: `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU`.
  - [x] **Load and Store**
    - Memory ops: `LB`, `LH`, `LW`, `LBU`, `LHU`, `SB`, `SH`, `SW`.
  - [x] **Miscellaneous**
    - Miscs: `JAL`, `JALR`, `LUI`, `AUIPC` 
  
- [ ] **Memory Miscellaneous and CSR Operations**
  - [ ] **System Operations**
    - [x] Controll transfer: `ECALL`, `EBREAK`
    - [ ] CSR register operations: `CSR`, `CSRW`, `CSRRW`, `CSRRWI`, `CSRR`, `CSRRW`, `CSRRSI`, `CSRRCI`
    - [ ] Memory Fence: `FENCE`

- [ ] **Program Memory**
  - [x] Temporary ROM to store program code.
  - [x] Program RAM memory for data.
  - [ ] Migrate from huge onchip memory block to caches.
  - [ ] Migrate from static ROM to dynamic program loader.

### Extensions and Enhancements

- [ ] **All additional RISC-V Extensions**
  - [ ] **M (Multiply/Divide) Extension**
    - `MUL`, `MULH`, `MULHSU`, `MULHU`, `DIV`, `DIVU`, `REM`, `REMU`.
  - [ ] **A (Atomic) Extension**
    - `LR.W`, `SC.W`, `AMOSWAP.W`, `AMOADD.W`, `AMOXOR.W`, `AMOAND.W`, `AMOOR.W`, `AMOMIN.W`, `AMOMAX.W`, `AMOMINU.W`, `AMOMAXU.W`.
  - [ ] **D (Double-Precision Floating-Point) Extension**
  - [ ] **Q (Quad-Precision Floating-Point) Extension**
  - [ ] **L (Decimal Floating-Point) Extension**
  - [ ] **F (Floating-Point) Extension**
  - [ ] **C (Compressed Instructions) Extension**
  - [ ] **V (Vector Operations) Extension**
  - [ ] **B (Bit Manipulation) Extension**
  - [ ] **P (Packed SIMD Instructions) Extension**
  - [ ] **J (Dynamically Translated Languages) Extension**
  - [ ] **T (Transactional Memory) Extension**
  - [ ] **N (User Level Interrupts) Extension**

- [ ] **Testing and Validation**
  - [x] JTAG debug from System Console.
  - [x] Test cases for each instruction.
  - [ ] Testing benchmarks for RTLs.
  - [ ] RISC-V architecture compliance suite, benchmarks.

- [ ] **Documentation, API and Examples**
  - [x] RISC-V assembly examples.
  - [x] Tcl debug scripts.
  - [ ] Memory layout linker scripts.
  - [ ] C language projects examples.
  - [ ] Rust language projects examples.
  - [ ] Documentation for CPU design.
  - [ ] Examples and tutorials for using the CPU.

## Getting Started

1. **Clone the Repository**
```bash
	git clone https://github.com/not-forest/forest-riscv.git
    cd riscv-fpga-cpu
```
2. **Install required packages**
    Make sure you have RISC-V [toolchain(https://github.com/riscv-collab/riscv-gnu-toolchain) installed for 32-bit processors.
```bash
	sudo apt install ghdl ghdl-synth gtkwave srec_cat 
```
3. **Simulate the VHDL test benches**
    Use Makefile's `benchmark` entry to compile all VHDL benchmarks located in `src/test_bench` and visualize them in gtkwave.
```bash
    make benchmark BENCH=<tb_name>
```
4. **Compile the source code example project.**
    Use the Makefile to compile your example project. Replace <your_example_name> with the name of the example you want to compile. For more info use `help` command.
```bash
    make EXAMPLE=<your_example_name> FLAGS="-i --intel --foo --bar"
```
5. **Compile the design (Cyclone IV)**
	Project is compatible with Cyclone IV FPGA chip. Pins should be remapped based on your board's configuration. Program the FPGA with obtained `.sof` file.    
6. Hardware Reset
	If your board includes a reset pin, activating it will perform a complete system reset, which includes resetting the onboard debugger. This is useful for troubleshooting and ensuring a fresh start. If your board features four onboard LEDs (LED[3..0]), these can be used to indicate the rising edges of the four segmented clock phases used for CPU pipelining.
7. **System Console debugging**
	Use the onboard JTAG debugger from Quartus' System Console to interact with your CPU by using provided set of Tcl scripts:
```tcl
    % source tcl_scripts/startup.tcl
    Initializing Forest-RiscV CPU debug environment...
    Obtaining service paths. [DONE]
    Obtaining the MM master service path. [DONE]
    Claiming the MM master service. [DONE]
    Initialization [DONE]
    
    Forest-RiscV CPU Debug Environment Usage:
    -----------------------------------------
    1. Tick the CPU for a specified number of cycles:
       Usage: tick [n]
       - [n] (optional): Number of cycles to tick the CPU. Default is 1 cycle.
    2. Print all registers (x0...x31) and the PC register:
       Usage: read_regs
    3. Obtain value of one of 32 general purpoose registers (x0...x31):
       Usage: read_reg [reg_id]
    4. Obtain value of the PC register:
       Usage: read_pc
    5. Dissasembles the oncoming instruction obtained from the program memory. Because
                        CPU is pipelined, the cpu does fetch 4 sequential instructions during it's whole instruction cycle:
       Usage: dissasemble
    6. Do n CPU steps and then print all of the above:
       Usage: step [n]
       - [n] (optional): Number of cycles to tick the CPU. Default is 1 cycle.
    -----------------------------------------
```
