# Makefile for Digital Lock System Verilog Project

# Verilog compiler (Icarus Verilog)
VERILOG = iverilog
# Verilog simulator
VVP = vvp
# Waveform viewer
GTKWAVE = gtkwave

# Source files
SRC = digital_lock.v
TB = digital_lock_tb.v
OUTPUT = digital_lock_sim
VCD = digital_lock.vcd

# Default target
all: compile simulate

# Compile Verilog files
compile:
	@echo "Compiling Verilog files..."
	$(VERILOG) -o $(OUTPUT) $(SRC) $(TB)
	@echo "Compilation complete!"

# Run simulation
simulate: compile
	@echo "Running simulation..."
	$(VVP) $(OUTPUT)
	@echo "Simulation complete!"

# View waveform
wave: simulate
	@echo "Opening waveform viewer..."
	$(GTKWAVE) $(VCD)

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	rm -f $(OUTPUT) $(VCD)
	@echo "Clean complete!"

# Synthesis (if you have yosys)
synthesis:
	@echo "Running synthesis..."
	yosys -p "read_verilog $(SRC); synth -top digital_lock; write_verilog digital_lock_synth.v"
	@echo "Synthesis complete!"

# Help
help:
	@echo "Digital Lock System Makefile"
	@echo "Available targets:"
	@echo "  make          - Compile and simulate"
	@echo "  make compile  - Compile Verilog files"
	@echo "  make simulate - Run simulation"
	@echo "  make wave     - View waveform in GTKWave"
	@echo "  make clean    - Remove generated files"
	@echo "  make synthesis- Synthesize design (requires yosys)"
	@echo "  make help     - Show this help message"

.PHONY: all compile simulate wave clean synthesis help
