`timescale 100us / 1ps

module real_time_sim_tb;
    // Simulate a 100 MHz clock (period = 10 ps)
    reg clk;
    initial begin
        clk = 0;
        #1 clk = ~clk;
        forever #0.5 clk = ~clk;
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
        #100;
        start_btn <= 1'b1;
        #1000;
        start_btn <= 1'b0;
        #2000;
        stop_btn <= 1'b1;
        #1000;
        stop_btn <= 1'b0;
        #100;
        $finish;
    end
    
    wire [3:0] an;
    wire [6:0] seg;
    wire dp;
    wire [15:0] led;
    top #(
        .button_noise_period (1),
        .clk_freq            (10000)
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
