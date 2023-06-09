`include "DataMemory.v"
`include "MUX.v"
module MemUnit_206(
    input               clk,
    //数据信号输入
    input[32-1:0]       ALU_ans_Mem,            //
    input[32-1:0]       busB_Mem,               //
    input[6-1:0]        OP_Mem,                 //
    input[5-1:0]        Reg_Target_Mem,         //
    input               ZF_Mem,                 //
    input               OF_Mem,                 //
    input               Sign_Mem,               //

    //控制信号输入
    input               Branch_Mem,             //
    input               MemToReg_Mem,           //
    input               RegWr_Mem,              //
    input               MemWr_Mem,              //
    input               Jal_Mem,                //
    input               Rtype_J_Mem,            //
    input               Rtype_L_Mem,            //
    input               WrByte_Mem,             //
    input[2-1:0]        LoadByte_Mem,           //

    //数据信号输出
    output[32-1:0]      ALU_ans_out_Mem,        //
    output[5-1:0]       Reg_Target_out_Mem,     //
    output[32-1:0]      Mem_Data_out            //

);

    wire[8-1:0]         Byte_Data_out;          //
    wire[32-1:0]        Byte_Data_ext;          //
    wire[32-1:0]        Word_Data_out;          //

    assign ALU_ans_out_Mem = ALU_ans_Mem;
    assign Reg_Target_out_Mem = Reg_Target_Mem;

    DM_4K_206 DM_4K(
        .clk            (clk),                  //

        .WrEn           (MemWr_Mem),            //
        .WrByte         (WrByte_Mem),           //
        .Addr           (ALU_ans_Mem[11:0]),    //
        .Din            (busB_Mem),             //
        .Dout           (Word_Data_out),        //
        .ByteDout       (Byte_Data_out)         //    
    );

    ExtUnit_LB_206 Ext_Byte(
        .in             (Byte_Data_out),
        .ExtOp          (LoadByte_Mem[0]),
        .out            (Byte_Data_ext)
    );

    MUX206 MUX_Byte_Word(
        .A              (Byte_Data_ext),
        .B              (Word_Data_out),
        .S              (LoadByte_Mem[1]),
        .Y              (Mem_Data_out)
    ); 


endmodule