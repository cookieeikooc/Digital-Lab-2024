`timescale 1ns / 1ps

module pad_display_tb();
    reg clk_out;
    reg [0:2] pad_out;
    wire [0:3] test_pad_pos;
    wire [7:0] test_ssd;
    
    initial begin
        clk_out = 1'b0;
        pad_out = 7'b0000000;
        #10;
    end
    
    always #1 clk_out = ~clk_out;

    reg [1:0] count = 2'b00;
    always @(posedge clk_out) begin
        if(count == 2'b10) begin
            count = 2'b00;
        end
        else begin
            count <= count + 1;
        end
    end
    always @(*) begin
        case(count) 
            2'b00: pad_out = 3'b100;
            2'b01: pad_out = 3'b010;
            2'b10: pad_out = 3'b001;
            default: pad_out = 3'b000;
        endcase
    end
    
    pad_display UUT(
        .clk(clk_out),
        .pad(pad_out),
        .pad_pos_out(test_pad_pos),
        .ssd(test_ssd)
    );


endmodule