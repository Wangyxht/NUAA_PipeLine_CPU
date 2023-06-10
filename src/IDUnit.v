`include "Regfile.v"
`include "ControlUnit.v"
`include "MUX.v"
//流水线Reg/Dec(ID)段 单元
module IDUnit_206(
    //输入数据
    input               clk,                //时钟信号
    input[32-1:0]       busW,               //Wr段传回的数据总线
    input[5-1:0]        Rw_Wr,              //从Wr段的传入的Rw地址
    input               RegWr_Wr,           //从Wr段传入的寄存器写信号
    input               OverFlow_Wr,        //从Wr段传入的溢出信号
    input               Jal_Wr,             //从Wr段传入的Jal控制信号  
    input[6-1:0]        func_ID,            //从IF-ID段寄存器传入的指令func域
    input[6-1:0]        OP_ID,              //从IF-ID段寄存器传入的指令Op域
    input[5-1:0]        Rs_ID,              //从IF-ID段寄存器传入的Rs地址
    input[5-1:0]        Rt_ID,              //从IF-ID段寄存器传入的Rt地址
    input[5-1:0]        Rd_ID,              //从IF-ID段寄存器传入的Rd地址
    input[5-1:0]        shamt_ID,           //从IF-ID段寄存器传入的shamt
    input[16-1:0]       imm16_ID,           //从IF-ID段寄存器传入的Rd地址16位立即数
    input[26-1:0]       J_Target_ID,        //从IF-ID段寄存器传入的目标地址
    input[32-1:0]       PC_Addr_ID,         //从IF-ID段寄存器传入的PC地址

    //输出数据
    output[32-1:0]      busA_ID,            //输出Reg[Rs]       
    output[32-1:0]      busB_ID,            //输出Reg[Rt]   
    output[32-1:0]      PC_Addr_out_ID,     //输出PC地址
    output[32-1:0]      J_Addr_ID,          //输出跳转目标地址
    output[6-1:0]       func_out_ID,        //输出func域
    output[6-1:0]       OP_out_ID,          //输出OP域
    output[16-1:0]      imm16_out_ID,       //输出imm16
    output[5-1:0]       shamt_out_ID,       //输出shamt
    output[5-1:0]       Rd_out_ID,         
    output[5-1:0]       Rt_out_ID,
    output[5-1:0]       Rs_out_ID,

    //输出控制信号
    output              Branch_ID,
    output              Jump_ID,
    output              RegDst_ID,
    output              ALUSrc_ID,
    output[5-1:0]       ALUCtr_ID,
    output              MemToReg_ID,
    output              RegWr_ID,
    output              MemWr_ID,
    output[2-1:0]       ExtOp_ID,
    output              Rtype_ID,
    output              Jal_ID,
    output              Rtype_J_ID,
    output              Rtype_L_ID,
    output              WrByte_ID,
    output[2-1:0]       LoadByte_ID
    );
    
    assign PC_Addr_out_ID = PC_Addr_ID;
    assign J_Addr_ID = {PC_Addr_ID[31:28], J_Target_ID, 2'b00}; //跳转指令计算
    assign func_out_ID = func_ID;
    assign OP_out_ID = OP_ID;
    assign imm16_out_ID = imm16_ID;
    assign shamt_out_ID = shamt_ID;
    assign Rd_out_ID = Rd_ID;
    assign Rt_out_ID = Rt_ID;
    assign Rs_out_ID = Rs_ID;

    //寄存器组
    Regfile206 Regfile(
        .clk        (clk),
        .Rw         (Rw_Wr),
        .Ra         (Rs_ID),
        .Rb         (Rt_ID),
        .WrEn       (~OverFlow_Wr & RegWr_Wr),
        .Jal        (Jal_Wr),
        .busA       (busA_ID),
        .busB       (busB_ID),
        .busW       (busW)
    );
    
    //指令控制器
    Control_Unit206 ControlUnit(
        .OP         (OP_ID),
        .func       (func_ID),
        .Branch     (Branch_ID),
        .Jump       (Jump_ID),
        .RegDst     (RegDst_ID),
        .ALUSrc     (ALUSrc_ID),
        .ALUCtr     (ALUCtr_ID[5-1:0]),
        .MemToReg   (MemToReg_ID),
        .RegWr      (RegWr_ID),
        .MemWr      (MemWr_ID),
        .ExtOp      (ExtOp_ID),
        .Rtype      (Rtype_ID),
        .Jal        (Jal_ID),
        .Rtype_J    (Rtype_J_ID),
        .Rtype_L    (Rtype_L_ID),
        .WrByte     (WrByte_ID),
        .LoadByte   (LoadByte_ID)        
    );
    
endmodule
