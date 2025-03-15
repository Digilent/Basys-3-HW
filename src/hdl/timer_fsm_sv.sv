`timescale 1ns / 1ps

module timer_fsm_sv (
    input  logic clk,
    input  logic reset,
    input  logic start,
    input  logic stop,
    input  logic strobe,
    output logic timer_enable,
    input  logic timer_carry,
    output logic timer_decrement,
    output logic bcd_clear,
    output logic bcd_enable,
    output logic ten_hz_clear
);
    logic blink_done;
    logic blink_enable;
    logic [3:0] blink_count;

    enum {
        STATE_IDLE = 0,
        STATE_RUNNING,
        STATE_BLINKING,
        STATE_RESTART,
        STATE_FAIL
    } state;

    initial begin
        state <= STATE_IDLE;
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_IDLE;
        end else case (state)
        STATE_IDLE:
            if (start)
                state <= STATE_RUNNING;
        STATE_RUNNING:
            if (stop && !start) begin
                if (timer_carry)
                    state <= STATE_BLINKING;
                else
                    state <= STATE_FAIL;
            end else if (strobe && timer_carry) begin
                state <= STATE_FAIL;
            end
        STATE_BLINKING:
            if (strobe && blink_done)
                state <= STATE_RESTART;
        STATE_RESTART:
            if (start)
                state <= STATE_RUNNING;
        STATE_FAIL:
            if (timer_carry)
                state <= STATE_IDLE;
        endcase
    end

    always_comb begin
        if (state == STATE_BLINKING) begin
            blink_enable = strobe;
        end else begin
            blink_enable = 0;
        end
    end
    
    always_comb begin
        if (state == STATE_BLINKING) begin
            timer_enable = strobe;
        end else if (state == STATE_RUNNING) begin
            if ((!stop || start) && timer_carry) begin
                timer_enable = 0;
            end else begin
                timer_enable = strobe;
            end
        end else if (state == STATE_FAIL) begin
            timer_enable = strobe;
        end else begin
            timer_enable = 0;
        end
    end
    
    always_comb begin
        if (state == STATE_BLINKING) begin
            timer_decrement = blink_count[0];
        end else if (state == STATE_FAIL) begin
            timer_decrement = 1;
        end else begin
            timer_decrement = 0;
        end
    end
    
    always_comb begin
        if (state == STATE_IDLE) begin
            bcd_clear = start;
        end else begin
            bcd_clear = 0;
        end
    end
    
    always_comb begin
        if (state == STATE_RUNNING) begin
            bcd_enable = strobe;
        end else begin
            bcd_enable = 0;
        end
    end

    always_comb begin
        if (state == STATE_RUNNING && stop && !start && !timer_carry) begin
            ten_hz_clear = 1;
        end else begin
            ten_hz_clear = 0;
        end
    end

    counter #(
        .width(4)
    ) blink_timer (
        .clk(clk),
        .reset(reset),
        .enable(blink_enable),
        .high_count(4'd8),
        .count_out(blink_count),
        .carry_out(blink_done)
    );

endmodule
