`timescale 1ps / 0.001ps

module id_ticker_tb();
    reg clk_out;
    reg direction_in;
    reg shift_en;
    reg min_test_en;
    reg hour_test_en;
    wire [7:0] test_dig;
    wire [7:0] test_ssd;
    
    initial begin
        clk_out = 1'b0;
        direction_in = 1'b0;
        shift_en = 1'b1;
        min_test_en = 1'b0;
        hour_test_en = 1'b0;
        #2;
    end

    always #1 clk_out = ~clk_out;
    
    digital_clock UUT(
        .clk(clk_out),
        .direction(direction_in),
        .shift_enable(shift_en),
        .min_test_enable(min_test_en),
        .hr_test_enable(hour_test_en),
        .dig(test_dig),
        .ssd(test_ssd)
    );

endmodule
