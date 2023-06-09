`include "MUX.v"
module WrUnit_206(
    //数据信号输入
    input[32-1:0]       ALU_ans_Wr,            //
    input[32-1:0]       Mem_Data_Wr,           //
    input[32-1:0]       PC_Addr_Wr,

    //控制信号输入
    input               MemToReg_Wr,           //
    input               Rtype_L_Wr,
    input               Jal_Wr,
      
    //数据信号输出
    output[32-1:0]       busW_Wr
);

    wire[32-1:0]        MUX_1_data;

    MUX206 MUX_ALU_Memory(
        .A          (Mem_Data_Wr),
        .B          (ALU_ans_Wr),
        .S          (MemToReg_Wr),
        .Y          (MUX_1_data)
    );

    MUX206 MUX_data_PCAddr(
        .A          (PC_Addr_Wr),
        .B          (MUX_1_data),
        .S          (Jal_Wr || Rtype_L_Wr),
        .Y          (busW_Wr)        
    );

endmodule