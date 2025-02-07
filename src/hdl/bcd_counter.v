`timescale 1ns / 1ps

module bcd_counter #(
    parameter integer num_digits = 4
) (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire decrement,
    output wire [4*num_digits-1:0] digits
);
    wire [num_digits+1:0] carries;
    reg [num_digits+1:0] enables;
    assign carries[0] = 1;
    always @(*) begin
        enables[0] = enable;
        enables[num_digits+1] = enable;
    end
    genvar i;
    generate
        for (i = 0; i < num_digits; i = i + 1) begin
            always @(*) begin
                enables[i+1] = enables[i] & carries[i];
            end
            counter #(
                .width(4)
            ) digit_counter_i (
                .clk            (clk),
                .reset          (reset),
                .enable         (enables[i+1]),
                .decrement      (decrement),
                .high_count     (4'h9),
                .count_out      (digits[4*i+:4]),
                .carry_out      (carries[i+1])
            );
        end
    endgenerate
endmodule
