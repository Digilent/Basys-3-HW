`timescale 1ns / 1ps

module counter #(
    parameter integer width = 32
) (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [width-1:0] high_count,
    output reg [width-1:0] count_out = 0,
    output wire carry_out
);
    assign carry_out = (count_out == high_count);
    
    always @(posedge clk) begin
        if (reset == 1) begin
            count_out <= 'b0;
        end else if (enable == 1) begin
            if (carry_out == 1'b1) begin
                count_out <= 'b0;
            end else begin
                count_out <= count_out + 1;
            end
        end
    end
endmodule
