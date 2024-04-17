`timescale 1ns / 1ps

module pad_adder_tb();
    reg clk_out;
    reg [0:2] pad_out;
    reg switch_sig;
    reg result_sig;
    reg reset_sig;
    wire [0:3] test_pad_pos;
    wire [7:0] test_dig;
    wire [7:0] test_ssd;
    
    reg clk_r;
    initial begin
        clk_r = 1'b0;
        clk_out = 1'b0;
        pad_out = 7'b0000000;
        switch_sig = 1'b0;
        result_sig = 1'b0;
        reset_sig = 1'b0;
        #20;
    end
    
    always #1 clk_out = ~clk_out;
    reg [1:0] enable;
    initial begin
        enable = 2'd0;
    end
    always @(posedge clk_out) begin
        if (enable < 2'd3) begin 
            enable <= enable + 1;
        end
        else begin
            enable <= 2'd0;
        end
        clk_r <= enable[1]; //pos = a scane period
    end

    reg [3:0] cycle = 4'd0;
    always @(posedge clk_r) begin
        if (cycle < 4'd11) begin 
            cycle <= cycle + 1;
        end
        else begin
            cycle <= 4'd11;
        end
    end
    
    always @(*) begin
        case(cycle)
            4'd0: begin
                pad_out = 3'b000;
                switch_sig = 1'b0;
                result_sig = 1'b0;
                reset_sig = 1'b0;
            end
            4'd1: begin
                if(enable == 2'd1) begin
                    pad_out = 3'b100;
                end
                else begin
                    pad_out = 3'b000;
                end
                switch_sig = 1'b0;
                result_sig = 1'b0;
                reset_sig = 1'b0;
            end
            4'd2: begin
                pad_out = 3'b000;
                switch_sig = 1'b0;
                result_sig = 1'b0;
                reset_sig = 1'b0;
            end
            4'd3: begin
                pad_out = 3'b000;
                switch_sig = 1'b1;
                result_sig = 1'b0;
                reset_sig = 1'b0;
            end
            4'd4: begin
                if(enable == 2'd1) begin
                    pad_out = 3'b010;
                end
                else begin
                    pad_out = 3'b000;
                end
                switch_sig = 1'b1;
                result_sig = 1'b0;
                reset_sig = 1'b0;
            end
            4'd5: begin
                pad_out = 3'b000;
                switch_sig = 1'b1;
                result_sig = 1'b0;
                reset_sig = 1'b0;
            end
            4'd6: begin
                pad_out = 3'b000;
                switch_sig = 1'b0;
                result_sig = 1'b0;
                reset_sig = 1'b0;
            end
            4'd7: begin
                pad_out = 3'b000;
                switch_sig = 1'b1;
                result_sig = 1'b0;
                reset_sig = 1'b0;
            end
            4'd8: begin
                pad_out = 3'b000;
                switch_sig = 1'b0;
                result_sig = 1'b0;
                reset_sig = 1'b0;
            end
            4'd9: begin
                pad_out = 3'b000;
                switch_sig = 1'b0;
                result_sig = 1'b1;
                reset_sig = 1'b0;
            end
            4'd10: begin
                pad_out = 3'b000;
                switch_sig = 1'b0;
                result_sig = 1'b0;
                reset_sig = 1'b1;
            end
            4'd11: begin
                pad_out = 3'b000;
                switch_sig = 1'b0;
                result_sig = 1'b0;
                reset_sig = 1'b0;
            end
            default: begin
                pad_out = 3'b000;
                switch_sig = 1'b0;
                result_sig = 1'b0;
            end
        endcase
    end

    
    pad_adder UUT(
        .clk(clk_out),
        .pad(pad_out),
        .switch(switch_sig),
        .result(result_sig),
        .reset(reset_sig),
        .pad_pos_out(test_pad_pos),
        .dig(test_dig),
        .ssd(test_ssd)
    );
endmodule