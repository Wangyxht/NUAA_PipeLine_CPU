// IF—ID段寄存器
module IF_ID_206(
    input                   clk,              //  
    input                   stall,            //  
    input[32-1:0]           Instruction_IF,   //          
    input[32-1:0]           PC_Addr_IF,       //
      
    output[32-1:0]          Instruction_ID,      //          
    output[32-1:0]          PC_Addr_ID           //  
    );

    reg[32-1:0] Instruction_ID;
    reg[32-1:0] PC_Addr_ID;

    always @(posedge clk) begin
        if(!stall) begin
            Instruction_ID <= Instruction_IF;
            PC_Addr_ID <= PC_Addr_IF;
        end
    end
endmodule
