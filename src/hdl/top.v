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
    wire        clear_timer;
    reg  [3:0]  active_digit;
    wire        start_clean, stop_clean, increment_clean, decrement_clean;
    wire        bcd_clear;
    
    wire        leds_full;
    wire        leds_empty;
    wire        timer_clear;
    wire        timer_toggle;
    wire        timer_enable;
    wire        fill_from_right;
    reg  [15:0] led_timer;
    
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
        .decrement      (1'b0),
        .high_count     (clk_freq / 1000 - 1),
        .count_out      (),
        .carry_out      (khz_strobe)
    );
    
    counter #(
        .width  (32)
    ) ten_hz_inst (
        .clk            (clk),
        .reset          (reset),
        .enable         (khz_strobe),
        .decrement      (1'b0),
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
        .decrement  (1'b0),
        .digits     (digits)
    );
    
    counter #(
        .width  (2)
    ) digit_select_inst (
        .clk            (clk),
        .reset          (1'b0),
        .enable         (khz_strobe),
        .decrement      (1'b0),
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
    
    timer_fsm timer_inst (
        .clk                (clk),
        .reset              (reset),
        .start              (start_clean),
        .stop               (stop_clean),
        .strobe             (ten_hz_strobe),
        .timer_clear        (timer_clear),
        .timer_toggle       (timer_toggle),
        .timer_enable       (timer_enable),
        .leds_full          (leds_full),
        .leds_empty         (leds_empty),
        .bcd_clear          (bcd_clear),
        .bcd_enable         (bcd_enable),
        .fill_from_right    (fill_from_right)
    );

    always @(posedge clk) begin
        if (reset) begin
            led_timer <= 'b0;
        end else if (timer_clear) begin
            led_timer <= 'b0;
        end else if (timer_enable) begin
            if (timer_toggle) begin
                led_timer <= ~led_timer;
            end else if (fill_from_right) begin
                led_timer <= {led_timer[14:0], 1'b1};
            end else begin
                led_timer <= {1'b0, led_timer[15:1]};
            end
        end
    end
    
    assign leds_full = &led_timer;
    assign leds_empty = ~|led_timer;
    assign led = led_timer;
endmodule
