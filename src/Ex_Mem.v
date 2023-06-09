module Ex_Mem_206(
    input clk,
    //数据信号输入
    input[32-1:0]       ALU_ans_Ex,                 //
    input[32-1:0]       busB_Ex,                    //
    input[6-1:0]        OP_Ex,                      //
    input[5-1:0]        Reg_Target_Ex,              //
    input               ZF_Ex,                      //
    input               OF_Ex,                      //
    input               Sign_Ex,                    //

    //控制信号输入
    input               Branch_Ex,                  //
    input               MemToReg_Ex,                //
    input               RegWr_Ex,                   //
    input               MemWr_Ex,                   //
    input               Jal_Ex,                     //
    input               Rtype_J_Ex,                 //
    input               Rtype_L_Ex,                 //
    input               WrByte_Ex,                  //
    input[2-1:0]        LoadByte_Ex,                //

    //数据信号输出
    output reg[32-1:0]       ALU_ans_Mem,           //
    output reg[32-1:0]       busB_Mem,              //
    output reg[6-1:0]        OP_Mem,                //
    output reg[5-1:0]        Reg_Target_Mem,        //
    output reg               ZF_Mem,                //
    output reg               OF_Mem,                //
    output reg               Sign_Mem,              //

    //控制信号输出
    output reg               Branch_Mem,             //
    output reg               MemToReg_Mem,           //
    output reg               RegWr_Mem,              //
    output reg               MemWr_Mem,              //
    output reg               Jal_Mem,                //
    output reg               Rtype_J_Mem,            //
    output reg               Rtype_L_Mem,            //
    output reg               WrByte_Mem,             //
    output reg[2-1:0]        LoadByte_Mem            //
);

    always @(posedge clk) begin
        //数据信号保存
        ALU_ans_Mem <= ALU_ans_Ex;
        busB_Mem <= busB_Ex;
        OP_Mem <= OP_Ex;
        Reg_Target_Mem <= Reg_Target_Ex;
        ZF_Mem <= ZF_Ex;
        OF_Mem <= OF_Ex;
        Sign_Mem <= Sign_Ex;

        //控制信号保存
        Branch_Mem <= Branch_Ex;
        MemToReg_Mem <= MemToReg_Ex;
        RegWr_Mem <= RegWr_Ex;
        MemWr_Mem <= MemWr_Ex;
        Jal_Mem <= Jal_Ex;
        Rtype_J_Mem <= Rtype_J_Ex;
        Rtype_L_Mem <= Rtype_J_Ex;
        WrByte_Mem <= WrByte_Ex;
        LoadByte_Mem <= LoadByte_Ex;
    end
endmodule