`timescale 1ns / 1ps

module bcd_counter #(
    parameter integer num_digits = 4
) (
    input wire clk,
    input wire reset,
    input wire enable,
    output wire [4*num_digits-1:0] digits
);
    wire [num_digits:0] carries;
    wire [num_digits+1:0] enables;
    assign carries[0] = 1;
    assign enables[0] = enable;
    assign enables[num_digits+1] = enable;

    assign enables[1] = enables[0] & carries[0];
    counter #(
        .width(4)
    ) digit_counter_0 (
        .clk            (clk),
        .reset          (reset),
        .enable         (enables[1]),
        .high_count     (4'h9),
        .count_out      (digits[0+:4]),
        .carry_out      (carries[1])
    );
    
    assign enables[2] = enables[1] & carries[1];
    counter #(
        .width(4)
    ) digit_counter_1 (
        .clk            (clk),
        .reset          (reset),
        .enable         (enables[2]),
        .high_count     (4'h9),
        .count_out      (digits[4+:4]),
        .carry_out      (carries[2])
    );
    
    assign enables[3] = enables[2] & carries[2];
    counter #(
        .width(4)
    ) digit_counter_2 (
        .clk            (clk),
        .reset          (reset),
        .enable         (enables[3]),
        .high_count     (4'h9),
        .count_out      (digits[8+:4]),
        .carry_out      (carries[3])
    );
    
    assign enables[4] = enables[3] & carries[3];
    counter #(
        .width(4)
    ) digit_counter_3 (
        .clk            (clk),
        .reset          (reset),
        .enable         (enables[4]),
        .high_count     (4'h9),
        .count_out      (digits[12+:4]),
        .carry_out      ()
    );
endmodule
