# Digital Lock System - Pin Mapping and Board Connections

## Pin Assignment for Basys3 FPGA Board

### Clock and Reset
```
CLK (W5)         → System Clock (100 MHz)
BTNC (U18)       → Reset Button (Center)
```

### Input Controls
```
Switches (SW0-SW3) - 4-bit Keypad Input:
  SW0 (V17)      → key_in[0] (LSB)
  SW1 (V16)      → key_in[1]
  SW2 (W16)      → key_in[2]
  SW3 (W17)      → key_in[3] (MSB)

Buttons:
  BTNU (T18)     → key_press
  BTNR (W19)     → enter
  BTND (T17)     → clear
  BTNL (U17)     → change_pwd_mode
```

### Output Indicators
```
LEDs:
  LD0 (U16)      → lock_open (Green LED)
  LD1 (E19)      → alarm (Red LED)
  LD2 (U19)      → system_locked (Yellow LED)
  LD3 (V19)      → attempts_left[0]
  LD4 (W18)      → attempts_left[1]

7-Segment Display (Digit 1):
  CA (W7)        → seg_display[0]
  CB (W6)        → seg_display[1]
  CC (U8)        → seg_display[2]
  CD (V8)        → seg_display[3]
  CE (U5)        → seg_display[4]
  CF (V5)        → seg_display[5]
  CG (U7)        → seg_display[6]
```

## How to Use the System on FPGA

### Password Entry Process:
1. **Enter First Digit**:
   - Set SW0-SW3 to binary value (e.g., 0001 for digit 1)
   - Press BTNU (key_press)
   - 7-segment display shows "1"

2. **Enter Second Digit**:
   - Set SW0-SW3 to binary value (e.g., 0010 for digit 2)
   - Press BTNU (key_press)
   - 7-segment display shows "2"

3. **Enter Third Digit**:
   - Set SW0-SW3 to binary value (e.g., 0011 for digit 3)
   - Press BTNU (key_press)
   - 7-segment display shows "3"

4. **Enter Fourth Digit**:
   - Set SW0-SW3 to binary value (e.g., 0100 for digit 4)
   - Press BTNU (key_press)
   - 7-segment display shows "4"

5. **Submit Password**:
   - Press BTNR (enter)
   - If correct: LD0 (green) lights up
   - If wrong: Check LD3-LD4 for remaining attempts

### Binary to Decimal Conversion:
```
Digit | SW3 | SW2 | SW1 | SW0
------|-----|-----|-----|-----
  0   |  0  |  0  |  0  |  0
  1   |  0  |  0  |  0  |  1
  2   |  0  |  0  |  1  |  0
  3   |  0  |  0  |  1  |  1
  4   |  0  |  1  |  0  |  0
  5   |  0  |  1  |  0  |  1
  6   |  0  |  1  |  1  |  0
  7   |  0  |  1  |  1  |  1
  8   |  1  |  0  |  0  |  0
  9   |  1  |  0  |  0  |  1
```

### LED Status Indicators:
- **LD0 (Green)**: Lock is open
- **LD1 (Red)**: Alarm is active
- **LD2 (Yellow)**: System is locked out
- **LD3-LD4**: Show remaining attempts in binary
  - 11 = 3 attempts
  - 10 = 2 attempts
  - 01 = 1 attempt
  - 00 = 0 attempts (locked)

### 7-Segment Display Codes:
- Shows digit count (0-4) during entry
- Shows "E" (error) during alarm/lockout

### Example: Entering Default Password (1234)
```
Step 1: SW[3:0] = 0001, Press BTNU → Display shows "1"
Step 2: SW[3:0] = 0010, Press BTNU → Display shows "2"
Step 3: SW[3:0] = 0011, Press BTNU → Display shows "3"
Step 4: SW[3:0] = 0100, Press BTNU → Display shows "4"
Step 5: Press BTNR (enter)        → LD0 lights up (success!)
```

### Resetting the System:
- Press BTNC (center button) to reset everything
- OR wait for lockout timer to expire

### Changing Password:
1. Unlock system with current password
2. Press BTNL (change_pwd_mode)
3. Enter new 4-digit password
4. Press BTNR (enter)
5. Password is now changed!

## Connection Diagram (ASCII Art)

```
                    ┌─────────────────────┐
                    │   Basys3 FPGA       │
                    │                     │
    SW3-SW0  ──────►│ key_in[3:0]        │
    BTNU     ──────►│ key_press          │
    BTNR     ──────►│ enter              │
    BTND     ──────►│ clear              │
    BTNL     ──────►│ change_pwd_mode    │
    BTNC     ──────►│ reset              │
                    │                     │
                    │  lock_open      ├──►  LD0 (Green)
                    │  alarm          ├──►  LD1 (Red)
                    │  system_locked  ├──►  LD2 (Yellow)
                    │  attempts[1:0]  ├──►  LD3-LD4
                    │  seg_display[6:0]├──►  7-Seg Display
                    │                     │
                    └─────────────────────┘
```

## External Components (Optional Enhancement)

For a complete physical lock system, you can add:

### Keypad Module (4x4 Matrix)
```
Connect to GPIO Pmod ports:
- 4 Row pins → FPGA outputs
- 4 Column pins → FPGA inputs
- Implement keypad scanning logic
```

### Solenoid Lock
```
FPGA GPIO → Relay Module → 12V Solenoid Lock
- Relay controlled by lock_open signal
- Requires external power supply
```

### Buzzer/Alarm
```
FPGA GPIO → Buzzer/Piezo Speaker
- Connect alarm signal to audio output
- Add transistor driver for higher current
```

### LCD Display (16x2)
```
FPGA Pmod → LCD Display (I2C or Parallel)
- Display password entry
- Show status messages
- Implement LCD controller module
```

## Notes:
- All I/O use LVCMOS33 standard (3.3V logic)
- Add pull-down resistors on button inputs if needed
- Use debouncing logic for mechanical switches
- Ensure proper power supply for external components
