`timescale 1ns / 1ps

module pad_counter(
    input clk,
    input [0:2] pad,
    output pad_pos_out,
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


    //pressed detection
    reg [3:0] pad_current = 4'd12;
    parameter PAD_IDLE = 4'd12;
    always @(*) begin
        if(pad[0] == 1'b1) begin //*
            pad_current = 4'd10;
        end
        else if(pad[1] == 1'b1) begin
            pad_current = PAD_IDLE;
        end
        else if(pad[2] == 1'b1) begin
            pad_current = 4'd11;
        end
        else begin
            pad_current = PAD_IDLE;
        end
    end

    //state machine
    parameter [1:0] IDLE = 2'b00;
    parameter [1:0] COUNTUP_PRESSED = 2'b01;
    parameter [1:0] COUNTDOWN_PRESSED = 2'b10;
    reg [1:0] current_state;
    reg [1:0] next_state;
    initial begin
        current_state <= IDLE;
        next_state <= IDLE;
    end
    always @(*) begin
        case(current_state)
            IDLE: begin
                if(pad_current == 4'd10) begin
                    next_state <= COUNTUP_PRESSED;
                end
                else if(pad_current == 4'd11) begin
                    next_state <= COUNTDOWN_PRESSED;
                end
                else begin
                    next_state <= IDLE;
                end
            end
            COUNTUP_PRESSED: begin
                if(pad_current == PAD_IDLE) begin
                    next_state <= IDLE;
                end
                else begin
                    next_state <= current_state;
                end
            end
            COUNTDOWN_PRESSED: begin
                if(pad_current == PAD_IDLE) begin
                    next_state <= IDLE;
                end
                else begin
                    next_state <= current_state;
                end
            end
            default: begin
                next_state <= IDLE;
            end
        endcase
    end
    always @(posedge clk_r) begin
        current_state <= next_state;
    end
    

    //counting
    reg [3:0] num = 4'd0;
    always @(posedge clk_r) begin
        case(current_state)
            IDLE: begin
                if(pad_current == 4'd10) begin
                    if(num == 4'd15) begin
                        num <= num;
                    end
                    else begin
                        num <= num + 1;
                    end
                end
                else if(pad_current == 4'd11) begin
                    if(num == 4'd0) begin
                        num <= num;
                    end
                    else begin
                        num <= num - 1;
                    end
                end
                else begin
                    num <= num;
                end
            end
            COUNTUP_PRESSED: begin
                num <= num;
            end
            COUNTDOWN_PRESSED: begin
                num <= num;
            end
            default: begin
                num <= num;
            end
        endcase
    end


    //SSD LUT
    reg [7:0] ssd_lut [0:15];
    initial begin
        ssd_lut[0] = 8'b0000001_1; //0
        ssd_lut[1] = 8'b1001111_1; //1
        ssd_lut[2] = 8'b0010010_1; //2
        ssd_lut[3] = 8'b0000110_1; //3
        ssd_lut[4] = 8'b1001100_1; //4
        ssd_lut[5] = 8'b0100100_1; //5
        ssd_lut[6] = 8'b0100000_1; //6
        ssd_lut[7] = 8'b0001111_1; //7
        ssd_lut[8] = 8'b0000000_1; //8
        ssd_lut[9] = 8'b0000100_1; //9
        ssd_lut[10] = 8'b0001000_1; //A
        ssd_lut[11] = 8'b1100000_1; //B
        ssd_lut[12] = 8'b0110001_1; //C
        ssd_lut[13] = 8'b1000010_1; //D
        ssd_lut[14] = 8'b0110000_1; //E
        ssd_lut[15] = 8'b0111000_1;  //F
    end


    assign pad_pos_out = 1'b1;
    assign dig = 8'b0111_1111;
    assign ssd = ssd_lut[num];

endmodule