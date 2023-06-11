`include "IUnit.v"
`include "IF_ID.v"
`include "IDUnit.v"
`include "ID_Ex.v"
`include "ExecUnit.v"
`include "Ex_Mem.v"
`include "MemUnit.v"
`include "Mem_Wr.v"
`include "WrUnit.v"
`include "ForwardingUnit.v"

//流水线CPU模块
module PipeLine_CPU(
    input           clk,                //
    input           rst                 //
    );

//IF段信号
    wire[32-1:0]    Instruction_IF;    //IF段指令输出
    wire[32-1:0]    PC_Addr_IF;        //IF段PC值输出

//ID段信号
    // ID段数据信号
    wire[32-1:0]    Instruction_ID;    //ID段指令输入
    wire[32-1:0]    PC_Addr_ID;        //ID段PC值输入
    wire[32-1:0]    busW_ID;           //ID段写入总线输入
    wire[32-1:0]    busA_ID;           //ID段A总线输出
    wire[32-1:0]    busB_ID;           //ID段B总线输出
    wire[32-1:0]    PC_Addr_out_ID;    //ID段PC值输出
    wire[32-1:0]    J_Addr_ID;         //ID段跳转地址输出
    wire[6-1:0]     OP_ID;             //ID段OP域输出
    wire[16-1:0]    imm16_ID;          //ID段16位立即数输出
    wire[5-1:0]     shamt_ID;          //ID段shamt输出
    wire[5-1:0]     Rd_out_ID;
    wire[5-1:0]     Rt_out_ID;
    wire[5-1:0]     Rs_out_ID;

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
    // Ex段数据信号
    wire[32-1:0]    busA_Ex;     
    wire[32-1:0]    busB_Ex;
    wire[32-1:0]    busB_out_Ex;      
    wire[32-1:0]    PC_Addr_out_Ex;
    wire[32-1:0]    J_Addr_Ex;  
    wire[32-1:0]    J_Addr_out_Ex; 
    wire[6-1:0]     func_out_Ex;  
    wire[6-1:0]     OP_out_Ex;    
    wire[16-1:0]    imm16_Ex;   
    wire[5-1:0]     shamt_Ex; 
    wire[5-1:0]     Rt_Ex;
    wire[5-1:0]     Rd_Ex;
    wire[5-1:0]     Rs_Ex;
    wire[32-1:0]    ALU_ans_Ex;
    wire[32-1:0]    B_Addr_Ex;
    wire[5-1:0]     Reg_Target_Ex;
    wire            ZF_Ex;
    wire            OF_Ex;
    wire            Sign_Ex;    

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

//Mem段信号
    //Mem段数据信号
    wire[32-1:0]       ALU_ans_Mem;   
    wire[32-1:0]       busB_Mem;   
    wire[32-1:0]       PC_Addr_Mem; 
    wire[6-1:0]        OP_Mem;        
    wire[5-1:0]        Reg_Target_Mem;
    wire               ZF_Mem;        
    wire               OF_Mem;        
    wire               Sign_Mem; 
    wire[32-1:0]       ALU_ans_out_Mem;
    wire[5-1:0]        Reg_Target_out_Mem; 
    wire[32-1:0]       Mem_Data_out_Mem; 

    //Mem段控制信号
    wire               Branch_Mem;  
    wire               MemToReg_Mem;
    wire               RegWr_Mem;   
    wire               MemWr_Mem;   
    wire               Jal_Mem;     
    wire               Rtype_J_Mem; 
    wire               Rtype_L_Mem; 
    wire               WrByte_Mem;  
    wire[2-1:0]        LoadByte_Mem; 

//Wr段信号
    //Wr段数据信号
    wire[32-1:0]        ALU_ans_Wr;
    wire[32-1:0]        Mem_Data_Wr;
    wire[32-1:0]        PC_Addr_Wr;
    wire[32-1:0]        busW;
    wire[5-1:0]         Reg_Target_Wr;

    //Wr段控制信号
    wire                MemToReg_Wr;
    wire                RegWr_Wr;
    wire                Rtype_L_Wr;
    wire                Jal_Wr;

//转发数据与控制信号
    wire[2-1:0]     ALUSrcA_ByPassing;  //转发控制信号（A端口）
    wire[2-1:0]     ALUSrcB_ByPassing;  //转发控制信号（B端口）   
    wire[2-1:0]     busBSrc_ByPassing;  //转发控制信号（busB端口）

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
        .busW                   (busW),
        .Rw_Wr                  (Reg_Target_Wr),
        .RegWr_Wr               (RegWr_Wr),
        .OverFlow_Wr            (1'b0),
        .Jal_Wr                 (Jal_Wr),
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
        .PC_Addr_out_ID         (PC_Addr_out_ID),
        .J_Addr_ID              (J_Addr_ID),
        .OP_out_ID              (OP_ID),
        .imm16_out_ID           (imm16_ID),
        .shamt_out_ID           (shamt_ID),
        .Rd_out_ID              (Rd_out_ID),
        .Rt_out_ID              (Rt_out_ID),
        .Rs_out_ID              (Rs_out_ID),

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
        .PC_Addr_out_ID         (PC_Addr_out_ID),
        .J_Addr_ID              (J_Addr_ID),
        .OP_out_ID              (OP_ID),
        .imm16_ID               (imm16_ID),
        .shamt_ID               (shamt_ID),
        .Rd_ID                  (Rd_out_ID),
        .Rt_ID                  (Rt_out_ID),
        .Rs_ID                  (Rs_out_ID),

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

        //数据信号输出
        .busA_Ex                (busA_Ex),
        .busB_Ex                (busB_Ex),
        .PC_Addr_out_Ex         (PC_Addr_out_Ex),
        .J_Addr_Ex              (J_Addr_Ex),
        .OP_out_Ex              (OP_out_Ex),
        .imm16_Ex               (imm16_Ex),
        .shamt_Ex               (shamt_Ex),
        .Rd_Ex                  (Rd_Ex),
        .Rt_Ex                  (Rt_Ex),
        .Rs_Ex                  (Rs_Ex),

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
        .Rt_Ex                  (Rt_Ex),
        .Rd_Ex                  (Rd_Ex),

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
        .LoadByte_Ex            (LoadByte_Ex),

        //数据信号输出
        .ALU_ans_Ex             (ALU_ans_Ex),   
        .busB_out_Ex            (busB_out_Ex),
        .B_Addr_Ex              (B_Addr_Ex),    
        .J_Addr_out_Ex          (J_Addr_out_Ex),
        .Reg_Target_Ex          (Reg_Target_Ex),
        .ZF_Ex                  (ZF_Ex),
        .OF_Ex                  (OF_Ex),
        .Sign_Ex                (Sign_Ex),

        //转发信号输入
        .ALUSrcA_ByPassing      (ALUSrcA_ByPassing),
        .ALUSrcB_ByPassing      (ALUSrcB_ByPassing),
        .busBSrc_ByPassing      (busBSrc_ByPassing),

        .Ex_Mem_ByPassing_A     (ALU_ans_Mem),
        .Mem_Wr_ByPassing_A     (busW),
        .Ex_Mem_ByPassing_B     (ALU_ans_Mem),
        .Mem_Wr_ByPassing_B     (busW)
    );

    // Ex - Mem 段寄存器
    Ex_Mem_206 Ex_Mem(
        .clk                    (clk),

        //数据信号输入
        .ALU_ans_Ex             (ALU_ans_Ex),
        .busB_Ex                (busB_out_Ex),
        .PC_Addr_Ex             (PC_Addr_out_Ex),
        .OP_Ex                  (OP_out_Ex),
        .Reg_Target_Ex          (Reg_Target_Ex),
        .ZF_Ex                  (ZF_Ex),
        .OF_Ex                  (OF_Ex),
        .Sign_Ex                (Sign_Ex),

        //控制信号输入
        .Branch_Ex              (Branch_Ex),
        .MemToReg_Ex            (MemToReg_Ex),
        .RegWr_Ex               (RegWr_Ex),
        .MemWr_Ex               (MemWr_Ex),
        .Jal_Ex                 (Jal_Ex),
        .Rtype_J_Ex             (Rtype_J_Ex),
        .Rtype_L_Ex             (Rtype_L_Ex),
        .WrByte_Ex              (WrByte_Ex),  
        .LoadByte_Ex            (LoadByte_Ex),

        //数据信号输出
        .ALU_ans_Mem            (ALU_ans_Mem),
        .busB_Mem               (busB_Mem),
        .PC_Addr_Mem            (PC_Addr_Mem),
        .OP_Mem                 (OP_Mem),
        .Reg_Target_Mem         (Reg_Target_Mem),
        .ZF_Mem                 (ZF_Mem),
        .OF_Mem                 (OF_Mem),
        .Sign_Mem               (Sign_Mem),

        //控制信号输出
        .Branch_Mem             (Branch_Mem),
        .MemToReg_Mem           (MemToReg_Mem),
        .RegWr_Mem              (RegWr_Mem),
        .MemWr_Mem              (MemWr_Mem),
        .Jal_Mem                (Jal_Mem),
        .Rtype_J_Mem            (Rtype_J_Mem),
        .Rtype_L_Mem            (Rtype_L_Mem),
        .WrByte_Mem             (WrByte_Mem),
        .LoadByte_Mem           (LoadByte_Mem)
    );

    // Mem 段单元
    MemUnit_206 MemUnit(
        .clk                    (clk),
        //数据信号输入
        .ALU_ans_Mem            (ALU_ans_Mem),    
        .busB_Mem               (busB_Mem),
        .OP_Mem                 (OP_Mem),
        .Reg_Target_Mem         (Reg_Target_Mem),
        .ZF_Mem                 (ZF_Mem),
        .OF_Mem                 (OF_Mem),
        .Sign_Mem               (Sign_Mem),

        //控制信号输入
        .Branch_Mem             (Branch_Mem),
        .MemToReg_Mem           (MemToReg_Mem),
        .RegWr_Mem              (RegWr_Mem),
        .MemWr_Mem              (MemWr_Mem),
        .Jal_Mem                (Jal_Mem),
        .Rtype_J_Mem            (Rtype_J_Mem),
        .Rtype_L_Mem            (Rtype_L_Mem),
        .WrByte_Mem             (WrByte_Mem),
        .LoadByte_Mem           (LoadByte_Mem),

        //数据信号输出
        .ALU_ans_out_Mem        (ALU_ans_out_Mem),
        .Reg_Target_out_Mem     (Reg_Target_out_Mem),
        .Mem_Data_out           (Mem_Data_out_Mem)
    );

    // Mem - Wr 段寄存器
    Mem_Wr_206 Mem_Wr(
        .clk                    (clk),
        //数据信号输入
        .ALU_ans_Mem            (ALU_ans_out_Mem),
        .Mem_Data_Mem           (Mem_Data_out_Mem),
        .Reg_Target_Mem         (Reg_Target_out_Mem),

        //控制信号输入
        .MemToReg_Mem           (MemToReg_Mem),
        .RegWr_Mem              (RegWr_Mem),
        .Rtype_L_Mem            (Rtype_L_Mem),
        .Jal_Mem                (Jal_Mem),

        //数据信号输出
        .ALU_ans_Wr             (ALU_ans_Wr),
        .Mem_Data_Wr            (Mem_Data_Wr),
        .PC_Addr_Wr             (PC_Addr_Wr),
        .Reg_Target_Wr          (Reg_Target_Wr),

        //控制信号输出
        .MemToReg_Wr            (MemToReg_Wr),
        .RegWr_Wr               (RegWr_Wr),
        .Rtype_L_Wr             (Rtype_L_Wr),
        .Jal_Wr                 (Jal_Wr)
    );

    //Wr 段单元
    WrUnit_206 WrUint(
        .ALU_ans_Wr             (ALU_ans_Wr),
        .Mem_Data_Wr            (Mem_Data_Wr),
        .PC_Addr_Wr             (PC_Addr_Wr),

        .MemToReg_Wr            (MemToReg_Wr),
        .Rtype_L_Wr             (Rtype_L_Wr),
        .Jal_Wr                 (Jal_Wr),

        .busW_Wr                (busW)
    );

    //数据转发检测单元
    Forwording_Unit_206 ForwardingUnit(
        .RegTarget_EX_Mem       (Reg_Target_Mem),
        .RegTarget_Mem_Wr       (Reg_Target_Wr),
        .Rs_ID_EX               (Rs_Ex),
        .Rt_ID_EX               (Rt_Ex),

        .RegWr_Ex_Mem           (RegWr_Mem),
        .RegWr_Mem_Wr           (RegWr_Wr),
        .ALUSrc_ID_Ex           (ALUSrc_Ex),
        .MemWr_ID_EX            (MemWr_Ex),

        .ALU_Src_A              (ALUSrcA_ByPassing),
        .ALU_Src_B              (ALUSrcB_ByPassing),
        .busBSrc                (busBSrc_ByPassing)
    );



endmodule
