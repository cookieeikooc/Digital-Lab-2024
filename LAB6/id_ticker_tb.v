`timescale 1ns / 1ps

module id_ticker_tb();
    reg clk_out;
    reg switch;
    wire [7:0] test_ssd;
    
    initial begin
        clk_out = 1'b0;
        switch = 1'b0;
        #2;
    end
    
    always #1 clk_out = ~clk_out;
    
    id_ticker UUT(
        .clk(clk_out),
        .direction(switch),
        .ssd(test_ssd)
    );

endmodule
