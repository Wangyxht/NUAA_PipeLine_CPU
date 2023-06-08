`include "IUnit.v"
`include "IF_ID.v"
`include "IDUnit.v"
module PipeLine_CPU(
    input clk,  //
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

    // Reg/Dec(ID)段单元
    IDUnit_206 IDUnit(
        .clk(clk),
        .busW(32'h0000_0000),
        .Rw_Wr(5'b00000),
        .RegWr_Wr(1'b0),
        .OverFlow_Wr(1'b0),
        .Jal_Wr(1'b0),
        .func(Instruction_ID[5:0]),
        .OP(Instruction_ID[31:26]),
        .Rs(Instruction_ID[25:21]),
        .Rt(Instruction_ID[20:16]),
        .Rd(Instruction_ID[15:11]),
        .shamt(Instruction_ID[10:6]),
        .imm16(Instruction_ID[15:0]),
        .J_Target(Instruction_ID[25:0]),
        .PC_Addr(PC_Addr_ID)
    );


endmodule
