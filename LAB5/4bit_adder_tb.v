`timescale 1ns / 1ps

module adder_4bit_tb();
    reg clk;
    wire test_cout;
    wire [3:0] test_sum;
    
    reg [3:0] count;
    
    initial begin
        clk = 1'b0;
        count = 4'b0000;
        #100
        repeat (8) begin  //count from 0000 to 0111
            #10
            count <= count + 1;
        end
    end
    
    always #5 clk = ~clk;
    
    adder_4bit UUT(
        .carryin(clk),
        .augend(count),
        .addend(count), 
        .cout(test_cout),
        .sum(test_sum)
    );

endmodule
