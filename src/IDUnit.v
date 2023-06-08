`include "Regfile.v"
`include "ControlUnit.v"
`include "MUX.v"
//流水线Reg/Dec(ID)段 单元
module IDUnit_206(
    input               clk,            //时钟信号
    input[32-1:0]       busW,           //Wr段传回的数据总线
    input[5-1:0]        Rw_Wr,          //从Wr段的传入的Rw地址
    input               RegWr_Wr,       //从Wr段传入的寄存器写信号
    input               OverFlow_Wr,    //从Wr段传入的溢出信号
    input               Jal_Wr,         //从Wr段传入的Jal控制信号  
    input[6-1:0]        func,           //从IF-ID段寄存器传入的指令func域
    input[6-1:0]        OP,             //从IF-ID段寄存器传入的指令Op域
    input[5-1:0]        Rs,             //从IF-ID段寄存器传入的Rs地址
    input[5-1:0]        Rt,             //从IF-ID段寄存器传入的Rt地址
    input[5-1:0]        Rd,             //从IF-ID段寄存器传入的Rd地址
    input[5-1:0]        shamt,          //从IF-ID段寄存器传入的shamt
    input[16-1:0]       imm16,          //从IF-ID段寄存器传入的Rd地址16位立即数
    input[26-1:0]       J_Target,       //从IF-ID段寄存器传入的目标地址
    input[32-1:0]       PC_Addr,        //从IF-ID段寄存器传入的PC地址

    //输出数据
    output[32-1:0]      busA,           //输出Reg[Rs]       
    output[32-1:0]      busB,           //输出Reg[Rt]   
    output[32-1:0]      PC_Addr_out,    //输出PC地址
    output[32-1:0]      J_Addr,         //输出跳转目标地址
    output[6-1:0]       func_out,       //输出func域
    output[6-1:0]       OP_out,         //输出OP域
    output[16-1:0]      imm16_out,      //输出imm16

    //输出控制信号
    output          Branch,
    output          Jump,
    output          RegDst,
    output          ALUSrc,
    output[5-1:0]   ALUCtr,
    output          MemToReg,
    output          RegWr,
    output          MemWr,
    output[2-1:0]   ExtOp,
    output          Rtype,
    output          Jal,
    output          Rtype_J,
    output          Rtype_L,
    output          WrByte,
    output[2-1:0]   LoadByte
    );
    
    assign PC_Addr_out = PC_Addr;
    assign J_Addr = {PC_Addr[31:28], J_Target, 2'b00}; //跳转指令计算
    assign func_out = func;
    assign OP_out = OP;
    assign imm16_out = imm16;

    //寄存器组
    Regfile206 Regfile(
        .clk(clk),
        .Rw(Rw_Wr),
        .Ra(Rs),
        .Rb(Rt),
        .WrEn(~OverFlow_Wr & RegWr_Wr),
        .Jal(Jal_Wr),
        .busA(busA),
        .busB(busB),
        .busW(busW)
    );
    
    //指令控制器
    Control_Unit206 ControlUnit(
        .OP(OP),
        .func(func),
        .Branch(Branch),
        .Jump(Jump),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .ALUCtr(ALUCtr[5-1:0]),
        .MemToReg(MemToReg),
        .RegWr(RegWr),
        .MemWr(MemWr),
        .ExtOp(ExtOp),
        .Rtype(Rtype),
        .Jal(Jal),
        .Rtype_J(Rtype_J),
        .Rtype_L(Rtype_L),
        .WrByte(WrByte),
        .LoadByte(LoadByte)        
    );

endmodule
