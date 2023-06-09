`include "IUnit.v"
`include "IF_ID.v"
`include "IDUnit.v"
`include "ID_Ex.v"
`include "ExecUnit.v"
//流水线CPU模块
module PipeLine_CPU(
    input clk,  //
    input rst   //
    );

//IF段数据信号
    wire[32-1:0]    Instruction_IF;    //IF段指令输出
    wire[32-1:0]    PC_Addr_IF;        //IF段PC值输出

//ID段数据与控制信号
    // ID段数据信号
    wire[32-1:0]    Instruction_ID;    //ID段指令输入
    wire[32-1:0]    PC_Addr_ID;        //ID段PC值输入
    wire[32-1:0]    busW_ID;           //ID段写入总线输入
    wire[32-1:0]    busA_ID;           //ID段A总线输出
    wire[32-1:0]    busB_ID;           //ID段B总线输出
    wire[32-1:0]    PC_Addr_ID_Out;    //ID段PC值输出
    wire[32-1:0]    J_Addr_ID;         //ID段跳转地址输出
    wire[6-1:0]     OP_ID;             //ID段OP域输出
    wire[16-1:0]    imm16_ID;          //ID段16位立即数输出
    wire[5-1:0]     shamt_ID;          //ID段shamt输出

    // ID段控制信号
    wire            Branch_ID;          
    wire            Jump_ID;            
    wire            RegDst_ID;          
    wire            ALUSrc_ID;          
    wire[5-1:0]     ALUCtr_ID;          
    wire            MemToReg_ID;            
    wire            RegWr_ID;           
    wire            MemWr_ID;           
    wire[2-1:0]     ExtOp_ID;           
    wire            Rtype_ID;           
    wire            Jal_ID;         
    wire            Rtype_J_ID;         
    wire            Rtype_L_ID;         
    wire            WrByte_ID;          
    wire[2-1:0]     LoadByte_ID;            

//Exec段信号
    // Ex段控制信号
    wire            Branch_Ex;      
    wire            Jump_Ex;        
    wire            RegDst_Ex;      
    wire            ALUSrc_Ex;      
    wire[5-1:0]     ALUCtr_Ex;      
    wire            MemToReg_Ex;    
    wire            RegWr_Ex;       
    wire            MemWr_Ex;       
    wire[2-1:0]     ExtOp_Ex;            
    wire            Jal_Ex;         
    wire            Rtype_J_Ex;     
    wire            Rtype_L_Ex;     
    wire            WrByte_Ex;      
    wire[2-1:0]     LoadByte_Ex;   

    // Ex段数据信号
    wire[32-1:0]    busA_Ex;     
    wire[32-1:0]    busB_Ex;      
    wire[32-1:0]    PC_Addr_out_Ex;
    wire[32-1:0]    J_Addr_Ex;   
    wire[6-1:0]     func_out_Ex;  
    wire[6-1:0]     OP_out_Ex;    
    wire[16-1:0]    imm16_Ex;   
    wire[5-1:0]     shamt_Ex;      

//Mem段信号

//流水线CPU各模块
    // IF段流水线取指令单元
    IUnit206 IUnit(
        .clk                    (clk),
        .rst                    (rst),
        .PC_Src                 (1'b0),
        .PC_Addr                (PC_Addr_IF),
        .Instruction            (Instruction_IF)
    );

    // IF - ID 段寄存器
    IF_ID_206 IF_ID(
        .clk                    (clk),
        .stall                  (1'b0),
        //数据输入
        .Instruction_IF         (Instruction_IF),
        .PC_Addr_IF             (PC_Addr_IF),
        //数据输出
        .Instruction_ID         (Instruction_ID),
        .PC_Addr_ID             (PC_Addr_ID)
    );

    // Reg/Dec(ID)段单元
    IDUnit_206 IDUnit(
        .clk(clk),
        //数据输入与输出
        .busW                   (32'h0000_0000),
        .Rw_Wr                  (5'b00000),
        .RegWr_Wr               (1'b0),
        .OverFlow_Wr            (1'b0),
        .Jal_Wr                 (1'b0),
        .func_ID                (Instruction_ID[5:0]),
        .OP_ID                  (Instruction_ID[31:26]),
        .Rs_ID                  (Instruction_ID[25:21]),
        .Rt_ID                  (Instruction_ID[20:16]),
        .Rd_ID                  (Instruction_ID[15:11]),
        .shamt_ID               (Instruction_ID[10:6]),
        .imm16_ID               (Instruction_ID[15:0]),
        .J_Target_ID            (Instruction_ID[25:0]),
        .PC_Addr_ID             (PC_Addr_ID),
        .busA_ID                (busA_ID),
        .busB_ID                (busB_ID),
        .PC_Addr_out_ID         (PC_Addr_ID_Out),
        .J_Addr_ID              (J_Addr_ID),
        .OP_out_ID              (OP_ID),
        .imm16_out_ID           (imm16_ID),
        .shamt_out_ID           (shamt_ID),

        //控制信号输出
        .Branch_ID              (Branch_ID),
        .Jump_ID                (Jump_ID),
        .RegDst_ID              (RegDst_ID),
        .ALUSrc_ID              (ALUSrc_ID),
        .ALUCtr_ID              (ALUCtr_ID),
        .MemToReg_ID            (MemToReg_ID),
        .RegWr_ID               (RegWr_ID),
        .MemWr_ID               (MemWr_ID),
        .ExtOp_ID               (ExtOp_ID),
        .Rtype_ID               (Rtype_ID),
        .Jal_ID                 (Jal_ID),
        .Rtype_J_ID             (Rtype_J_ID),
        .Rtype_L_ID             (Rtype_L_ID),
        .WrByte_ID              (WrByte_ID),
        .LoadByte_ID            (LoadByte_ID)
    );

    // ID - Ex 段寄存器
    ID_EX_206 ID_EX(
        .clk                    (clk),
        .stall                  (1'b0),
        //数据信号输入
        .busA_ID                (busA_ID),
        .busB_ID                (busB_ID),
        .PC_Addr_out_ID         (PC_Addr_ID_Out),
        .J_Addr_ID              (J_Addr_ID),
        .OP_out_ID              (OP_ID),
        .imm16_ID               (imm16_ID),
        .shamt_ID               (shamt_ID),

        //控制信号输入
        .Branch_ID              (Branch_ID),
        .Jump_ID                (Jump_ID),
        .RegDst_ID              (RegDst_ID),
        .ALUSrc_ID              (ALUSrc_ID),
        .ALUCtr_ID              (ALUCtr_ID),
        .MemToReg_ID            (MemToReg_ID),
        .RegWr_ID               (RegWr_ID),
        .MemWr_ID               (MemWr_ID),
        .ExtOp_ID               (ExtOp_ID),
        .Rtype_ID               (Rtype_ID),
        .Jal_ID                 (Jal_ID),
        .Rtype_J_ID             (Rtype_J_ID),
        .Rtype_L_ID             (Rtype_L_ID),
        .WrByte_ID              (WrByte_ID),
        .LoadByte_ID            (LoadByte_ID),

        //数据输出
        .busA_Ex                (busA_Ex),
        .busB_Ex                (busB_Ex),
        .PC_Addr_out_Ex         (PC_Addr_out_Ex),
        .J_Addr_Ex              (J_Addr_Ex),
        .OP_out_Ex              (OP_out_Ex),
        .imm16_Ex               (imm16_Ex),
        .shamt_Ex               (shamt_Ex),

        //控制信号输出
        .Branch_Ex              (Branch_Ex),
        .Jump_Ex                (Jump_Ex),
        .RegDst_Ex              (RegDst_Ex),
        .ALUSrc_Ex              (ALUSrc_Ex),
        .ALUCtr_Ex              (ALUCtr_Ex),
        .MemToReg_Ex            (MemToReg_Ex),
        .RegWr_Ex               (RegWr_Ex),
        .MemWr_Ex               (MemWr_Ex),
        .ExtOp_Ex               (ExtOp_Ex),
        .Rtype_Ex               (Rtype_Ex),
        .Jal_Ex                 (Jal_Ex),
        .Rtype_J_Ex             (Rtype_J_Ex),
        .Rtype_L_Ex             (Rtype_L_Ex),
        .WrByte_Ex              (WrByte_Ex),
        .LoadByte_Ex            (LoadByte_Ex)
    );
    // Exec(Ex)段单元
    Exec_Unit_206 ExecUnit(
        // 数据信号输入
        .busA_Ex                (busA_Ex),
        .busB_Ex                (busB_Ex),
        .PC_Addr_Ex             (PC_Addr_out_Ex),
        .J_Addr_Ex              (J_Addr_Ex),
        .imm16_Ex               (imm16_Ex),
        .OP_Ex                  (OP_out_Ex),
        .shamt_Ex               (shamt_Ex),

        //控制信号输入
        .Branch_Ex              (Branch_Ex),
        .Jump_Ex                (Jump_Ex),
        .RegDst_Ex              (RegDst_Ex),
        .ALUSrc_Ex              (ALUSrc_Ex),
        .ALUCtr_Ex              (ALUCtr_Ex),
        .MemToReg_Ex            (MemToReg_Ex),
        .RegWr_Ex               (RegWr_Ex),
        .MemWr_Ex               (MemWr_Ex),
        .ExtOp_Ex               (ExtOp_Ex),
        .Jal_Ex                 (Jal_Ex),
        .Rtype_J_Ex             (Rtype_J_Ex),
        .Rtype_L_Ex             (Rtype_L_Ex),
        .WrByte_Ex              (WrByte_Ex),
        .LoadByte_Ex            (LoadByte_Ex)
    );

endmodule
