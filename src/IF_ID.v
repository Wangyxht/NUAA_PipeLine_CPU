// IF—ID段寄存器
module IF_ID_206(input clk,
                 input stall,
                 input[32-1:0] Instruction_IN,
                 input[32-1:0] PC_Addr_IN,
                 output[32-1:0] Instruction,
                 output[32-1:0] PC_Addr);
    reg[32-1:0] Instruction;
    reg[32-1:0] PC_Addr;

    always @(posedge clk) begin
        if(!stall) begin
            Instruction <= Instruction_IN;
            PC_Addr <= PC_Addr_IN;
        end
    end
endmodule
