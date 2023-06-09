`include "ALU.v"
`include "ExtUnit.v"
`include "MUX.v"

// Exec段 执行单元
module Exec_Unit_206(
    //Ex段数据输入
    input[32-1:0]       busA_Ex,            //    
    input[32-1:0]       busB_Ex,            //    
    input[32-1:0]       PC_Addr_Ex,         // 
    input[32-1:0]       J_Addr_Ex,          //  
    input[16-1:0]       imm16_Ex,           //    
    input[6-1:0]        OP_Ex,              //
    input[5-1:0]        shamt_Ex,           //
    input[5-1:0]        Rt_Ex,              //
    input[5-1:0]        Rd_Ex,              //

    //Ex段控制信号输入
    input               Branch_Ex,          //
    input               Jump_Ex,            //
    input               RegDst_Ex,          //
    input               ALUSrc_Ex,          //
    input[5-1:0]        ALUCtr_Ex,          //
    input               MemToReg_Ex,        //
    input               RegWr_Ex,           //
    input               MemWr_Ex,           //
    input[2-1:0]        ExtOp_Ex,           //
    input               Jal_Ex,             //
    input               Rtype_J_Ex,         //
    input               Rtype_L_Ex,         //
    input               WrByte_Ex,          //
    input[2-1:0]        LoadByte_Ex,        //

    //转发控制(旁路)
    input[2-1:0]        ALUSrcA_ByPassing,  //转发控制信号（A端口）
    input[2-1:0]        ALUSrcB_ByPassing,  //转发控制信号（B端口）    
    
    //转发数据输入(旁路)
    input[32-1:0]       Ex_Mem_ByPassing,   //Ex/Mem段寄存器的转发数据        
    input[32-1:0]       Mem_Wr_ByPassing,   //Mem/Wr段寄存器转发的数据

    //Ex段数据信号输出
    output[32-1:0]      ALU_ans_Ex,         //
    output[32-1:0]      busB_out_Ex,        //
    output[32-1:0]      B_Addr_Ex,          //
    output[32-1:0]      J_Addr_out_Ex,      //  
    output[5-1:0]       Reg_Target_Ex,      //    
    output              ZF_Ex,              //
    output              OF_Ex,              //
    output              Sign_Ex             //                
);

    //中间变量
    wire[32-1:0]        imm_16_Ext;         //16位立即数扩展
    wire[32-1:0]        ALU_input_A;        //ALU输入A
    wire[32-1:0]        ALU_input_B;        //ALU输入B

    assign busB_out_Ex = busB_Ex;
    assign B_Addr_Ex = PC_Addr_Ex + ($signed(imm_16_Ext) <<< 2);
    assign J_Addr_out_Ex = J_Addr_Ex;
    assign Reg_Target_Ex = RegDst_Ex ? Rd_Ex : Rt_Ex;

    ALU206 ALU(
        .ALUCtr             (ALUCtr_Ex),
        .A                  (ALU_input_A),                  //ALU A输入端口
        .B                  (ALU_input_B),                  //ALU B输入端口
        .shamt              (shamt_Ex),                   
        .result             (ALU_ans_Ex),                   //ALU 输出端口
        .OverFlow           (OF_Ex),                        //溢出标志
        .Zero               (ZF_Ex),                        //零标志
        .Sign               (Sign_Ex)                       //符号位标志
    );

    ExtUnit_DataPath_206 ExtUnit_Ex(
        .in                 (imm16_Ex),                     //
        .ExtOp              (ExtOp_Ex),                     //
        .out                (imm_16_Ext)                    //
    );

    //ALU A输入数据选择器（考虑旁路）
    MUX_4_206 MUX_ALUSrc_A(
        .A                  (),                             // 
        .B                  (),                             //
        .C                  (imm_16_Ext),                   //
        .D                  (busA_Ex),                      //
        .S                  ({1'b0,ALUSrc_Ex}),             //
        .Y                  (ALU_input_A)                   //
    );

    //ALU B输入数据选择器（考虑旁路）
    MUX_4_206 MUX_ALUSrc_B(
        .A                  (),
        .B                  (),
        .C                  (),
        .D                  (busB_Ex),
        .S                  (2'b00),
        .Y                  (ALU_input_B)
    );

endmodule

