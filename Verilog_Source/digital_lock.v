// Digital Lock System with Password Authentication and Wrong-Attempt Alarm
// Features: 4-digit password, 3 attempts, lockout mechanism, alarm system

module digital_lock (
    input wire clk,                    // Clock signal
    input wire reset,                  // Reset signal
    input wire [3:0] key_in,          // 4-bit keypad input (0-9)
    input wire key_press,             // Key press strobe
    input wire enter,                 // Enter button
    input wire clear,                 // Clear button
    input wire change_pwd_mode,       // Change password mode
    output reg lock_open,             // Lock status (1 = open, 0 = locked)
    output reg alarm,                 // Alarm output
    output reg [1:0] attempts_left,   // Remaining attempts
    output reg [2:0] digit_count,     // Current digit count
    output reg system_locked,         // System lockout status
    output reg [6:0] seg_display      // 7-segment display output
);

    // Parameters
    parameter MAX_ATTEMPTS = 3;
    parameter PASSWORD_LENGTH = 4;
    parameter ALARM_DURATION = 5;     // seconds (in clock cycles at 1Hz)
    parameter LOCKOUT_DURATION = 10;  // seconds (in clock cycles at 1Hz)
    
    // Default password: 1234
    parameter DEFAULT_PWD = 16'h1234;
    
    // State definitions
    localparam IDLE = 3'b000;
    localparam ENTERING = 3'b001;
    localparam CHECKING = 3'b010;
    localparam UNLOCKED = 3'b011;
    localparam LOCKED_OUT = 3'b100;
    localparam ALARM_ON = 3'b101;
    localparam CHANGE_PWD = 3'b110;
    
    // Registers
    reg [2:0] state, next_state;
    reg [15:0] stored_password;       // 4 digits x 4 bits = 16 bits
    reg [15:0] entered_password;      // Current password being entered
    reg [15:0] new_password;          // New password for change mode
    reg [2:0] failed_attempts;        // Failed attempt counter
    reg [31:0] timer;                 // General purpose timer
    reg pwd_verified;                 // Password verification flag
    
    // Initialize
    initial begin
        stored_password = DEFAULT_PWD;
        lock_open = 0;
        alarm = 0;
        attempts_left = MAX_ATTEMPTS;
        system_locked = 0;
        state = IDLE;
        failed_attempts = 0;
        digit_count = 0;
        entered_password = 0;
        timer = 0;
        pwd_verified = 0;
        seg_display = 7'b1111111; // Display off
    end
    
    // State machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            stored_password <= DEFAULT_PWD;
            lock_open <= 0;
            alarm <= 0;
            attempts_left <= MAX_ATTEMPTS;
            system_locked <= 0;
            failed_attempts <= 0;
            digit_count <= 0;
            entered_password <= 0;
            timer <= 0;
            pwd_verified <= 0;
        end else begin
            state <= next_state;
        end
    end
    
    // Next state logic and output logic
    always @(*) begin
        next_state = state;
        
        case (state)
            IDLE: begin
                if (change_pwd_mode && lock_open) begin
                    next_state = CHANGE_PWD;
                end else if (key_press && !system_locked) begin
                    next_state = ENTERING;
                end
            end
            
            ENTERING: begin
                if (digit_count >= PASSWORD_LENGTH && enter) begin
                    next_state = CHECKING;
                end else if (clear) begin
                    next_state = IDLE;
                end
            end
            
            CHECKING: begin
                if (entered_password == stored_password) begin
                    next_state = UNLOCKED;
                end else begin
                    if (failed_attempts + 1 >= MAX_ATTEMPTS) begin
                        next_state = ALARM_ON;
                    end else begin
                        next_state = IDLE;
                    end
                end
            end
            
            UNLOCKED: begin
                if (clear) begin
                    next_state = IDLE;
                end else if (change_pwd_mode) begin
                    next_state = CHANGE_PWD;
                end
            end
            
            ALARM_ON: begin
                if (timer >= ALARM_DURATION - 1) begin
                    next_state = LOCKED_OUT;
                end
            end
            
            LOCKED_OUT: begin
                if (timer >= (ALARM_DURATION + LOCKOUT_DURATION - 1)) begin
                    next_state = IDLE;
                end
            end
            
            CHANGE_PWD: begin
                if (digit_count >= PASSWORD_LENGTH && enter) begin
                    next_state = IDLE;
                end else if (clear) begin
                    next_state = UNLOCKED;
                end
            end
            
            default: next_state = IDLE;
        endcase
    end
    
    // Input processing and password entry
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            entered_password <= 0;
            digit_count <= 0;
            new_password <= 0;
            lock_open <= 0;
            alarm <= 0;
            system_locked <= 0;
        end else begin
            // Default output assignments
            lock_open <= (state == UNLOCKED);
            alarm <= (state == ALARM_ON);
            system_locked <= (state == ALARM_ON || state == LOCKED_OUT);
            
            case (state)
                IDLE: begin
                    entered_password <= 0;
                    digit_count <= 0;
                    timer <= 0;
                    if (clear && !(state == ALARM_ON || state == LOCKED_OUT)) begin
                        failed_attempts <= 0;
                        attempts_left <= MAX_ATTEMPTS;
                    end
                end
                
                ENTERING: begin
                    if (key_press && digit_count < PASSWORD_LENGTH) begin
                        // Shift password left and add new digit
                        entered_password <= (entered_password << 4) | key_in;
                        digit_count <= digit_count + 1;
                    end
                    
                    if (clear) begin
                        entered_password <= 0;
                        digit_count <= 0;
                    end
                end
                
                CHECKING: begin
                    if (entered_password == stored_password) begin
                        // Correct password
                        failed_attempts <= 0;
                        attempts_left <= MAX_ATTEMPTS;
                    end else begin
                        // Wrong password
                        failed_attempts <= failed_attempts + 1;
                        attempts_left <= (attempts_left > 0) ? attempts_left - 1 : 0;
                    end
                    entered_password <= 0;
                    digit_count <= 0;
                end
                
                UNLOCKED: begin
                    if (clear) begin
                        entered_password <= 0;
                        digit_count <= 0;
                    end
                end
                
                ALARM_ON: begin
                    timer <= timer + 1;
                end
                
                LOCKED_OUT: begin
                    timer <= timer + 1;
                    
                    if (timer >= (ALARM_DURATION + LOCKOUT_DURATION - 1)) begin
                        // Reset after lockout
                        timer <= 0;
                        failed_attempts <= 0;
                        attempts_left <= MAX_ATTEMPTS;
                    end
                end
                
                CHANGE_PWD: begin
                    if (key_press && digit_count < PASSWORD_LENGTH) begin
                        new_password <= (new_password << 4) | key_in;
                        digit_count <= digit_count + 1;
                    end
                    
                    if (digit_count >= PASSWORD_LENGTH && enter) begin
                        stored_password <= new_password;
                        new_password <= 0;
                        digit_count <= 0;
                    end
                    
                    if (clear) begin
                        new_password <= 0;
                        digit_count <= 0;
                    end
                end
            endcase
        end
    end
    
    // 7-segment display encoder (displays digit count or status)
    always @(*) begin
        case (digit_count)
            3'd0: seg_display = 7'b1000000; // 0
            3'd1: seg_display = 7'b1111001; // 1
            3'd2: seg_display = 7'b0100100; // 2
            3'd3: seg_display = 7'b0110000; // 3
            3'd4: seg_display = 7'b0011001; // 4
            default: seg_display = 7'b1111111; // Off
        endcase
        
        // Show error on alarm
        if (state == ALARM_ON || state == LOCKED_OUT) begin
            seg_display = 7'b0000110; // E for Error
        end
    end

endmodule
