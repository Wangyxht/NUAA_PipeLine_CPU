`include "PC.v"
`include "MUX.v"
`include "ExtUnit.v"
`include "InstructionMemory.v"
//流水线取指令单元
module IUnit206(
    input               clk,            //时钟信号
    input               rst,            //重置
    input               stall,          //阻塞

    input               PC_Src,         //PC下地址控制信号
    input[32-1:2]       Target_PC_Addr, //PC分支、跳转目标地址
    
    output[32-1:0]      PC_Addr,        //PC地址
    output[32-1:0]      Instruction,    //指令字
    output[32-1:0]      B_Addr_IF
    );

    wire[32-1:2]        PC_out;
    wire[32-1:2]        PC_Plus_4;
    wire[32-1:2]        PCSrc_MUX_out;
    wire[16-1:0]        B_imm16 = Instruction[15:0];
    wire[32-1:0]        B_imm16_ext;

    
    assign PC_Plus_4 = PC_out + 1'b1;
    assign PC_Addr = {PC_out, 2'b00};
    assign B_Addr_IF = PC_Addr + (B_imm16_ext << 2);
    
    //PC 地址来源数据源选择器
    MUX206 #30 MUX_PCSrc(
        .A              (Target_PC_Addr),               //任意J/Branch/RTypr-J所计算出的地址
        .B              (PC_Plus_4),                    //PC+4
        .S              (PC_Src && PC_Src !== 1'bX),    //控制信号
        .Y              (PCSrc_MUX_out)                 //下地址输出
    );

    //PC寄存器
    PC206 PC(
        .clk            (clk),
        .rst            (rst),
        .stall          (stall),
        .I_Addr         (PC_out),
        .Next_I_Addr    (PCSrc_MUX_out)
    );

    //指令寄存器
    IM_4K_206 IM(
        .Addr   (PC_out[11:2]),
        .Dout   (Instruction)   
    );

    ExtUnit_DataPath_206 Ext_B_imm16(
        .in(B_imm16),
        .ExtOp(2'b01),
        .out(B_imm16_ext)
    );

endmodule
