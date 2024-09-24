## Global workspace makefile for compiling source files and performing test benchmarks.
##
## Allows to compile any project located within the 'examples' folder for the CPU. Additional flags
## are used for post compilation processing. Allows to run all benchmarks for VHDL CPU design files. 

####### Configuration variables. ########

.PHONY: all clean benchmark

# Directories below hold source files of RISC-V assembly, C and Rust test code and projects. 
EXM_DIR 	:= $(CURDIR)/examples
BUILD_DIR 	:= $(CURDIR)/build
SRC_DIR 	:= $(CURDIR)/src
LD_DIR 		:= $(CURDIR)/linker_scripts
TB_DIR 		:= $(SRC_DIR)/test_bench

# Output file (Will be stored inside the memory).
HEX_FILE 	:= $(BUILD_DIR)/program.hex

# Contains all source files path's in proper order for GHDL compilation
FRISCV_LIB  := $(SRC_DIR)/ord.friscv
GG   		:= ghdl-gcc 

# Toolchain configuration.
PREFIX 		?= riscv32-unknown-elf
# Currently used instruction set.
ISA 		?= rv32i
# Example project to compile.
EXAMPLE 	?= rv32i
# Additional flags for post-compilation: (e.g, --intel, etc.). View help for more details.
FLAGS 		?= ""
# Benchmark file for test.
BENCH 		?= tb_general_reg

EXAMPLE_DIR := $(EXM_DIR)/$(EXAMPLE)

CFLAGS := -march=$(ISA) -RELEASE -mgeneral-regs-only -c -D__KERNEL__ -fno-unwind-tables -Wall -Werror
GG_FLAGS := --ieee=synopsys --workdir=build --work=friscv --std=08

# Checks and compiles the selected project.
all: check $(BUILD_DIR) compile

# Checks if project exists. Also checks for inner makefile.
check:
	@if [ ! -d "$(EXAMPLE_DIR)" ]; then 					\
		echo "Error: Project $(EXAMPLE) does not exist."; 	\
		exit 1; 											\
	fi
	@if [ -f "$(EXAMPLE_DIR)/Makefile" ]; then 						\
		echo "Found Makefile in project: $(EXAMPLE). Entering...";  \
		export CFLAGS; 												\
		$(MAKE) -C $(EXAMPLE_DIR); 									\
		exit 0; 													\
	fi
	@echo "Compiling project: $(EXAMPLE)"

# Compiles all source files within the project directory.
compile: find_src
	@echo "Source files:"
	@for src in $(filter %.s,$(SRC_LIST)); do 									\
		$(PREFIX)-as -march=$(ISA) -o $(BUILD_DIR)/`basename $$src .s`.o $$src; \
	done
	@for src in $(filter %.c,$(SRC_LIST)); do 										\
		$(PREFIX)-gcc -march=$(ISA) -c -o $(BUILD_DIR)/`basename $$src .c`.o $$src; \
	done

	@echo "Creating elf:"
	#$(PREFIX)-ld -o $(BUILD_DIR)/program.elf $(BUILD_DIR)/*.o -T $(LINKER_SCRIPT) --entry=_start
	$(PREFIX)-ld -o $(BUILD_DIR)/program.elf $(BUILD_DIR)/*.o --entry=_start
	@echo "Creating hex:"
	$(PREFIX)-objcopy -O binary $(BUILD_DIR)/program.elf $(BUILD_DIR)/program.bin

	@if echo "$(FLAGS)" | grep -qE -- "--intel|-i"; then 							    \
		echo "Converting to Intel HEX format.\n"										\
		srec_cat $(BUILD_DIR)/program.bin -binary -byte-swap 4 -o $(HEX_FILE) -Intel; 	\
	else 																				\
		cp $(BUILD_DIR)/program.bin $(HEX_FILE); 		     							\
	fi
	@echo "Output file: : $(HEX_FILE), exiting..."

# Locates all assembly and C source files. Rust examples must contain additional makefile.
find_src:
	$(eval SRC_LIST := $(wildcard $(EXAMPLE_DIR)/**/*.s $(EXAMPLE_DIR)/**/*.c $(EXAMPLE_DIR)/*.s $(EXAMPLE_DIR)/*.c))

ghdl_compile:
	@echo "Compiling VHDL main library..."
	@while IFS= read -r file; do				\
		$(GG) -a $(GG_FLAGS) $$file;    \
	done < $(FRISCV_LIB)

# Benchmarks all test benches in the src/test_bench directory
benchmark: $(BUILD_DIR) check_bench ghdl_compile
	@echo "Running benchmarks for test bench: $(BENCH)"
	$(GG) -a $(GG_FLAGS) "$(TB_DIR)/$(BENCH).vhd";
	$(GG) -e $(GG_FLAGS) $(BENCH);
	$(GG) -r $(GG_FLAGS) $(BENCH) --wave="$(BUILD_DIR)/$(BENCH).ghw";
	@echo "Opening in wave viewer..."
	@gtkwave $(BUILD_DIR)/$(BENCH).ghw &

check_bench:
	@if [ ! -d "$(TB_DIR)" ]; then 						\
		echo "Error: No test bench directory found."; 	\
		exit 1; 										\
	fi

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
	@echo "Cleaned..."

help:
	@echo "Makefile Commands:"
	@echo ""
	@echo "		all              - Compile the selected example project."
	@echo "		clean            - Remove build directory and temporary files."
	@echo "		benchmark        - Run benchmarks on all test benches in src/test_bench."
	@echo "		help             - Display this help message."
	@echo ""
	@echo "Available compile flags:"
	@echo "		-i, --intel : Converts output. binary into Intel hex format."
	@echo ""
	@echo "Usage:"
	@echo "  To compile a specific example project:"
	@echo " 	make EXAMPLE=<your_example_name> [FLAGS=\"--f --flags\"]"
	@echo ""
	@echo "  To run benchmarks on test benches:"
	@echo "    	make benchmark"
	@echo ""
	@echo "Notes:"
	@echo "  	- Ensure that all necessary source files are present in the specified example directory."
	@echo "  	- For further information on specific targets, refer to the comments in the Makefile."
