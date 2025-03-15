`timescale 1ns / 1ps

module top #(
    parameter integer clk_freq = 100000000,
    parameter integer button_noise_period = 100
) (
    input wire clk,
    input wire reset,
    input wire start_btn,
    input wire stop_btn,
    output wire [3:0] an,
    output wire [6:0] seg,
    output wire dp,
    output wire [15:0] led
);
    wire        khz_strobe;
    wire        ten_hz_tc;
    wire        ten_hz_strobe;
    wire [1:0]  digit_select;
    wire [15:0] digits;
    reg  [3:0]  active_digit;
    wire        start_clean, stop_clean;
    wire        bcd_clear;
    
    wire        timer_carry;
    wire        timer_toggle;
    wire        timer_enable;
    reg  [15:0] led_timer;
    wire        ten_hz_clear;
    
    debouncer #(
        .noise_period   (button_noise_period)
    ) start_db_inst (
        .clk        (clk),
        .reset      (1'b0),
        .data_in    (start_btn),
        .data_out   (start_clean)
    );
    
    debouncer #(
        .noise_period   (button_noise_period)
    ) stop_db_inst (
        .clk        (clk),
        .reset      (1'b0),
        .data_in    (stop_btn),
        .data_out   (stop_clean)
    );
    
    counter #(
        .width  (32)
    ) khz_inst (
        .clk            (clk),
        .reset          (1'b0),
        .enable         (1'b1),
        .high_count     (clk_freq / 1000 - 1),
        .count_out      (),
        .carry_out      (khz_strobe)
    );
    
    counter #(
        .width  (32)
    ) ten_hz_inst (
        .clk            (clk),
        .reset          (reset | ten_hz_clear),
        .enable         (khz_strobe),
        .high_count     (99),
        .count_out      (),
        .carry_out      (ten_hz_tc)
    );
    
    assign ten_hz_strobe = ten_hz_tc & khz_strobe;
    
    wire bcd_enable;
    bcd_counter #(
        .num_digits(4)
    ) bcd_inst (
        .clk        (clk),
        .reset      (reset | bcd_clear),
        .enable     (bcd_enable),
        .digits     (digits)
    );
    
    counter #(
        .width  (2)
    ) digit_select_inst (
        .clk            (clk),
        .reset          (1'b0),
        .enable         (khz_strobe),
        .high_count     (2'd3),
        .count_out      (digit_select),
        .carry_out      ()
    );
    
    always @(*) begin
        case (digit_select)
        0: active_digit = digits[3:0];
        1: active_digit = digits[7:4];
        2: active_digit = digits[11:8];
        3: active_digit = digits[15:12];
        endcase
    end
    
    seven_segment_decoder decode_inst (
        .digit(active_digit),
        .seven_seg_cat(seg)
    );
    
    assign an[0] = (digit_select != 2'd0);
    assign an[1] = (digit_select != 2'd1);
    assign an[2] = (digit_select != 2'd2);
    assign an[3] = (digit_select != 2'd3);
    
    // drive decimal point only on digit one, since we're counting tenths of seconds
    assign dp = an[1];
    
    timer_fsm_sv timer_inst (
        .clk                (clk),
        .reset              (reset),
        .start              (start_clean),
        .stop               (stop_clean),
        .strobe             (ten_hz_strobe),
        .timer_enable       (timer_enable),
        .timer_carry        (timer_carry),
        .timer_decrement    (timer_decrement),
        .bcd_clear          (bcd_clear),
        .bcd_enable         (bcd_enable),
        .ten_hz_clear       (ten_hz_clear)
    );

    wire [4:0] timer_count;
    updown_counter #(
        .width(5)
    ) led_timer_inst (
        .clk        (clk),
        .reset      (reset),
        .enable     (timer_enable),
        .decrement  (timer_decrement),
        .high_count (5'h10),
        .count_out  (timer_count),
        .carry_out  (timer_carry)
    );

    always @(*) begin
        case (timer_count)
        5'h00: led_timer = 16'h0000;
        5'h01: led_timer = 16'h0001;
        5'h02: led_timer = 16'h0003;
        5'h03: led_timer = 16'h0007;
        5'h04: led_timer = 16'h000f;
        5'h05: led_timer = 16'h001f;
        5'h06: led_timer = 16'h003f;
        5'h07: led_timer = 16'h007f;
        5'h08: led_timer = 16'h00ff;
        5'h09: led_timer = 16'h01ff;
        5'h0a: led_timer = 16'h03ff;
        5'h0b: led_timer = 16'h07ff;
        5'h0c: led_timer = 16'h0fff;
        5'h0d: led_timer = 16'h1fff;
        5'h0e: led_timer = 16'h3fff;
        5'h0f: led_timer = 16'h7fff;
        5'h10: led_timer = 16'hffff;
        default: led_timer = 16'h0000;
        endcase
    end
    
    assign led = led_timer;
endmodule
