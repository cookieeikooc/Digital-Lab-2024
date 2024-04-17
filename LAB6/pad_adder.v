`timescale 1ns / 1ps

module pad_adder(
    input clk,
    input [0:2] pad,
    input switch,
    input result,
    input reset,
    output [0:3] pad_pos_out,
    output [7:0] dig,
    output [7:0] ssd
    );


    //oscillator devide
    reg [17:0] div;
    initial begin
        div = 18'd0;
    end
    reg clk_r; //refresh clock
    always @(posedge clk) begin
        if (div < 18'd208_333) begin //480Hz 
            div <= div + 1;
        end
        else begin
            div <= 18'd0;
        end
        clk_r <= div[17];
    end


    //ABCD refresh
    reg [1:0] signal = 2'b00;
    always @(posedge clk_r) begin
        if(signal < 2'b11) begin
            signal <= signal + 1;
        end
        else begin
            signal = 2'b00;
        end
    end
    
    reg [0:3] pad_pos = 4'b1000;
    always @(*) begin
        case(signal)
            2'b00: pad_pos = 4'b1000;
            2'b01: pad_pos = 4'b0100;
            2'b10: pad_pos = 4'b0010;
            2'b11: pad_pos = 4'b0001;
            default: pad_pos = 4'b1000;
        endcase
    end


    //pressed detection
    reg [3:0] pad_current = 4'd12;
    reg [4:0] num = 4'd0;
    reg [3:0] bcd_a = 4'b0000;
    reg [3:0] bcd_b = 4'b0000;
    reg [3:0] bcd_m = 4'd10; //dark
    reg [3:0] bcd_l = 4'd10;
    always @(negedge clk_r) begin
        if(reset == 1'b1) begin //reset
            bcd_a = 4'd0;
            bcd_b = 4'd0;
            num = 4'd0;
            bcd_m = 4'd0;
            bcd_l = 4'd0;
            pad_current = 4'd0;
        end
        else if(result == 1'b1) begin //get result
            num = bcd_a + bcd_b;
            if(num > 5'd9) begin
                bcd_m = 4'd1;
                bcd_l = num - 10;
            end
            else begin
                bcd_m = 4'd10;
                bcd_l = num;
            end
        end
        else if(pad_current < 4'd10) begin //valid press
            if(switch == 1'b0) begin
                bcd_a = pad_current;
                bcd_m = 4'd10;
                bcd_l = bcd_a;
                pad_current = 4'd12;
            end
            else begin
                bcd_b = pad_current;
                bcd_m = 4'd10;
                bcd_l = bcd_b;
                pad_current = 4'd12;
            end
        end
        else if(pad_current > 4'd9) begin //stand by and press detection
            case(pad_pos)
                4'b1000: begin
                    if(pad[0] == 1'b1 && pad_pos == 4'b1000) begin //1
                        pad_current = 4'd1;
                    end
                    else if(pad[1] == 1'b1 && pad_pos == 4'b1000) begin
                        pad_current = 4'd2;
                    end
                    else if(pad[2] == 1'b1 && pad_pos == 4'b1000) begin
                        pad_current = 4'd3;
                    end
                    else begin
                        pad_current <= pad_current;
                        if(switch == 1'b0) begin
                            bcd_m = 4'd10;
                            bcd_l = bcd_a;
                        end
                        else begin
                            bcd_m = 4'd10;
                            bcd_l = bcd_b;
                        end
                    end
                end
                4'b0100: begin
                    if(pad[0] == 1'b1 && pad_pos == 4'b0100) begin //4
                        pad_current = 4'd4;
                    end
                    else if(pad[1] == 1'b1 && pad_pos == 4'b0100) begin
                        pad_current = 4'd5;
                    end
                    else if(pad[2] == 1'b1 && pad_pos == 4'b0100) begin
                        pad_current = 4'd6;
                    end
                    else begin
                        pad_current <= pad_current;
                        if(switch == 1'b0) begin
                            bcd_m = 4'd10;
                            bcd_l = bcd_a;
                        end
                        else begin
                            bcd_m = 4'd10;
                            bcd_l = bcd_b;
                        end
                    end
                end
                4'b0010: begin
                    if(pad[0] == 1'b1 && pad_pos == 4'b0010) begin //7
                        pad_current = 4'd7;
                    end
                    else if(pad[1] == 1'b1 && pad_pos == 4'b0010) begin
                        pad_current = 4'd8;
                    end
                    else if(pad[2] == 1'b1 && pad_pos == 4'b0010) begin
                        pad_current = 4'd9;
                    end
                    else begin
                        pad_current <= pad_current;
                        if(switch == 1'b0) begin
                            bcd_m = 4'd10;
                            bcd_l = bcd_a;
                        end
                        else begin
                            bcd_m = 4'd10;
                            bcd_l = bcd_b;
                        end
                    end
                end
                4'b0001: begin
                    if(pad[0] == 1'b1 && pad_pos == 4'b0001) begin //*
                        pad_current = 4'd10;
                    end
                    else if(pad[1] == 1'b1 && pad_pos == 4'b0001) begin
                        pad_current = 4'd0;
                    end
                    else if(pad[2] == 1'b1 && pad_pos == 4'b0001) begin
                        pad_current = 4'd11;
                    end
                    else begin
                        pad_current <= pad_current;
                        if(switch == 1'b0) begin
                            bcd_m = 4'd10;
                            bcd_l = bcd_a;
                        end
                        else begin
                            bcd_m = 4'd10;
                            bcd_l = bcd_b;
                        end
                    end
                end
                default: begin
                    pad_current <= pad_current;
                    if(switch == 1'b0) begin
                        bcd_m = 4'd10;
                        bcd_l = bcd_a;
                    end
                    else begin
                        bcd_m = 4'd10;
                        bcd_l = bcd_b;
                    end
                end
            endcase
        end
        else begin //conflict situation
            if(switch == 1'b0) begin
                bcd_m = 4'd10;
                bcd_l = bcd_a;
            end
            else begin
                bcd_m = 4'd10;
                bcd_l = bcd_b;
            end
        end
    end


    //SSD LUT
    reg [7:0] ssd_lut[10:0];
    initial begin
        ssd_lut[0] = 8'b0000001_1;
        ssd_lut[1] = 8'b1001111_1;
        ssd_lut[2] = 8'b0010010_1;
        ssd_lut[3] = 8'b0000110_1;
        ssd_lut[4] = 8'b1001100_1;
        ssd_lut[5] = 8'b0100100_1;
        ssd_lut[6] = 8'b0100000_1;
        ssd_lut[7] = 8'b0001111_1;
        ssd_lut[8] = 8'b0000000_1;
        ssd_lut[9] = 8'b0000100_1;
        ssd_lut[10] = 8'b1111111_1;
    end


    //BCD digit assignment
    reg [7:0] dig_out = 8'b1111_1111;
    reg [7:0] bcd_display = 8'b0000001_1;
    always @(*) begin
        case(signal)
            2'b00: begin
                dig_out <= 8'b1111_1101;
                bcd_display <= ssd_lut[bcd_m];
            end
            2'b01: begin
                dig_out <= 8'b1111_1110;
                bcd_display <= ssd_lut[bcd_l];
            end
            2'b10: begin
                dig_out <= 8'b1111_1101;
                bcd_display <= ssd_lut[bcd_m];
            end
            2'b11: begin
                dig_out <= 8'b1111_1110;
                bcd_display <= ssd_lut[bcd_l];
            end
            default: begin
                dig_out = 8'b1111_1111;
                bcd_display = ssd_lut[10];
            end
        endcase
    end


    //output
    assign pad_pos_out = pad_pos;
    assign dig = dig_out;
    assign ssd = bcd_display;

endmodule