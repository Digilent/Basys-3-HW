`timescale 1ns / 1ps

module counter #(
    parameter integer width = 32
) (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire decrement,
    input wire [width-1:0] high_count,
    output reg [width-1:0] count_out = 0,
    output reg carry_out
);
    always @(*) begin
        if (!decrement && count_out == high_count) begin
            carry_out = 1'b1;
        end else if (decrement && count_out == 'b0) begin
            carry_out = 1'b1;
        end else begin
            carry_out = 1'b0;
        end
    end
    always @(posedge clk) begin
        if (reset == 1) begin
            count_out <= 'b0;
        end else if (enable == 1) begin
            if (carry_out == 1'b1) begin
                if (!decrement) begin
                    count_out <= 'b0;
                end else begin
                    count_out <= high_count;
                end
            end else begin
                if (!decrement == 1'b1) begin
                    count_out <= count_out + 1;
                end else begin
                    count_out <= count_out - 1;
                end
            end
        end
    end
endmodule
