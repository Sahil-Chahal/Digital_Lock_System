# 🔐 Digital Lock System - Verilog Project

A complete hardware-based password security system implemented in Verilog HDL for FPGA deployment.

---

## 📁 Project Structure

```
Digital_Lock_System/
│
├── Verilog_Source/          🔧 VERILOG SOURCE FILES
│   ├── digital_lock.v           Main digital lock module
│   ├── digital_lock_tb.v        Comprehensive testbench
│   └── constraints.xdc          FPGA pin constraints (Basys3)
│
├── Assignment_Submission/   📄 ASSIGNMENT DOCUMENTS
│   ├── Digital_Lock_Assignment_Short.docx  (13-14 pages) ⭐ RECOMMENDED
│   ├── Digital_Lock_Assignment.docx        (25-30 pages)
│   ├── Assignment_Document_Short.md        (Markdown source - short)
│   ├── Assignment_Document.md              (Markdown source - full)
│   ├── ASSIGNMENT_SHORT_README.txt         (Short version guide)
│   └── ASSIGNMENT_README.txt               (Full version guide)
│
├── Documentation/           📚 PROJECT DOCUMENTATION
│   ├── README.md                Complete project guide
│   ├── QUICK_START.md           3-step getting started
│   ├── DIAGRAMS.md              Visual architecture diagrams
│   ├── PIN_MAPPING.md           FPGA hardware connections
│   ├── PROJECT_SUMMARY.md       Project overview
│   ├── INDEX.md                 File navigation guide
│   └── SUBMISSION_GUIDE.md      Assignment submission help
│
├── Build_Tools/             🛠️ BUILD & SIMULATION TOOLS
│   ├── Makefile                 Build automation
│   ├── run_simulation.sh        Interactive simulation
│   ├── test_compile.sh          Quick compilation test
│   └── prepare_assignment.sh    Assignment preparation
│
└── README.md               📖 THIS FILE - Project overview
```

---

## 🚀 Quick Start

### For College Assignment Submission:

1. **Download the Assignment Document:**
   ```
   Go to: Assignment_Submission/
   File: Digital_Lock_Assignment_Short.docx (13-14 pages)
   ```

2. **Open in Microsoft Word and customize:**
   - Add your name and roll number
   - Add college name and logo
   - Review and print

3. **Submit!** ✅

### For Running Simulation:

```bash
# Navigate to Build Tools
cd Build_Tools/

# Run simulation
./run_simulation.sh

# Or use Makefile
make simulate
```

### For FPGA Implementation:

1. Open Vivado/ISE
2. Add files from `Verilog_Source/`
3. Add constraints: `Verilog_Source/constraints.xdc`
4. Synthesize and program

---

## 🎯 Project Features

- ✅ **4-digit password** authentication (default: 1234)
- ✅ **3-attempt limit** with alarm and lockout
- ✅ **7-state FSM** design
- ✅ **Password change** functionality
- ✅ **FPGA-ready** with pin assignments
- ✅ **Fully tested** with comprehensive testbench
- ✅ **Complete documentation** for submission

---

## 📋 System Specifications

| Feature | Value |
|---------|-------|
| Password Length | 4 digits |
| Default Password | 1234 |
| Max Attempts | 3 |
| Alarm Duration | 5 clock cycles |
| Lockout Duration | 10 clock cycles |
| Clock Frequency | 100 MHz |
| Target FPGA | Xilinx Basys3 |
| Resource Usage | < 1% |

---

## 🔧 Working with Different Folders

### Verilog_Source/
**Purpose:** All Verilog HDL source files and FPGA constraints

**Files:**
- `digital_lock.v` - Main module (~220 lines)
- `digital_lock_tb.v` - Testbench (~240 lines)
- `constraints.xdc` - Basys3 pin assignments

**Usage:**
```bash
# View source code
cat Verilog_Source/digital_lock.v

# Copy for FPGA project
cp Verilog_Source/* /path/to/vivado/project/
```

### Assignment_Submission/
**Purpose:** Ready-to-submit assignment documents

**Files:**
- `Digital_Lock_Assignment_Short.docx` ⭐ **USE THIS** (13-14 pages)
- `Digital_Lock_Assignment.docx` (25-30 pages, detailed)

**Usage:**
1. Download the .docx file
2. Open in Microsoft Word
3. Customize with your details
4. Print and submit

### Documentation/
**Purpose:** Complete project documentation and guides

**Key Files:**
- `README.md` - Technical documentation
- `QUICK_START.md` - Getting started guide
- `DIAGRAMS.md` - Visual architecture
- `PIN_MAPPING.md` - Hardware connections

**Usage:**
```bash
# Read documentation
cat Documentation/README.md
cat Documentation/QUICK_START.md
```

### Build_Tools/
**Purpose:** Scripts and tools for compilation and simulation

**Files:**
- `Makefile` - Build automation
- `run_simulation.sh` - Full simulation with waveforms
- `test_compile.sh` - Quick compilation check

**Usage:**
```bash
cd Build_Tools/

# Quick test
./test_compile.sh

# Full simulation
./run_simulation.sh

# Or use make
make compile
make simulate
make wave
make clean
```

---

## 💻 How to Use This Project

### Option 1: College Assignment (Most Common)
```bash
1. Go to Assignment_Submission/
2. Download Digital_Lock_Assignment_Short.docx
3. Open in Word, add your details
4. Submit!
```

### Option 2: Run Simulation
```bash
cd Build_Tools/
./run_simulation.sh
# View waveforms in GTKWave
```

### Option 3: FPGA Implementation
```bash
1. Open Vivado/ISE
2. Create new project
3. Add files from Verilog_Source/
4. Add constraints.xdc
5. Synthesize and program FPGA
```

### Option 4: Study the Code
```bash
# View main module
cat Verilog_Source/digital_lock.v

# View testbench
cat Verilog_Source/digital_lock_tb.v

# Read documentation
cat Documentation/README.md
```

---

## 📊 File Size Reference

| Folder | Files | Total Size |
|--------|-------|------------|
| Verilog_Source | 3 files | ~20 KB |
| Assignment_Submission | 6 files | ~80 KB |
| Documentation | 7 files | ~50 KB |
| Build_Tools | 4 files | ~10 KB |

---

## 🎓 For Students

### What to Submit:
1. **Primary:** `Assignment_Submission/Digital_Lock_Assignment_Short.docx`
2. **Optional CD/USB:**
   - Verilog_Source/ folder (all .v and .xdc files)
   - Documentation/ folder (README files)
   - Build_Tools/ folder (Makefile and scripts)

### What Professors Love:
- ✅ Well-organized folder structure
- ✅ Clean, commented code
- ✅ Professional documentation
- ✅ Working simulation
- ✅ FPGA-ready design

---

## 🔍 Quick Commands

```bash
# Test if everything compiles
cd Build_Tools && ./test_compile.sh

# Run full simulation
cd Build_Tools && ./run_simulation.sh

# View source code
cat Verilog_Source/digital_lock.v

# Read documentation
cat Documentation/QUICK_START.md

# List all files
tree -L 2
```

---

## 📞 Need Help?

1. **For assignment:** Read `Assignment_Submission/ASSIGNMENT_SHORT_README.txt`
2. **For simulation:** Read `Documentation/QUICK_START.md`
3. **For FPGA:** Read `Documentation/PIN_MAPPING.md`
4. **For understanding:** Read `Documentation/DIAGRAMS.md`

---

## ✅ Project Status

- [x] Verilog code complete and tested
- [x] Testbench with 12 test scenarios
- [x] FPGA constraints defined
- [x] Documentation complete
- [x] Assignment documents ready (2 versions)
- [x] Build tools configured
- [x] Organized folder structure
- [x] Ready for submission ✨

---

## 🎉 You're All Set!

This project is **fully organized** and **ready to use**:
- ✅ Assignment ready for download
- ✅ Code ready for simulation
- ✅ FPGA ready for deployment
- ✅ Documentation ready for reference

**Choose your path and get started!** 🚀

---

**Project Type:** Digital Lock System  
**Language:** Verilog HDL  
**Target:** Xilinx Basys3 FPGA  
**Status:** ✅ Complete and Organized  
**Created:** November 15, 2025
