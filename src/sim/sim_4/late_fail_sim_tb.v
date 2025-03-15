`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2025 05:00:16 PM
// Design Name: 
// Module Name: late_fail_sim_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module late_fail_sim_tb;
    // generate an "overrun" failure, where stop is hit too soon

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
        #16500;
        stop_btn <= 1'b1;
        #1000;
        stop_btn <= 1'b0;
        #1000;
        while (top.timer_inst.state != top.timer_inst.STATE_IDLE)
            #4000;
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
