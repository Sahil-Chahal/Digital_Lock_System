# 🔐 Digital Lock System (Verilog Implementation)

A hardware-based password security system implemented in Verilog with wrong-attempt alarm functionality. This digital lock design can be synthesized for FPGA implementation and features password authentication, attempt tracking, and security lockout mechanisms.

## ✨ Features

- **🔑 Password Authentication**: 4-digit password-based access control (default: 1234)
- **🔒 Lockout Mechanism**: Automatically locks after 3 failed attempts
- **🚨 Alarm System**: Triggers alarm output on security breach
- **⚠️ Attempt Tracking**: 2-bit counter displays remaining attempts
- **🔄 Password Management**: Change password mode for updating stored password
- **📊 Status Display**: 7-segment display shows digit count and error states
- **⏳ Timed Lockout**: 5-second alarm + 10-second lockout period
- **🛡️ State Machine**: Robust FSM-based control logic

## 🎯 System Specifications

| Feature | Value |
|---------|-------|
| Default Password | `1234` (16'h1234) |
| Password Length | 4 digits |
| Maximum Attempts | 3 |
| Alarm Duration | 5 clock cycles |
| Lockout Duration | 10 clock cycles |
| Input Width | 4 bits (0-9) |
| Clock Frequency | Configurable (100 MHz recommended) |

## 🔌 Module Interface

### Inputs
- `clk` - System clock signal
- `reset` - Asynchronous reset (active high)
- `key_in[3:0]` - 4-bit keypad input (0-9)
- `key_press` - Key press strobe signal
- `enter` - Enter button to submit password
- `clear` - Clear button to reset entry/lock system
- `change_pwd_mode` - Enable password change mode

### Outputs
- `lock_open` - Lock status (1 = unlocked, 0 = locked)
- `alarm` - Alarm signal (1 = active)
- `attempts_left[1:0]` - Remaining password attempts
- `digit_count[2:0]` - Current digit count (0-4)
- `system_locked` - System lockout status
- `seg_display[6:0]` - 7-segment display output

## 🚀 Getting Started

### Prerequisites

**For Simulation:**
- Icarus Verilog (`iverilog`) - Verilog compiler
- VVP - Verilog simulator
- GTKWave - Waveform viewer (optional)

**For FPGA Implementation:**
- Xilinx Vivado or similar FPGA toolchain
- Target FPGA board (constraints file provided for Basys3)

### Installation

#### Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install iverilog gtkwave
```

#### macOS:
```bash
brew install icarus-verilog gtkwave
```

## 📦 Compilation and Simulation

### Using Make:
```bash
# Compile and simulate
make

# View waveform
make wave

# Clean generated files
make clean
```

### Manual Compilation:
```bash
# Compile
iverilog -o digital_lock_sim digital_lock.v digital_lock_tb.v

# Run simulation
vvp digital_lock_sim

# View waveform
gtkwave digital_lock.vcd
```


## 📖 Usage Guide

### Simulation Operation

The testbench (`digital_lock_tb.v`) automatically runs comprehensive tests:

1. **System Reset** - Initializes all registers and state
2. **Correct Password Test** - Verifies default password (1234) unlocks system
3. **Wrong Attempts** - Tests 3 failed attempts to trigger alarm
4. **Alarm & Lockout** - Verifies timing of alarm and lockout periods
5. **Password Change** - Tests password modification feature
6. **New Password Verification** - Confirms new password works

### Hardware Operation (FPGA)

**Password Entry:**
1. Use switches to set 4-bit digit (0-9)
2. Press `key_press` button to enter digit
3. Repeat for all 4 digits
4. Press `enter` button to submit password

**Status Monitoring:**
- Green LED = Lock Open
- Red LED = Alarm Active
- Yellow LED = System Locked
- 2 LEDs = Attempts Remaining
- 7-Segment Display = Digit Count or Error

**Controls:**
- `reset` button = System reset
- `clear` button = Clear entry or lock system
- `change_pwd_mode` button = Enter password change mode

## 🔧 State Machine Description

The digital lock uses a 7-state FSM:

```
IDLE (000)
  ↓ [key_press]
ENTERING (001)
  ↓ [enter + 4 digits]
CHECKING (010)
  ↓ [correct] → UNLOCKED (011)
  ↓ [wrong & attempts < 3] → IDLE
  ↓ [wrong & attempts == 3] → ALARM_ON (101)
                                ↓ [5 cycles]
                              LOCKED_OUT (100)
                                ↓ [10 cycles]
                              IDLE (reset attempts)

CHANGE_PWD (110) [from UNLOCKED]
  ↓ [enter new password]
IDLE
```

## 🛡️ Security Features

1. **4-Digit Password**: 10,000 possible combinations
2. **Attempt Limitation**: Maximum 3 attempts before lockout
3. **Automatic Lockout**: 10-cycle lockout after alarm
4. **Alarm System**: 5-cycle alarm on breach
5. **Password Change**: Secure password modification
6. **State Protection**: FSM prevents unauthorized transitions

## 📊 Waveform Analysis

After running simulation, view signals in GTKWave:

**Key Signals to Monitor:**
- `clk` - System clock
- `state[2:0]` - Current FSM state
- `digit_count[2:0]` - Password entry progress
- `lock_open` - Lock status output
- `alarm` - Alarm activation
- `attempts_left[1:0]` - Remaining attempts
- `system_locked` - Lockout status

## 🔍 Testing Scenarios

### Test Case 1: Successful Login
- **Input**: 1234 (default password)
- **Expected**: `lock_open = 1`, `attempts_left = 3`
- **Status**: ✅ PASS

### Test Case 2: Single Wrong Attempt
- **Input**: 5678 (wrong password)
- **Expected**: `lock_open = 0`, `attempts_left = 2`
- **Status**: ✅ PASS

### Test Case 3: Maximum Failed Attempts
- **Input**: 3 wrong passwords in succession
- **Expected**: `alarm = 1`, `system_locked = 1`, `attempts_left = 0`
- **Status**: ✅ PASS

### Test Case 4: Password Change
- **Input**: New password 4567 in change mode
- **Expected**: Password updated, old password rejected
- **Status**: ✅ PASS

### Test Case 5: Lockout Recovery
- **Scenario**: Wait through 5-cycle alarm + 10-cycle lockout
- **Expected**: `system_locked = 0`, `attempts_left = 3`
- **Status**: ✅ PASS

## 📝 Module Architecture

### Key Components:

- **State Machine**: 7-state FSM controls all system operations
- **Password Storage**: 16-bit register stores 4-digit password
- **Attempt Counter**: 3-bit counter tracks failed attempts
- **Timer**: 32-bit timer for alarm and lockout durations
- **Digit Entry**: Sequential digit accumulation with shift operation
- **7-Segment Decoder**: Displays digit count and error states

### Register Map:

| Register | Width | Description |
|----------|-------|-------------|
| `stored_password` | 16 bits | Current password |
| `entered_password` | 16 bits | User input buffer |
| `failed_attempts` | 3 bits | Failed attempt counter |
| `timer` | 32 bits | Multi-purpose timer |
| `digit_count` | 3 bits | Entry progress (0-4) |
| `state` | 3 bits | Current FSM state |

## 🔧 FPGA Synthesis

### Synthesis Statistics (Typical):
- **LUTs**: ~150-200
- **Flip-Flops**: ~70-90
- **Max Frequency**: >100 MHz
- **Power**: <50mW (typical)

### Implementation Steps:

1. **Create Vivado Project**
```tcl
create_project digital_lock ./project -part xc7a35tcpg236-1
add_files {digital_lock.v}
set_property top digital_lock [current_fileset]
```

2. **Add Constraints**
```bash
add_files -fileset constrs_1 constraints.xdc
```

3. **Run Synthesis & Implementation**
```tcl
launch_runs synth_1
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
```

4. **Program FPGA**
```bash
program_hw_devices [get_hw_devices xc7a35t_0]
```

## 🚀 Future Enhancements

- [ ] UART interface for remote control
- [ ] Multiple user password support
- [ ] Longer password lengths (configurable)
- [ ] LCD display controller integration
- [ ] Keypad matrix decoder module
- [ ] Access log memory (timestamp tracking)
- [ ] Encrypted password storage
- [ ] Power-on authentication
- [ ] Battery backup for password retention
- [ ] Wireless unlock capability

## 🤝 Contributing

Contributions are welcome! Possible improvements:

- Better debouncing for button inputs
- SPI/I2C interface modules
- Enhanced security features
- Formal verification
- Synthesis optimization
- Additional testbench scenarios

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Author

**Digital Lock System (Verilog Implementation)**
- Hardware description language: Verilog HDR
- Target: FPGA/ASIC implementation
- Educational and practical security application

## 📚 References

- IEEE Standard for Verilog Hardware Description Language
- FPGA synthesis guidelines
- Digital design best practices
- FSM design patterns

## 🙏 Acknowledgments

- Digital design and VLSI community
- Open-source EDA tools (Icarus Verilog, GTKWave)
- FPGA development board manufacturers

---

**⚠️ Security Note**: This is an educational project demonstrating digital lock functionality in hardware. For production security systems, additional measures such as secure password storage, anti-tampering features, and cryptographic authentication should be implemented. The alarm and lockout timings should be adjusted based on your clock frequency for real-time operation.

## 🐛 Error Handling

- Invalid input validation
- Buffer overflow protection
- Password length verification
- Input buffer clearing
- Null input handling

## 🔮 Future Enhancements

- [ ] Multiple user accounts
- [ ] Password encryption (hashing)
- [ ] Log file for access attempts
- [ ] Time-based access control
- [ ] Remote unlock capability
- [ ] Fingerprint integration
- [ ] SMS/Email alerts
- [ ] Battery backup indicator
- [ ] EEPROM password storage (hardware)

## 📜 License

This project is open-source and available for educational purposes.

## 👨‍💻 Author

Digital Lock System - Password-Based Security
Version 1.0

## 🤝 Contributing

Feel free to fork this project and submit pull requests for improvements!

## 📧 Support

For issues or questions, please open an issue in the repository.

---

**⚠️ Note**: This is a demonstration project for educational purposes. For production security systems, implement proper encryption, secure storage, and follow industry security standards.