`timescale 1ns / 1ps

module pad_counter_tb();
    reg clk_out;
    reg [0:2] pad_sig;
    wire test_pad_pos;
    wire [7:0] test_dig;
    wire [7:0] test_ssd;

    initial begin
        clk_out = 1'b0;
        pad_sig = 3'b000;
        #2;
    end

    always #1 clk_out = ~clk_out;

    reg [2:0] div = 3'd0;
    reg clk_t;
    always @(posedge clk_out) begin
        if (div < 3'b111) begin
            div <= div + 1;
        end
        else begin
            div <= 3'd0;
        end
        clk_t <= div[2];
    end

    reg [3:0] cycle = 4'b0000;
    always @(posedge clk_t) begin
        if (cycle < 4'b1111) begin
            cycle <= cycle + 1;
        end
        else begin
            cycle <= 4'd0;
        end
    end

    always @(*) begin
        case(cycle)
            4'b0000: begin
                pad_sig = 3'b100;
            end
            4'b0001: begin
                pad_sig = 3'b010;
            end
            4'b0010: begin
                pad_sig = 3'b100;
            end
            4'b0011: begin
                pad_sig = 3'b000;
            end
            4'b0100: begin
                pad_sig = 3'b100;
            end
            4'b0101: begin
                pad_sig = 3'b000;
            end
            4'b0110: begin
                pad_sig = 3'b001;
            end
            4'b0111: begin
                pad_sig = 3'b000;
            end
            4'b1000: begin
                pad_sig = 3'b001;
            end
            4'b1001: begin
                pad_sig = 3'b000;
            end
            4'b1010: begin
                pad_sig = 3'b100;
            end
            4'b1011: begin
                pad_sig = 3'b000;
            end
            4'b1100: begin
                pad_sig = 3'b100;
            end
            4'b1101: begin
                pad_sig = 3'b100;
            end
            4'b1110: begin
                pad_sig = 3'b000;
            end
            4'b1111: begin
                pad_sig = 3'b100;
            end
            default: begin
                pad_sig = 3'b000;
            end
        endcase
    end


    pad_counter UUT(
        .clk(clk_out),
        .pad(pad_sig),
        .pad_pos_out(test_pad_pos),
        .dig(test_dig),
        .ssd(test_ssd)
    );

endmodule