// IF—ID段寄存器
module IF_ID_206(
    input                   clk,                //时钟信号  
    input                   flush,              //清空信号，用于分支预测错误 
    input                   stall,              //阻塞信号，用于LoadUse冒险

    input[32-1:0]           Instruction_IF,     //IF段指令字
    input[32-1:0]           PC_Addr_IF,         //IF段指令字地址

    input                   BranchPredict_IF,
      
    output reg[32-1:0]      Instruction_ID,      //          
    output reg[32-1:0]      PC_Addr_ID,          //
    output reg              BranchPredict_ID     // 
    );
    always @(posedge clk) begin
        if(!stall || stall === 1'bX) begin
            if(!flush || flush === 1'bX) begin
                Instruction_ID <= Instruction_IF;
                PC_Addr_ID <= PC_Addr_IF;
                BranchPredict_ID <= BranchPredict_IF;
            end
            else begin
                Instruction_ID <= 32'b0000_0000; // NOP 指令字
                PC_Addr_ID <= 32'bXXXX_XXXX;
                BranchPredict_ID <= 1'b0;
            end
        end
    end
endmodule
