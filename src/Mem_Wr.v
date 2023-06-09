module Mem_Wr_206(
    input       clk,

    //数据信号输入
    input[32-1:0]       ALU_ans_Mem,            //
    input[32-1:0]       Mem_Data_Mem,           //
    input[32-1:0]       PC_Addr_Mem,
    input[5-1:0]        Reg_Target_Mem,

    //控制信号输入
    input               MemToReg_Mem,           //
    input               RegWr_Mem,              //
    input               Rtype_L_Mem,            //
    input               Jal_Mem,                //

    //数据信号输出
    output reg[32-1:0]  ALU_ans_Wr,             //
    output reg[32-1:0]  Mem_Data_Wr,            //
    output reg[32-1:0]  PC_Addr_Wr,
    output reg[5-1:0]   Reg_Target_Wr,

    //控制信号输出
    output reg          MemToReg_Wr,
    output reg          RegWr_Wr,
    output reg          Rtype_L_Wr,
    output reg          Jal_Wr
);

    always @(posedge clk) begin
        //数据信号保存
        ALU_ans_Wr <= ALU_ans_Mem;
        Mem_Data_Wr <= Mem_Data_Mem;
        Reg_Target_Wr <= Reg_Target_Mem;
        PC_Addr_Wr <= PC_Addr_Mem;

        //控制信号保存
        MemToReg_Wr <= MemToReg_Mem;
        RegWr_Wr <= RegWr_Mem;
        Rtype_L_Wr <= Rtype_L_Mem;
        Jal_Wr <= Jal_Mem;
    end

endmodule