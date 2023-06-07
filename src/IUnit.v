`include "PC.v"
`include "InstructionMemory.v"
//流水线取指令单元
module IUnit206(input clk,
                input rst,
                input PC_Src,
                output[32-1:0] PC_Addr,
                output Instruction);

    wire[32-1:2] PC_out;

    PC206 PC(
        .clk(clk),
        .rst(rst),
        .I_Addr(PC_out)

    );

    IM_4K_206 IM(
        
    );
endmodule
