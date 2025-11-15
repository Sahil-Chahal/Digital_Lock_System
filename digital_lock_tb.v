// Testbench for Digital Lock System
`timescale 1ns / 1ps

module digital_lock_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg [3:0] key_in;
    reg key_press;
    reg enter;
    reg clear;
    reg change_pwd_mode;
    wire lock_open;
    wire alarm;
    wire [1:0] attempts_left;
    wire [2:0] digit_count;
    wire system_locked;
    wire [6:0] seg_display;
    
    // Instantiate the Digital Lock System
    digital_lock uut (
        .clk(clk),
        .reset(reset),
        .key_in(key_in),
        .key_press(key_press),
        .enter(enter),
        .clear(clear),
        .change_pwd_mode(change_pwd_mode),
        .lock_open(lock_open),
        .alarm(alarm),
        .attempts_left(attempts_left),
        .digit_count(digit_count),
        .system_locked(system_locked),
        .seg_display(seg_display)
    );
    
    // Clock generation (10ns period = 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Task to press a key
    task press_key;
        input [3:0] digit;
        begin
            key_in = digit;
            key_press = 1;
            #10;
            key_press = 0;
            #10;
        end
    endtask
    
    // Task to press enter
    task press_enter;
        begin
            enter = 1;
            #10;
            enter = 0;
            #10;
        end
    endtask
    
    // Task to press clear
    task press_clear;
        begin
            clear = 1;
            #10;
            clear = 0;
            #10;
        end
    endtask
    
    // Task to enter a 4-digit password
    task enter_password;
        input [3:0] d1, d2, d3, d4;
        begin
            $display("Entering password: %d%d%d%d", d1, d2, d3, d4);
            press_key(d1);
            press_key(d2);
            press_key(d3);
            press_key(d4);
            press_enter();
            #40;  // Wait for state machine transitions
        end
    endtask
    
    // Test sequence
    initial begin
        // Initialize VCD dump for waveform viewing
        $dumpfile("digital_lock.vcd");
        $dumpvars(0, digital_lock_tb);
        
        // Initialize signals
        reset = 0;
        key_in = 0;
        key_press = 0;
        enter = 0;
        clear = 0;
        change_pwd_mode = 0;
        
        $display("\n========================================");
        $display("Digital Lock System Testbench Starting");
        $display("========================================\n");
        
        // Test 1: Reset the system
        $display("Test 1: System Reset");
        reset = 1;
        #20;
        reset = 0;
        #20;
        $display("Status: Lock=%b, Alarm=%b, Attempts=%d, Locked=%b\n", 
                 lock_open, alarm, attempts_left, system_locked);
        
        // Test 2: Correct password (1234)
        $display("Test 2: Entering Correct Password (1234)");
        enter_password(4'd1, 4'd2, 4'd3, 4'd4);
        $display("Status: Lock=%b, Alarm=%b, Attempts=%d, Locked=%b", 
                 lock_open, alarm, attempts_left, system_locked);
        if (lock_open) 
            $display("✓ PASS: Lock opened successfully\n");
        else 
            $display("✗ FAIL: Lock should be open\n");
        
        // Test 3: Lock the system again
        $display("Test 3: Closing the Lock");
        press_clear();
        #20;
        $display("Status: Lock=%b, Alarm=%b, Attempts=%d, Locked=%b\n", 
                 lock_open, alarm, attempts_left, system_locked);
        
        // Test 4: Wrong password attempt 1
        $display("Test 4: Wrong Password Attempt 1 (5678)");
        enter_password(4'd5, 4'd6, 4'd7, 4'd8);
        $display("Status: Lock=%b, Alarm=%b, Attempts=%d, Locked=%b", 
                 lock_open, alarm, attempts_left, system_locked);
        if (!lock_open && !alarm && attempts_left == 2) 
            $display("✓ PASS: Attempt 1 failed correctly\n");
        else 
            $display("✗ FAIL: Wrong behavior on attempt 1\n");
        
        // Test 5: Wrong password attempt 2
        $display("Test 5: Wrong Password Attempt 2 (9999)");
        enter_password(4'd9, 4'd9, 4'd9, 4'd9);
        $display("Status: Lock=%b, Alarm=%b, Attempts=%d, Locked=%b", 
                 lock_open, alarm, attempts_left, system_locked);
        if (!lock_open && !alarm && attempts_left == 1) 
            $display("✓ PASS: Attempt 2 failed correctly\n");
        else 
            $display("✗ FAIL: Wrong behavior on attempt 2\n");
        
        // Test 6: Wrong password attempt 3 (triggers alarm)
        $display("Test 6: Wrong Password Attempt 3 - Should Trigger Alarm (0000)");
        enter_password(4'd0, 4'd0, 4'd0, 4'd0);
        $display("Status: Lock=%b, Alarm=%b, Attempts=%d, Locked=%b", 
                 lock_open, alarm, attempts_left, system_locked);
        if (!lock_open && alarm && system_locked) 
            $display("✓ PASS: Alarm triggered and system locked\n");
        else 
            $display("✗ FAIL: Alarm should be on\n");
        
        // Test 7: Wait for alarm duration
        $display("Test 7: Waiting for Alarm Duration (5 cycles)");
        repeat(6) @(posedge clk);
        #20;
        $display("Status: Lock=%b, Alarm=%b, Attempts=%d, Locked=%b", 
                 lock_open, alarm, attempts_left, system_locked);
        if (!alarm && system_locked) 
            $display("✓ PASS: Alarm off, system still locked\n");
        else 
            $display("✗ FAIL: Should be in lockout mode\n");
        
        // Test 8: Wait for lockout duration
        $display("Test 8: Waiting for Lockout Duration (10 cycles)");
        repeat(11) @(posedge clk);
        #20;
        $display("Status: Lock=%b, Alarm=%b, Attempts=%d, Locked=%b", 
                 lock_open, alarm, attempts_left, system_locked);
        if (!system_locked && attempts_left == 3) 
            $display("✓ PASS: System unlocked, attempts reset\n");
        else 
            $display("✗ FAIL: System should be ready for new attempts\n");
        
        // Test 9: Correct password after lockout
        $display("Test 9: Entering Correct Password After Lockout (1234)");
        enter_password(4'd1, 4'd2, 4'd3, 4'd4);
        $display("Status: Lock=%b, Alarm=%b, Attempts=%d, Locked=%b", 
                 lock_open, alarm, attempts_left, system_locked);
        if (lock_open) 
            $display("✓ PASS: Lock opened after lockout\n");
        else 
            $display("✗ FAIL: Lock should open with correct password\n");
        
        // Test 10: Change password mode
        $display("Test 10: Changing Password to 4567");
        change_pwd_mode = 1;
        #20;
        change_pwd_mode = 0;
        enter_password(4'd4, 4'd5, 4'd6, 4'd7);
        $display("Password changed successfully\n");
        
        // Test 11: Verify new password works
        $display("Test 11: Testing New Password (4567)");
        enter_password(4'd4, 4'd5, 4'd6, 4'd7);
        $display("Status: Lock=%b, Alarm=%b, Attempts=%d, Locked=%b", 
                 lock_open, alarm, attempts_left, system_locked);
        if (lock_open) 
            $display("✓ PASS: New password works\n");
        else 
            $display("✗ FAIL: New password should work\n");
        
        // Test 12: Verify old password doesn't work
        $display("Test 12: Testing Old Password (1234) - Should Fail");
        press_clear();
        #20;
        enter_password(4'd1, 4'd2, 4'd3, 4'd4);
        $display("Status: Lock=%b, Alarm=%b, Attempts=%d, Locked=%b", 
                 lock_open, alarm, attempts_left, system_locked);
        if (!lock_open) 
            $display("✓ PASS: Old password rejected\n");
        else 
            $display("✗ FAIL: Old password should not work\n");
        
        $display("========================================");
        $display("Testbench Complete");
        $display("========================================\n");
        
        #100;
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t | State=%b | Digits=%d | Lock=%b | Alarm=%b | Attempts=%d | Locked=%b", 
                 $time, uut.state, digit_count, lock_open, alarm, attempts_left, system_locked);
    end

endmodule
