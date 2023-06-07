`include "IUnit.v"
`include "IF_ID.v"
`include "RegFile.v"
`include "ControlUnit.v"
module PipeLine_CPU(input clk,  //
                    input rst   //
                   );

    //IF段数据
    wire[32-1:0] Instruction_IF;    //IF段指令
    wire[32-1:0] PC_Addr_IF;        //IF段PC值

    //ID段数据
    wire[32-1:0] Instruction_ID;    //ID段指令
    wire[32-1:0] PC_Addr_ID;        //ID段PC值

    // IF段流水线取指令单元
    IUnit206 IUnit(
        .clk(clk),
        .rst(rst),
        .PC_Src(1'b0),
        .PC_Addr(PC_Addr_IF),
        .Instruction(Instruction_IF)
    );

    // IF - ID 段寄存器
    IF_ID_206 IF_ID(
        .clk(clk),
        .stall(1'b0),
        .Instruction_IN(Instruction_IF),
        .PC_Addr_IN(PC_Addr_IF),
        .Instruction(Instruction_ID),
        .PC_Addr(PC_Addr_ID)
    );

endmodule
