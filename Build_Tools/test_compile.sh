#!/bin/bash

# Quick test to verify Verilog compilation and basic functionality
echo "Testing Digital Lock System Compilation..."
echo ""

cd /workspaces/Digital_Lock_System/Build_Tools

# Set up paths
SRC_DIR="../Verilog_Source"

# Clean previous files
rm -f digital_lock_sim digital_lock.vcd

# Compile
iverilog -o digital_lock_sim $SRC_DIR/digital_lock.v $SRC_DIR/digital_lock_tb.v

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful!"
    echo ""
    echo "File structure created:"
    ls -lh *.v *.sh Makefile constraints.xdc PIN_MAPPING.md 2>/dev/null
    echo ""
    echo "✓ Verilog files ready for FPGA synthesis or simulation"
    echo ""
    echo "To run full simulation: make simulate"
    echo "To view waveforms: make wave"
else
    echo "✗ Compilation failed"
    exit 1
fi
