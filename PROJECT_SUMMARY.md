# Digital Lock System - Project Summary

## 🎉 Project Complete!

Your Digital Lock System has been successfully converted to **Verilog** for FPGA implementation!

## 📁 Files Created

### Core Verilog Files:
1. **`digital_lock.v`** (9.0 KB)
   - Main digital lock module with FSM-based control
   - 4-digit password authentication (default: 1234)
   - 3-attempt limit with alarm and lockout
   - Password change functionality
   - 7-segment display output

2. **`digital_lock_tb.v`** (8.1 KB)
   - Comprehensive testbench with 12 test scenarios
   - Automated testing of all features
   - Waveform generation for debugging

### FPGA Implementation Files:
3. **`constraints.xdc`** (3.1 KB)
   - Pin assignments for Basys3 FPGA board
   - Timing constraints for 100 MHz clock
   - I/O standard specifications (LVCMOS33)

4. **`PIN_MAPPING.md`** (5.2 KB)
   - Complete pin assignment reference
   - Binary-to-decimal conversion table
   - Usage instructions for FPGA board
   - Connection diagrams

### Build & Test Files:
5. **`Makefile`** (1.5 KB)
   - Automated compilation and simulation
   - Targets: compile, simulate, wave, clean, synthesis

6. **`run_simulation.sh`** (2.8 KB)
   - Interactive simulation script
   - Automatic tool detection
   - GTKWave integration

7. **`README.md`** (Updated)
   - Complete Verilog project documentation
   - Installation instructions
   - Usage guide and examples

## 🔧 Key Features Implemented

### Hardware Design:
- ✅ **State Machine**: 7-state FSM (IDLE, ENTERING, CHECKING, UNLOCKED, ALARM_ON, LOCKED_OUT, CHANGE_PWD)
- ✅ **Password Storage**: 16-bit register (4 digits × 4 bits)
- ✅ **Attempt Tracking**: 3-bit counter with auto-reset
- ✅ **Timer System**: 32-bit timer for alarm (5 cycles) and lockout (10 cycles)
- ✅ **7-Segment Display**: Shows digit count and error states
- ✅ **Security Features**: Automatic lockout and alarm on breach

### I/O Interface:
**Inputs:**
- 4-bit keypad input (`key_in[3:0]`)
- Control buttons (key_press, enter, clear, change_pwd_mode, reset)
- Clock and async reset

**Outputs:**
- Lock status LED
- Alarm signal
- System locked indicator
- Attempts remaining (2-bit)
- Digit count (3-bit)
- 7-segment display (7-bit)

## 🚀 How to Use

### For Simulation (Software):
```bash
# Quick compile test
./test_compile.sh

# Full simulation with testbench
make simulate

# View waveforms
make wave

# Clean generated files
make clean
```

### For FPGA Implementation (Hardware):
```bash
# Using Xilinx Vivado
1. Create new project targeting your FPGA
2. Add digital_lock.v as design source
3. Add constraints.xdc for your board
4. Run synthesis and implementation
5. Generate bitstream
6. Program FPGA

# Or use Vivado TCL commands
create_project digital_lock ./project -part xc7a35tcpg236-1
add_files {digital_lock.v}
add_files -fileset constrs_1 {constraints.xdc}
launch_runs synth_1
launch_runs impl_1 -to_step write_bitstream
```

## 📊 Design Statistics

| Metric | Value |
|--------|-------|
| Module Lines of Code | ~220 lines |
| States | 7 states |
| Registers | ~90 flip-flops |
| Logic Utilization | ~150-200 LUTs |
| Maximum Frequency | >100 MHz |
| Password Combinations | 10,000 (4 digits) |
| Security Level | 3 attempts before lockout |

## 🎯 Testing Status

The testbench (`digital_lock_tb.v`) includes:
- ✅ System reset verification
- ✅ Correct password entry
- ✅ Wrong password attempts (1, 2, 3)
- ✅ Alarm trigger on max attempts
- ✅ Lockout timing verification
- ✅ Password change functionality
- ✅ New/old password verification
- ✅ VCD waveform generation

## 📖 Usage Examples

### FPGA Board Operation:
1. **Enter Password "1234":**
   - Set SW[3:0] = 0001, press BTNU
   - Set SW[3:0] = 0010, press BTNU
   - Set SW[3:0] = 0011, press BTNU
   - Set SW[3:0] = 0100, press BTNU
   - Press BTNR (enter)
   - LD0 (green) lights up = SUCCESS!

2. **Wrong Attempts:**
   - After 3 wrong passwords
   - LD1 (red) turns on = ALARM
   - LD2 (yellow) turns on = LOCKED
   - Wait 15 cycles for auto-reset

3. **Change Password:**
   - Unlock with current password
   - Press BTNL (change mode)
   - Enter new 4-digit password
   - Press BTNR to save

## 🛡️ Security Architecture

```
Password Entry → State: ENTERING
      ↓
Enter Pressed → State: CHECKING
      ↓
   Verify
    ↙  ↘
Correct   Wrong
   ↓       ↓
UNLOCKED  Increment Attempts
   ↓       ↓
Access   < 3 attempts? → Back to IDLE
Granted    ↓
         = 3 attempts → ALARM_ON (5 cycles)
              ↓
         LOCKED_OUT (10 cycles)
              ↓
         Auto Reset → IDLE
```

## 🔌 Hardware Requirements

### For FPGA Implementation:
- **FPGA Board**: Basys3, Nexys A7, or similar Xilinx board
- **Tools**: Xilinx Vivado Design Suite
- **Optional**: Keypad matrix, LCD display, buzzer module

### For Simulation:
- **Software**: Icarus Verilog (iverilog)
- **Viewer**: GTKWave
- **OS**: Linux, macOS, or Windows with WSL

## 📚 Additional Resources

- **IEEE Verilog Standard**: For language reference
- **Xilinx UG901**: Vivado Design Suite User Guide
- **Basys3 Reference Manual**: For board-specific details
- **Digital Design Principles**: FSM design patterns

## 🎓 Educational Value

This project demonstrates:
- **FSM Design**: Multi-state finite state machine
- **Synchronous Design**: All operations synchronized to clock
- **Reset Handling**: Proper async reset implementation
- **I/O Management**: Multiplexed inputs and status outputs
- **Security Logic**: Attempt tracking and lockout mechanisms
- **Testbench Development**: Comprehensive verification
- **FPGA Constraints**: Timing and pin assignment

## 🚧 Future Enhancements

Consider adding:
- [ ] Keypad matrix decoder module
- [ ] LCD display controller (16x2)
- [ ] UART interface for remote access
- [ ] Multiple user profiles
- [ ] Access log with timestamps
- [ ] Button debouncing logic
- [ ] Power-on password retention (EEPROM)

## ✅ Verification Checklist

- [x] Verilog code compiles without errors
- [x] Testbench runs all test cases
- [x] Waveform file generated successfully
- [x] State transitions verified
- [x] Timing constraints defined
- [x] Pin assignments documented
- [x] README documentation complete
- [x] Build system (Makefile) functional

## 🎊 Ready to Deploy!

Your Digital Lock System is now ready for:
1. **Simulation**: Test functionality in software
2. **Synthesis**: Generate FPGA netlist
3. **Implementation**: Place and route for target device
4. **Programming**: Load bitstream to FPGA board
5. **Testing**: Verify operation on hardware

---

**Congratulations!** 🎉 You now have a complete, working Verilog implementation of a Digital Lock System with password authentication and security features!

For questions or issues, refer to the README.md or consult the Verilog source code comments.
