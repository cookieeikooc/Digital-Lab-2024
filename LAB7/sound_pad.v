`timescale 1ns / 1ps

module sound_pad(
    input clk,
    input [0:2] pad,
    output [0:3] pad_pos_out,
    output audio_out
    );


    //oscillator devide
    reg [6:0] div_r;
    reg [18:0] div_1;
    reg [18:0] div_2;
    reg [18:0] div_3;
    reg [18:0] div_4;
    reg [17:0] div_5;
    reg [17:0] div_6;
    reg [17:0] div_7;
    reg [17:0] div_8;
    reg [17:0] div_9;
    reg [17:0] div_10;
    reg [17:0] div_11;
    reg [16:0] div_12;
    initial begin
        div_r = 7'd0;
    end
    reg clk_r; //refresh clock
    always @(posedge clk) begin
        if (div_r < 7'd100) begin //1MHz 
            div_r <= div_r + 1;
        end
        else begin
            div_r <= 7'd0;
        end
        clk_r <= div_r[6];
    end
    reg clk_1; //262Hz
    always @(posedge clk) begin
        if (div_1 < 19'd381_679) begin //262Hz 
            div_1 <= div_1 + 1;
        end
        else begin
            div_1 <= 19'd0;
        end
        clk_1 <= div_1[18];
    end
    reg clk_2; //294Hz
    always @(posedge clk) begin
        if (div_2 < 19'd340_136) begin //294Hz 
            div_2 <= div_2 + 1;
        end
        else begin
            div_2 <= 19'd0;
        end
        clk_2 <= div_2[18];
    end
    reg clk_3; //330Hz
    always @(posedge clk) begin
        if (div_3 < 19'd303_030) begin //330Hz 
            div_3 <= div_3 + 1;
        end
        else begin
            div_3 <= 19'd0;
        end
        clk_3 <= div_3[18];
    end
    reg clk_4; //349Hz
    always @(posedge clk) begin
        if (div_4 < 19'd286_533) begin //349Hz 
            div_4 <= div_4 + 1;
        end
        else begin
            div_4 <= 19'd0;
        end
        clk_4 <= div_4[18];
    end
    reg clk_5; //392Hz
    always @(posedge clk) begin
        if (div_5 < 18'd255_102) begin //392Hz 
            div_5 <= div_5 + 1;
        end
        else begin
            div_5 <= 18'd0;
        end
        clk_5 <= div_5[17];
    end
    reg clk_6; //440Hz
    always @(posedge clk) begin
        if (div_6 < 18'd227_273) begin //440Hz 
            div_6 <= div_6 + 1;
        end
        else begin
            div_6 <= 18'd0;
        end
        clk_6 <= div_6[17];
    end
    reg clk_7; //494Hz
    always @(posedge clk) begin
        if (div_7 < 18'd202_429) begin //494Hz 
            div_7 <= div_7 + 1;
        end
        else begin
            div_7 <= 18'd0;
        end
        clk_7 <= div_7[17];
    end
    reg clk_8; //523Hz
    always @(posedge clk) begin
        if (div_8 < 18'd191_204) begin //523Hz 
            div_8 <= div_8 + 1;
        end
        else begin
            div_8 <= 18'd0;
        end
        clk_8 <= div_8[17];
    end
    reg clk_9; //587Hz
    always @(posedge clk) begin
        if (div_9 < 18'd170_358) begin //587Hz 
            div_9 <= div_9 + 1;
        end
        else begin
            div_9 <= 18'd0;
        end
        clk_9 <= div_9[17];
    end
    reg clk_10; //659Hz
    always @(posedge clk) begin
        if (div_10 < 18'd151_745) begin //659Hz 
            div_10 <= div_10 + 1;
        end
        else begin
            div_10 <= 18'd0;
        end
        clk_10 <= div_10[17];
    end
    reg clk_11; //698Hz
    always @(posedge clk) begin
        if (div_11 < 18'd143_266) begin //698Hz 
            div_11 <= div_11 + 1;
        end
        else begin
            div_11 <= 18'd0;
        end
        clk_11 <= div_11[17];
    end
    reg clk_12; //784Hz
    always @(posedge clk) begin
        if (div_12 < 17'd127_551) begin //784Hz 
            div_12 <= div_12 + 1;
        end
        else begin
            div_12 <= 17'd0;
        end
        clk_12 <= div_12[16];
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


    //EFG detection
    reg audio_signal = 1'b0;
    always @(*) begin
        case(pad_pos)
            4'b1000: begin
                if(pad[0] == 1'b1) begin //1
                    audio_signal = clk_1;
                end
                else if(pad[1] == 1'b1) begin
                    audio_signal = clk_2;
                end
                else if(pad[2] == 1'b1) begin
                    audio_signal = clk_3;
                end
                else begin
                audio_signal = 1'b0;
                end
            end
            4'b0100: begin
                if(pad[0] == 1'b1) begin //4
                    audio_signal = clk_4;
                end
                else if(pad[1] == 1'b1) begin
                    audio_signal = clk_5;
                end
                else if(pad[2] == 1'b1) begin
                    audio_signal = clk_6;
                end
                else begin
                    audio_signal = 1'b0;
                end
            end
            4'b0010: begin
                if(pad[0] == 1'b1) begin //7
                    audio_signal = clk_7;
                end
                else if(pad[1] == 1'b1) begin
                    audio_signal = clk_8;
                end
                else if(pad[2] == 1'b1) begin
                    audio_signal = clk_9;
                end
                else begin
                    audio_signal = 1'b0;
                end
            end
            4'b0001: begin
                if(pad[0] == 1'b1) begin //*
                    audio_signal = clk_10;
                end
                else if(pad[1] == 1'b1) begin
                    audio_signal = clk_11;
                end
                else if(pad[2] == 1'b1) begin
                    audio_signal = clk_12;
                end
                else begin
                    audio_signal = 1'b0;
                end
            end
            default: begin
                audio_signal = 1'b0;
            end
        endcase
    end

    //output
    assign pad_pos_out = pad_pos;
    assign audio_out = audio_signal;

endmodule