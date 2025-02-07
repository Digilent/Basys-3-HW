`timescale 1ns / 1ps

module seven_segment_decoder (
    input wire [3:0] digit,
    output reg [6:0] seven_seg_cat
);
    always @(*) begin
        case (digit)
        4'h0: seven_seg_cat[6:0] = 7'b1000000;
        4'h1: seven_seg_cat[6:0] = 7'b1111001;
        4'h2: seven_seg_cat[6:0] = 7'b0100100;
        4'h3: seven_seg_cat[6:0] = 7'b0110000;
        4'h4: seven_seg_cat[6:0] = 7'b0011001;
        4'h5: seven_seg_cat[6:0] = 7'b0010010;
        4'h6: seven_seg_cat[6:0] = 7'b0000010;
        4'h7: seven_seg_cat[6:0] = 7'b1111000;
        4'h8: seven_seg_cat[6:0] = 7'b0000000;
        4'h9: seven_seg_cat[6:0] = 7'b0010000;
        4'ha: seven_seg_cat[6:0] = 7'b0001000;
        4'hb: seven_seg_cat[6:0] = 7'b0000011;
        4'hc: seven_seg_cat[6:0] = 7'b1000110;
        4'hd: seven_seg_cat[6:0] = 7'b0100001;
        4'he: seven_seg_cat[6:0] = 7'b0000110;
        4'hf: seven_seg_cat[6:0] = 7'b0001110;
        endcase
    end
endmodule
