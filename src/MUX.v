`ifndef MUX_MODULE
`define MUX_MODULE
module MUX206 #(parameter WIDTH = 32) (
        input[WIDTH-1:0]                A,      //高位 [!]
        input[WIDTH-1:0]                B,      //低位 [!] 
        input                           S,
        output[WIDTH-1:0]               Y
);
    
    assign Y = (S == 1) ? A : B;
endmodule
    
module MUX_4_206 #(parameter WIDTH = 32) (
        input[WIDTH-1:0]                A,      //高位[!]
        input[WIDTH-1:0]                B,      
        input[WIDTH-1:0]                C,
        input[WIDTH-1:0]                D,      //低位[!]
        input[2-1:0]                    S,
        output[WIDTH-1:0]               Y
);
    
    reg[WIDTH - 1: 0] Y;
    always @(*) begin
        case (S)
            2'b00:Y <= D;
            2'b01:Y <= C;
            2'b10:Y <= B;
            2'b11:Y <= A;
        endcase
    end
endmodule
        
`endif
