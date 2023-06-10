//数据转发控制单元
module Forwording_Unit_206(
    input[5-1:0]        RegTarget_EX_Mem,       // EX/MEM段寄存器目标寄存器编号
    input[5-1:0]        RegTarget_Mem_Wr,       // Mem/Wr段寄存器目标寄存器编号
    input[5-1:0]        Rs_ID_EX,               // ID/EX 段寄存器源寄存器编号
    input[5-1:0]        Rt_ID_EX,               // ID/EX 段寄存器源寄存器编号

    input               RegWr_Ex_Mem,           // Ex/Mem 段寄存器写寄存器控制信号
    input               RegWr_Mem_Wr,           // Mem_Wr 段寄存器写寄存器控制信号 
    input               ALUSrc_ID_Ex,           // ID_Ex 段寄存器ALUSrc信号

    output reg[2-1:0]   ALU_Src_A,              //ALU A端数据来源
    output reg[2-1:0]   ALU_Src_B               //ALU B端数据来源    
);

    always @(*) begin
    //此处判断数据转发给ALU A端
        // C1（A） 优先判断相邻两条指令的依赖情况
        if(RegTarget_EX_Mem === Rs_ID_EX && RegWr_Ex_Mem && RegTarget_EX_Mem !== 5'd0) begin
            ALU_Src_A <= 2'b10;
        end
        // C2（A） C3（A） 判断隔一条指令的依赖情况
        else if(RegTarget_Mem_Wr === Rs_ID_EX && RegWr_Mem_Wr && RegTarget_Mem_Wr !== 5'd0) begin
            ALU_Src_A <= 2'b11;            
        end
        // 无需转发
        else begin
            ALU_Src_A <=2'b00;
        end

    //此处判断数据转发ALU B端
        // imm16（B） 优先判断立即数
        if(ALUSrc_ID_Ex === 1'b1) begin
            ALU_Src_B <= 2'b01;
        end    
        // C1（B） 优先判断相邻两条指令的依赖情况
        else if(RegTarget_EX_Mem === Rt_ID_EX && RegWr_Ex_Mem && RegTarget_EX_Mem !== 5'd0) begin
            ALU_Src_B <= 2'b10;
        end
        // C2（B） C3（B） 判断隔一条指令的依赖情况
        else if(RegTarget_Mem_Wr === Rt_ID_EX && RegWr_Mem_Wr && RegTarget_Mem_Wr !== 5'd0) begin
            ALU_Src_B <= 2'b11;
        end
        //无需转发
        else begin
            ALU_Src_B <= 2'b00;
        end

    end
endmodule