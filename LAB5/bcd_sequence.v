`timescale 1ns / 1ps

module bcd_sequence(
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

    
    //BCD counting decoder
    reg [3:0] bcd = 4'b0000;
   always @(posedge clk_d) begin
        if (bcd == 4'b1001) begin // reset when bcd reaches 9
            bcd <= 4'b0000;
        end else begin
            bcd <= bcd + 1;
        end
    end

    //SSD
    reg [7:0] ssd_decode;
    always @(*) begin
        ssd_decode[0] = ((~bcd[3])&(~bcd[2])&(~bcd[1])&bcd[0]) | ((~bcd[3])&bcd[2]&(~bcd[1])&(~bcd[0]));
        ssd_decode[1] = ((~bcd[3])&bcd[2]&(~bcd[1])&bcd[0]) | ((~bcd[3])&bcd[2]&bcd[1]&(~bcd[0]));
        ssd_decode[2] = ((~bcd[3])&(~bcd[2])&bcd[1]&(~bcd[0]));
        ssd_decode[3] = ((~bcd[3])&(~bcd[2])&(~bcd[1])&bcd[0]) | ((~bcd[3])&bcd[2]&(~bcd[1])&(~bcd[0])) | ((~bcd[3])&bcd[2]&bcd[1]&bcd[0]);
        ssd_decode[4] = ((~bcd[3])&bcd[0]) | ((~bcd[3])&bcd[2]&(~bcd[1])) | (~(bcd[2])&(~bcd[1])&bcd[0]);
        ssd_decode[5] = ((~bcd[3])&(~bcd[2])&bcd[0]) | ((~bcd[3])&(~bcd[2])&bcd[1]) | ((~bcd[3])&bcd[1]&bcd[0]);
        ssd_decode[6] = ((~bcd[3])&(~bcd[2])&(~bcd[1]))|((~bcd[3])&bcd[2]&bcd[1]&bcd[0]);
        ssd_decode[7] = 1'b1;
    end

    //dig & ssd output
    assign dig = 8'b0111_1111;
    assign ssd = ssd_decode;
    
endmodule
