#!/bin/bash

# Digital Lock System - Quick Start Script
# This script compiles and runs the Verilog simulation

echo "╔════════════════════════════════════════════╗"
echo "║  Digital Lock System - Verilog Simulation ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Check if iverilog is installed
if ! command -v iverilog &> /dev/null
then
    echo "❌ Error: Icarus Verilog (iverilog) is not installed"
    echo ""
    echo "To install on Ubuntu/Debian:"
    echo "  sudo apt-get install iverilog gtkwave"
    echo ""
    echo "To install on macOS:"
    echo "  brew install icarus-verilog gtkwave"
    echo ""
    exit 1
fi

echo "✓ Icarus Verilog found"
echo ""

# Clean previous build
if [ -f digital_lock_sim ]; then
    echo "🧹 Cleaning previous build..."
    rm -f digital_lock_sim digital_lock.vcd
fi

# Compile
echo "🔧 Compiling Verilog files..."
iverilog -o digital_lock_sim digital_lock.v digital_lock_tb.v

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
    echo ""
else
    echo "❌ Compilation failed"
    exit 1
fi

# Run simulation
echo "🚀 Running simulation..."
echo "════════════════════════════════════════════"
echo ""
vvp digital_lock_sim

if [ $? -eq 0 ]; then
    echo ""
    echo "════════════════════════════════════════════"
    echo "✓ Simulation completed successfully"
    echo ""
    
    # Check if waveform file was generated
    if [ -f digital_lock.vcd ]; then
        echo "📊 Waveform file generated: digital_lock.vcd"
        
        # Ask if user wants to view waveform
        if command -v gtkwave &> /dev/null; then
            echo ""
            read -p "Would you like to view the waveform? (y/n): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "🔍 Opening GTKWave..."
                gtkwave digital_lock.vcd &
            fi
        else
            echo "💡 Install GTKWave to view waveforms: sudo apt-get install gtkwave"
        fi
    fi
else
    echo "❌ Simulation failed"
    exit 1
fi

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║              All Done! 🎉                  ║"
echo "╚════════════════════════════════════════════╝"
