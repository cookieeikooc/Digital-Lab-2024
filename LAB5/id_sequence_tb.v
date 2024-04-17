`timescale 1ns / 1ps

module id_sequence_tb();
    reg clk_out;
    wire [7:0] test_ssd;
    
    initial begin
        clk_out = 1'b0;
        #2;
    end
    
    always #1 clk_out = ~clk_out;
    
    bcd_sequence UUT(
        .clk(clk_out),
        .ssd(test_ssd)
    );

endmodule
