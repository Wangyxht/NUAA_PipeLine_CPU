// Load-Use冒险检测单元
module LoadUseUnit206 (
    input               MemToReg_ID_Ex,         //
    input[5-1:0]        Rt_ID_EX,               //
    input[5-1:0]        Rt_IF_ID,               //
    input[5-1:0]        Rs_IF_ID,               //

    output              Load_Use                // load-use发生控制信号
);

    assign Load_Use = MemToReg_ID_Ex && ((Rt_ID_EX === Rs_IF_ID) || (Rt_ID_EX === Rs_IF_ID));

endmodule //LoadUseUnit