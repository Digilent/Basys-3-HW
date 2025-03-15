`timescale 1ns / 1ps

module debouncer #(
    parameter integer noise_period = 100
) (
    input clk,
    input reset,
    input data_in,
    output reg data_out = 0
);
    wire enable = (data_in != data_out);
    wire carry_out;
    
    counter #(
        .width($clog2(noise_period-1))
    ) counter_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .high_count(noise_period-1),
        .count_out(),
        .carry_out(carry_out)
    );
    
    always @(posedge clk) begin
        if (reset)
            data_out <= 'b0;
        else if (carry_out && enable)
            data_out <= data_in;
    end
endmodule
