`timescale 1ns / 1ps

module timer_fsm (
    input wire clk,
    input wire reset,
    input wire start,
    input wire stop,
    input wire strobe,
    input wire leds_full,
    input wire leds_empty,
    output reg timer_clear,
    output reg timer_toggle,
    output reg timer_enable,
    output reg bcd_clear,
    output reg bcd_enable,
    output reg fill_from_right
);
    localparam STATE_IDLE = 0;
    localparam STATE_RUNNING = 1;
    localparam STATE_BLINKING = 2;
    localparam STATE_RESTART = 3;
    localparam STATE_FAIL = 4;
    reg [2:0] state;
    
    wire blink_done;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_IDLE;
        end else case (state)
        STATE_IDLE:
            if (start && !stop)
                state <= STATE_RUNNING;
        STATE_RUNNING:
            if (stop && !start)
                if (leds_full)
                    state <= STATE_BLINKING;
                else
                    state <= STATE_FAIL;
            else if (strobe && leds_full)
                state <= STATE_FAIL;
        STATE_BLINKING:
            if (strobe && blink_done)
                state <= STATE_RESTART;
        STATE_RESTART:
            if (start && !stop)
                state <= STATE_RUNNING;
        STATE_FAIL:
            if (leds_empty)
                state <= STATE_IDLE;
        endcase
    end
    
    counter #(
        .width      (3)
    ) blink_counter (
        .clk        (clk),
        .reset      (reset),
        .enable     (strobe && (state == STATE_BLINKING)),
        .decrement  (1'b0),
        .high_count (3'd7),
        .count_out  (),
        .carry_out  (blink_done)
    );

    always @(*) begin
        if (state == STATE_RUNNING) begin
            bcd_enable = strobe;
        end else begin
            bcd_enable = 0;
        end
    end

    always @(*) begin
        if (state == STATE_RUNNING) begin
            timer_enable = strobe;
        end else if (state == STATE_BLINKING) begin
            timer_enable = strobe;
        end else if (state == STATE_FAIL) begin
            timer_enable = strobe;
        end else begin
            timer_enable = 0;
        end
    end
    
    always @(*) begin
        if (state == STATE_RUNNING) begin
            fill_from_right = 1;
        end else begin
            fill_from_right = 0;        
        end
    end
    
    always @(*) begin
        if (state == STATE_BLINKING) begin
            timer_toggle = 1;
        end else begin
            timer_toggle = 0;
        end
    end
    
    always @(*) begin
        if (state == STATE_IDLE) begin
            timer_clear = start && !stop;
        end else if (state == STATE_RESTART) begin
            timer_clear = start && !stop;
        end else if (state == STATE_RUNNING) begin
            timer_clear = strobe && leds_full;
        end else begin
            timer_clear = 0;
        end
    end
    
    always @(*) begin
        if (state == STATE_IDLE) begin
            bcd_clear = start && !stop;
        end else if (state == STATE_RUNNING) begin
            bcd_clear = 0;
        end else begin
            bcd_clear = 0;
        end
    end
endmodule
