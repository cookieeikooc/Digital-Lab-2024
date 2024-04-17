`timescale 1ns / 1ps

module id_sequence(
    input clk,
    output [7:0] dig,
    output [7:0] ssd
    );

    //oscillator devide
    reg [24:0] div;
    initial begin
        div = 25'd0;
    end

    reg clk_d;
    always @(posedge clk) begin
        if (div < 25'b1_000_000_000_000_000_000_000_001) begin 
            div <= div + 1;
        end
        else begin
            div <= 25'd0;
        end
        clk_d <= div[24];
    end
    
    //counter
    reg [3:0] count = 4'b0000;
    always @(posedge clk_d) begin
        if (count == 4'b1111) begin // reset
            count <= 4'b0000;
        end 
        else begin
            count <= count + 1;
        end
    end

    //SSD sequence generator
    reg [7:0] ssd_decode = 8'b1111111_1;
    always @(posedge clk_d) begin
        case(count)
            4'b0000: ssd_decode = 8'b1001111_1;
            4'b0001: ssd_decode = 8'b1001111_1;
            4'b0010: ssd_decode = 8'b0010010_1;
            4'b0011: ssd_decode = 8'b0100100_1;
            4'b0100: ssd_decode = 8'b1001111_1;
            4'b0101: ssd_decode = 8'b1001111_1;
            4'b0110: ssd_decode = 8'b0000001_1;
            4'b0111: ssd_decode = 8'b0000110_1;
            4'b1000: ssd_decode = 8'b0000110_1;
            4'b1001: ssd_decode = 8'b0000001_1;
            4'b1010: ssd_decode = 8'b0000000_1;
            4'b1011: ssd_decode = 8'b1001111_1;
            4'b1100: ssd_decode = 8'b0100000_1;
            4'b1101: ssd_decode = 8'b1111111_1;
            4'b1110: ssd_decode = 8'b1001111_1;
            4'b1111: ssd_decode = 8'b0000100_1;
            default: ssd_decode = 8'b1111111_1;
        endcase
    end

    //dig & ssd output
    assign dig = 8'b0111_1111;
    assign ssd = ssd_decode;
    
endmodule
