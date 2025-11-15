# Constraints file for Digital Lock System
# This file is for FPGA implementation (Xilinx)

# Clock constraint (100 MHz)
create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]

# Input delays
set_input_delay -clock clk 2.0 [get_ports {key_in[*]}]
set_input_delay -clock clk 2.0 [get_ports key_press]
set_input_delay -clock clk 2.0 [get_ports enter]
set_input_delay -clock clk 2.0 [get_ports clear]
set_input_delay -clock clk 2.0 [get_ports change_pwd_mode]
set_input_delay -clock clk 2.0 [get_ports reset]

# Output delays
set_output_delay -clock clk 2.0 [get_ports lock_open]
set_output_delay -clock clk 2.0 [get_ports alarm]
set_output_delay -clock clk 2.0 [get_ports {attempts_left[*]}]
set_output_delay -clock clk 2.0 [get_ports {digit_count[*]}]
set_output_delay -clock clk 2.0 [get_ports system_locked]
set_output_delay -clock clk 2.0 [get_ports {seg_display[*]}]

# Pin assignments (example for Basys3 board)
# Clock
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Reset button (center button)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# Key inputs (switches)
set_property PACKAGE_PIN V17 [get_ports {key_in[0]}]
set_property PACKAGE_PIN V16 [get_ports {key_in[1]}]
set_property PACKAGE_PIN W16 [get_ports {key_in[2]}]
set_property PACKAGE_PIN W17 [get_ports {key_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_in[*]}]

# Control buttons
set_property PACKAGE_PIN T18 [get_ports key_press]
set_property PACKAGE_PIN W19 [get_ports enter]
set_property PACKAGE_PIN T17 [get_ports clear]
set_property PACKAGE_PIN U17 [get_ports change_pwd_mode]
set_property IOSTANDARD LVCMOS33 [get_ports key_press]
set_property IOSTANDARD LVCMOS33 [get_ports enter]
set_property IOSTANDARD LVCMOS33 [get_ports clear]
set_property IOSTANDARD LVCMOS33 [get_ports change_pwd_mode]

# LEDs (outputs)
set_property PACKAGE_PIN U16 [get_ports lock_open]
set_property PACKAGE_PIN E19 [get_ports alarm]
set_property PACKAGE_PIN U19 [get_ports system_locked]
set_property IOSTANDARD LVCMOS33 [get_ports lock_open]
set_property IOSTANDARD LVCMOS33 [get_ports alarm]
set_property IOSTANDARD LVCMOS33 [get_ports system_locked]

# Attempts left LEDs
set_property PACKAGE_PIN V19 [get_ports {attempts_left[0]}]
set_property PACKAGE_PIN W18 [get_ports {attempts_left[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {attempts_left[*]}]

# 7-segment display (for digit count)
set_property PACKAGE_PIN W7 [get_ports {seg_display[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg_display[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg_display[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg_display[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg_display[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg_display[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg_display[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_display[*]}]

# Timing constraints
set_max_delay 5.0 -from [get_ports key_press] -to [get_registers *]
set_max_delay 5.0 -from [get_ports enter] -to [get_registers *]
