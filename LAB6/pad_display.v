`timescale 1ns / 1ps

module pad_display(
    input clk,
    input [0:2] pad,
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
        if(signal == 2'b11) begin
            signal = 2'b00;
        end
        else begin
            signal <= signal + 1;
        end
    end
    
    reg [0:3] pad_pos = 4'b0000;
    always @(*) begin
        case(signal)
            2'b00: pad_pos = 4'b1000;
            2'b01: pad_pos = 4'b0100;
            2'b10: pad_pos = 4'b0010;
            2'b11: pad_pos = 4'b0001;
            default: pad_pos = 4'b0000;
        endcase
    end


    //SSD LUT
    reg [7:0] ssd_lut[11:0];
    initial begin
        ssd_lut[0] = 8'b1001111_1;
        ssd_lut[1] = 8'b0010010_1;
        ssd_lut[2] = 8'b0000110_1;
        ssd_lut[3] = 8'b1001100_1;
        ssd_lut[4] = 8'b0100100_1;
        ssd_lut[5] = 8'b0100000_1;
        ssd_lut[6] = 8'b0001111_1;
        ssd_lut[7] = 8'b0000000_1;
        ssd_lut[8] = 8'b0000100_1;
        ssd_lut[9] = 8'b0000000_0;
        ssd_lut[10] = 8'b0000001_1;
        ssd_lut[11] = 8'b0011100_1;
    end


    //EFG detection
    reg [7:0] ssd_current;
    always @(*) begin
        case(pad_pos)
            4'b1000: begin
                if(pad[0] == 1'b1) begin //1
                    ssd_current = ssd_lut[0];
                end
                else if(pad[1] == 1'b1) begin
                    ssd_current = ssd_lut[1];
                end
                else if(pad[2] == 1'b1) begin
                    ssd_current = ssd_lut[2];
                end
                else begin
                ssd_current = 8'b1111111_1;
                end
            end
            4'b0100: begin
                if(pad[0] == 1'b1) begin //4
                    ssd_current = ssd_lut[3];
                end
                else if(pad[1] == 1'b1) begin
                    ssd_current = ssd_lut[4];
                end
                else if(pad[2] == 1'b1) begin
                    ssd_current = ssd_lut[5];
                end
                else begin
                    ssd_current = 8'b1111111_1;
                end
            end
            4'b0010: begin
                if(pad[0] == 1'b1) begin //7
                    ssd_current = ssd_lut[6];
                end
                else if(pad[1] == 1'b1) begin
                    ssd_current = ssd_lut[7];
                end
                else if(pad[2] == 1'b1) begin
                    ssd_current = ssd_lut[8];
                end
                else begin
                    ssd_current = 8'b1111111_1;
                end
            end
            4'b0001: begin
                if(pad[0] == 1'b1) begin //*
                    ssd_current = ssd_lut[9];
                end
                else if(pad[1] == 1'b1) begin
                    ssd_current = ssd_lut[10];
                end
                else if(pad[2] == 1'b1) begin
                    ssd_current = ssd_lut[11];
                end
                else begin
                    ssd_current = 8'b1111111_1;
                end
            end
            default: begin
                ssd_current = 8'b1111111_1;
            end
        endcase
    end

    //output
    assign pad_pos_out = pad_pos;
    assign dig = 8'b0111_1111;
    assign ssd = ssd_current;

endmodule