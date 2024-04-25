`timescale 10fs / 1fs

module sound_pad_tb();
    reg clk_out;
    reg [0:2] pad_out;
    wire [0:3] test_pad_pos;
    wire test_audio;
    
    initial begin
        clk_out = 1'b0;
        pad_out = 1'b0;
        #2;
    end

    always #1 clk_out = ~clk_out;

    always @(*) begin
        case(test_pad_pos)
            4'b1000: begin
                pad_out = 3'b100;
            end
            4'b0100: begin
                pad_out = 3'b000;
            end
            4'b0010: begin
                pad_out = 3'b000;
            end
            4'b0001: begin
                pad_out = 3'b000;
            end
            default: begin
                pad_out = 3'b000;
            end
        endcase
    end
    
    sound_pad UUT(
        .clk(clk_out),
        .pad(pad_out),
        .pad_pos_out(test_pad_pos),
        .audio_out(test_audio)
    );

endmodule
