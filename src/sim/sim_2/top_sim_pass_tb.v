`timescale 1ns / 1ps

module top_sim_pass_tb;
    // Simulate a 100 MHz clock (period = 10 ps)
    reg clk;
    initial begin
        clk = 0;
        #10 clk = ~clk;
        forever #5 clk = ~clk;
    end
    // Toggle reset for one clock at the start of simulation to initialize everything
    reg reset;
    initial begin
        reset = 0;
        @(posedge clk) reset <= 1'b1;
        @(posedge clk) reset <= 1'b0;
    end
    // Toggle start button after 3us, then toggle stop button after another 9 us
    reg start_btn, stop_btn;
    initial begin
        start_btn = 0;
        stop_btn = 0;
        #4000;
        start_btn <= 1'b1;
        #1000;
        start_btn <= 1'b0;
        #15500;
        stop_btn <= 1'b1;
        #1000;
        stop_btn <= 1'b0;
        #1000;
        $finish;
    end
    
    wire [3:0] an;
    wire [6:0] seg;
    wire dp;
    wire [15:0] led;
    top #(
        .button_noise_period (1),
        .clk_freq            (1000)
    ) dut (
        .clk        (clk),
        .reset      (reset),
        .start_btn  (start_btn),
        .stop_btn   (stop_btn),
        .an         (an),
        .seg        (seg),
        .dp         (dp),
        .led        (led)
    );
endmodule
