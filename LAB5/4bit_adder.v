`timescale 1ms / 1ns

module adder_4bit(
    input [3:0] augend,
    input [3:0] addend,
    input carryin,
    output cout,
    output [3:0] sum
    );

    reg c0, c1, c2, c3;
    reg [3:0] aug, add, sum_1;
    
    //input setup
    always @(*) begin
        c0 = carryin;
        aug = augend;
        add = addend;
    end
    
    //carry
    always @(*) begin
        c1 = (add[0] & aug[0]) | (c0 & (add[0] ^ aug[0]));
        c2 = (add[1] & aug[1]) | (c1 & (add[1] ^ aug[1]));
        c3 = (add[2] & aug[2]) | (c2 & (add[2] ^ aug[2]));
    end
    
    //sum
    always @(*) begin
        sum_1[0] = add[0] ^ aug[0] ^ c0;
        sum_1[1] = add[1] ^ aug[1] ^ c1;
        sum_1[2] = add[2] ^ aug[2] ^ c2;
        sum_1[3] = add[3] ^ aug[3] ^ c3;
    end

    //output
    assign sum = sum_1;
    assign cout = (add[3] & aug[3]) | (c3 & (add[3] ^ aug[3]));
    
endmodule
