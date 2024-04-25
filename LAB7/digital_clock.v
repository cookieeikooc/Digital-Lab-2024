`timescale 1ns / 1ps

module digital_clock(
    input clk, //100MHz
    input direction,
    input shift_enable,
    input min_test_enable,
    input hr_test_enable,
    output [7:0] dig,
    output [7:0] ssd
    );

    //oscillator devide
    reg [25:0] div_s;
    reg [17:0] div_r;
    reg [26:0] div_sec;
    reg [20:0] div_min_test;
    reg [14:0] div_hr_test;
    initial begin
        div_s = 26'd0;
        div_r = 17'd0;
        div_sec = 27'd0;
    end
    
    reg clk_s; //shift clock
    reg clk_r; //refresh clock
    reg clk_sec; //relative second clock
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

        if (min_test_enable == 1'b1) begin
            if (div_sec < 27'd1_666_666) begin //60Hz
                div_sec <= div_sec + 1;
            end
            else begin
                div_sec <= 27'd0;
            end
            clk_sec <= div_sec[20];
        end
        else if (hr_test_enable == 1'b1) begin
            if (div_sec < 27'd27_778) begin //120Hz
                div_sec <= div_sec + 1;
            end
            else begin
                div_sec <= 27'd0;
            end
            clk_sec <= div_sec[14];
        end
        else begin
            if (div_sec < 27'd100_000_000) begin //1Hz
                div_sec <= div_sec + 1;
            end
            else begin
                div_sec <= 27'd0;
            end
            clk_sec <= div_sec[26];
        end  
    end
    

    //current time
    reg [3:0] current_time[0:19];
    initial begin
        current_time[0] = 4'd2;  //YYYY
        current_time[1] = 4'd0;
        current_time[2] = 4'd2;
        current_time[3] = 4'd4;
        current_time[4] = 4'd10; //-
        current_time[5] = 4'd0;  //MM
        current_time[6] = 4'd4;
        current_time[7] = 4'd10; //-
        current_time[8] = 4'd2;  //DD
        current_time[9] = 4'd5;
        current_time[10] = 4'd10; //-
        current_time[11] = 4'd0;  //hr
        current_time[12] = 4'd0;
        current_time[13] = 4'd10; //-
        current_time[14] = 4'd0;  //min
        current_time[15] = 4'd0;
        current_time[16] = 4'd10; //-
        current_time[17] = 4'd0;  //sec
        current_time[18] = 4'd0;
        current_time[19] = 4'd11; //empty
    end
    always @(posedge clk_sec) begin
        //second
        if (current_time[17] == 4'd5 && current_time[18] == 4'd9) begin
            current_time[17] <= 4'd0;
            current_time[18] <= 4'd0;
            //minute
            if (current_time[14] == 4'd5 && current_time[15] == 4'd9) begin
                current_time[14] <= 4'd0;
                current_time[15] <= 4'd0;
                //hour
                if (current_time[11] == 4'd2 && current_time[12] == 4'd3) begin
                    current_time[11] <= 4'd0;
                    current_time[12] <= 4'd0;
                    //day
                    if (current_time[8] == 4'd3 && current_time[9] == 4'd0) begin
                        current_time[8] <= 4'd0;
                        current_time[9] <= 4'd0;
                        current_time[6] <= current_time[6] + 1;
                    end
                    else if (current_time[8] != 4'd3 && current_time[9] == 4'd9) begin
                        current_time[8] <= current_time[8] + 1;
                        current_time[9] <= 4'd0;
                    end
                    else begin
                        current_time[9] <= current_time[9] + 1;
                    end
                    //day end
                end
                else if (current_time[11] != 4'd2 && current_time[12] == 4'd9) begin
                    current_time[11] <= current_time[11] + 1;
                    current_time[12] <= 4'd0;
                end
                else begin
                    current_time[12] <= current_time[12] + 1;
                end
                //hour end
            end
            else if (current_time[14] != 4'd5 && current_time[15] == 4'd9) begin
                current_time[14] <= current_time[14] + 1;
                current_time[15] <= 4'd0;
            end
            else begin
                current_time[15] <= current_time[15] + 1;
            end
            //minute end
        end
        else if (current_time[17] != 4'd5 && current_time[18] == 4'd9) begin
                current_time[17] <= current_time[17] + 1;
                current_time[18] <= 4'd0;
        end
        else begin
            current_time[18] <= current_time[18] + 1;
        end
        //second end
    end    


    //memory address shifting
    reg [4:0] address[0:19];
    initial begin
        address[0] = 5'd0;
        address[1] = 5'd1;
        address[2] = 5'd2;
        address[3] = 5'd3;
        address[4] = 5'd4;
        address[5] = 5'd5;
        address[6] = 5'd6;
        address[7] = 5'd7;
        address[8] = 5'd8;
        address[9] = 5'd9;
        address[10] = 5'd10;
        address[11] = 5'd11;
        address[12] = 5'd12;
        address[13] = 5'd13;
        address[14] = 5'd14;
        address[15] = 5'd15;
        address[16] = 5'd16;
        address[17] = 5'd17;
        address[18] = 5'd18;
        address[19] = 5'd19;
    end
    always @(posedge clk_s) begin
        if(direction == 1'b0 && shift_enable == 1'b1) begin
            address[0] <= address[19];
            address[1] <= address[0];
            address[2] <= address[1];
            address[3] <= address[2];
            address[4] <= address[3];
            address[5] <= address[4];
            address[6] <= address[5];
            address[7] <= address[6];
            address[8] <= address[7];
            address[9] <= address[8];
            address[10] <= address[9];
            address[11] <= address[10];
            address[12] <= address[11];
            address[13] <= address[12];
            address[14] <= address[13];
            address[15] <= address[14];
            address[16] <= address[15];
            address[17] <= address[16];
            address[18] <= address[17];
            address[19] <= address[18];
        end
        else if (direction == 1'b1 && shift_enable == 1'b1) begin
            address[0] <= address[1];
            address[1] <= address[2];
            address[2] <= address[3];
            address[3] <= address[4];
            address[4] <= address[5];
            address[5] <= address[6];
            address[6] <= address[7];
            address[7] <= address[8];
            address[8] <= address[9];
            address[9] <= address[10];
            address[10] <= address[11];
            address[11] <= address[12];
            address[12] <= address[13];
            address[13] <= address[14];
            address[14] <= address[15];
            address[15] <= address[16];
            address[16] <= address[17];
            address[17] <= address[18];
            address[18] <= address[19];
            address[19] <= address[0];
        end
        else begin
            address[0] <= address[0];
            address[1] <= address[1];
            address[2] <= address[2];
            address[3] <= address[3];
            address[4] <= address[4];
            address[5] <= address[5];
            address[6] <= address[6];
            address[7] <= address[7];
            address[8] <= address[8];
            address[9] <= address[9];
            address[10] <= address[10];
            address[11] <= address[11];
            address[12] <= address[12];
            address[13] <= address[13];
            address[14] <= address[14];
            address[15] <= address[15];
            address[16] <= address[16];
            address[17] <= address[17];
            address[18] <= address[18];
            address[19] <= address[19];
        end
    end


    //SSD LUT
    reg [7:0] ssd_lut[0:11];
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
        ssd_lut[10] = 8'b1111110_1;
        ssd_lut[11] = 8'b1111111_1;
    end


    //BCD to SSD Memory
    reg [7:0] memory[0:7];
    always @(*) begin
        memory[0] = ssd_lut[current_time[address[0]]];
        memory[1] = ssd_lut[current_time[address[1]]];
        memory[2] = ssd_lut[current_time[address[2]]];
        memory[3] = ssd_lut[current_time[address[3]]];
        memory[4] = ssd_lut[current_time[address[4]]];
        memory[5] = ssd_lut[current_time[address[5]]];
        memory[6] = ssd_lut[current_time[address[6]]];
        memory[7] = ssd_lut[current_time[address[7]]];
    end


    //SSD refresh
    reg [2:0] position = 3'b000;
    always @(posedge clk_r) begin
        if (position == 3'b111) begin // reset
            position <= 3'b000;
        end 
        else begin
            position <= position + 1;
        end
    end
    
    reg [7:0] ssd_current = 8'b1111111_1;
    reg [7:0] dig_r = 8'b1111_1111;
    always @(*) begin
        case(position)
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
                ssd_current = 8'b1111111_1;
            end
        endcase
    end

    
    //dig & ssd output
    assign dig = dig_r;
    assign ssd = ssd_current;
    
endmodule
