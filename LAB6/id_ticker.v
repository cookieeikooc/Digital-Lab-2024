`timescale 1ns / 1ps

module id_ticker(
    input clk, //100MHz
    input direction,
    output [7:0] dig,
    output [7:0] ssd
    );

    //oscillator devide
    reg [25:0] div_s;
    reg [17:0] div_r;
    initial begin
        div_s = 26'd0;
        div_r = 17'd0;
    end
    
    reg clk_s; //shift clock
    reg clk_r; //refresh clock
    always @(posedge clk) begin
        if (div_s < 26'd50_000_000) begin //2Hz
            div_s <= div_s + 1;
        end
        else begin
            div_s <= 26'd0;
        end
        clk_s <= div_s[25];

        if (div_r < 18'd208_333) begin //480Hz, 60Hz scanne rate 
            div_r <= div_r + 1;
        end
        else begin
            div_r <= 18'd0;
        end
        clk_r <= div_r[17];
    end
    

    //memory shifting
    reg [7:0] memory[0:9];
    initial begin
        memory[0] = 8'b1001111_1;
        memory[1] = 8'b1001111_1;
        memory[2] = 8'b0010010_1;
        memory[3] = 8'b0100100_1;
        memory[4] = 8'b1001111_1;
        memory[5] = 8'b1001111_1;
        memory[6] = 8'b0000001_1;
        memory[7] = 8'b0000110_1;
        memory[8] = 8'b0000110_1;
        memory[9] = 8'b1111111_1;
    end
    always @(posedge clk_s) begin
        if(direction == 1'b0) begin
            memory[0] <= memory[9];
            memory[1] <= memory[0];
            memory[2] <= memory[1];
            memory[3] <= memory[2];
            memory[4] <= memory[3];
            memory[5] <= memory[4];
            memory[6] <= memory[5];
            memory[7] <= memory[6];
            memory[8] <= memory[7];
            memory[9] <= memory[8];
        end
        else begin
            memory[0] <= memory[1];
            memory[1] <= memory[2];
            memory[2] <= memory[3];
            memory[3] <= memory[4];
            memory[4] <= memory[5];
            memory[5] <= memory[6];
            memory[6] <= memory[7];
            memory[7] <= memory[8];
            memory[8] <= memory[9];
            memory[9] <= memory[0];
        end
    end


    //SSD refresh
    reg [2:0] rate = 3'b000;
    always @(posedge clk_r) begin
        if (rate == 3'b111) begin // reset
            rate <= 3'b000;
        end 
        else begin
            rate <= rate + 1;
        end
    end
    reg [7:0] ssd_current = 8'b1111111_1;
    reg [7:0] dig_r = 8'b1111_1111;
    always @(*) begin
        case(rate)
            3'b000: begin
                dig_r = 8'b0111_1111;
                ssd_current = memory[0];
            end
            3'b001: begin
                dig_r = 8'b1011_1111;
                ssd_current = memory[1];
            end
            3'b010: begin
                dig_r = 8'b1101_1111;
                ssd_current = memory[2];
            end
            3'b011: begin
                dig_r = 8'b1110_1111;
                ssd_current = memory[3];
            end
            3'b100: begin
                dig_r = 8'b1111_0111;
                ssd_current = memory[4];
            end
            3'b101: begin
                dig_r = 8'b1111_1011;
                ssd_current = memory[5];
            end
            3'b110: begin
                dig_r = 8'b1111_1101;
                ssd_current = memory[6];
            end
            3'b111: begin
                dig_r = 8'b1111_1110;
                ssd_current = memory[7];
            end
            default: begin
                dig_r = 8'b0111_1111;
                ssd_current = memory[0];
            end
        endcase
    end

    
    //dig & ssd output
    assign dig = dig_r;
    assign ssd = ssd_current;
    
endmodule
