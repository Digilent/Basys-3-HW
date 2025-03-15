`timescale 1ns / 1ps

module updown_counter #(
    parameter integer width = 5
) (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire decrement,
    input wire [width-1:0] high_count,
    output reg [width-1:0] count_out,
    output reg carry_out
);
    initial begin
        carry_out = 0;
        count_out = 'b0;
    end
    always @(*) begin
        if (decrement) begin
            if (count_out == 0)
                carry_out = 1;
            else
                carry_out = 0;
        end else begin
            if (count_out == high_count)
                carry_out = 1;
            else
                carry_out = 0;
        end
    end
    
    always @(posedge clk) begin
        if (reset) begin
            count_out <= 'b0;
        end else if (enable) begin
            if (carry_out) begin
                if (decrement)
                    count_out <= high_count;
                else
                    count_out <= 'b0;
            end else begin
                if (decrement)
                    count_out <= count_out - 1'b1;
                else
                    count_out <= count_out + 1'b1;
            end
        end
    end
endmodule
