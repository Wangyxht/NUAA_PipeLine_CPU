module ID_EX_206(
    input           clk,                //时钟信号输入
    input           stall,              //阻塞信号输入

    //控制信号输入
    input           Branch_ID,           
    input           Jump_ID,             
    input           RegDst_ID,           
    input           ALUSrc_ID,           
    input[5-1:0]    ALUCtr_ID,           
    input           MemToReg_ID,             
    input           RegWr_ID,            
    input           MemWr_ID,            
    input[2-1:0]    ExtOp_ID,            
    input           Rtype_ID,            
    input           Jal_ID,          
    input           Rtype_J_ID,          
    input           Rtype_L_ID,          
    input           WrByte_ID,           
    input[2-1:0]    LoadByte_ID,     
    
    //数据输入     
    input[32-1:0]   busA_ID,            //输入Reg[Rs]      
    input[32-1:0]   busB_ID,            //输入Reg[Rt]   
    input[32-1:0]   PC_Addr_out_ID,     //输入PC地址
    input[32-1:0]   J_Addr_ID,          //输入跳转目标地址
    input[6-1:0]    func_out_ID,        //输入func域
    input[6-1:0]    OP_out_ID,          //输入OP域
    input[16-1:0]   imm16_ID,           //输入imm16
    input[5-1:0]    shamt_ID,           //输入shamt
    input[5-1:0]    Rt_ID,              //输入Rt
    input[5-1:0]    Rd_ID,              //输入Rd
    input[5-1:0]    Rs_ID,              //输入Rs

    //控制信号输出
    output reg          Branch_Ex,          
    output reg          Jump_Ex,            
    output reg          RegDst_Ex,          
    output reg          ALUSrc_Ex,          
    output reg[5-1:0]   ALUCtr_Ex,          
    output reg          MemToReg_Ex,        
    output reg          RegWr_Ex,           
    output reg          MemWr_Ex,           
    output reg[2-1:0]   ExtOp_Ex,           
    output reg          Rtype_Ex,           
    output reg          Jal_Ex,             
    output reg          Rtype_J_Ex,         
    output reg          Rtype_L_Ex,         
    output reg          WrByte_Ex,          
    output reg[2-1:0]   LoadByte_Ex,        

    //数据输出
    output reg[32-1:0]  busA_Ex,            
    output reg[32-1:0]  busB_Ex,            
    output reg[32-1:0]  PC_Addr_out_Ex,         
    output reg[32-1:0]  J_Addr_Ex,          
    output reg[6-1:0]   func_out_Ex,            
    output reg[6-1:0]   OP_out_Ex,          
    output reg[16-1:0]  imm16_Ex,   
    output reg[5-1:0]   shamt_Ex,
    output reg[5-1:0]   Rd_Ex,
    output reg[5-1:0]   Rt_Ex,
    output reg[5-1:0]   Rs_Ex       
);


    always @(posedge clk) begin
        if(!stall) begin
            // 控制信号保存
            Branch_Ex <= Branch_ID;
            Jump_Ex <= Jump_ID;
            RegDst_Ex <= RegDst_ID;
            ALUSrc_Ex <= ALUSrc_ID;
            ALUCtr_Ex <= ALUCtr_ID;
            MemToReg_Ex <= MemToReg_ID;
            RegWr_Ex <= RegWr_ID;
            MemWr_Ex <= MemWr_ID;
            ExtOp_Ex <= ExtOp_ID;
            Rtype_Ex <= Rtype_ID;
            Jal_Ex <= Jal_ID;
            Rtype_J_Ex <= Rtype_J_ID;
            Rtype_L_Ex <= Rtype_L_ID;
            WrByte_Ex <= WrByte_ID;
            LoadByte_Ex <= LoadByte_ID;
            shamt_Ex <= shamt_ID;

            // 数据信号保存
            busA_Ex <= busA_ID;
            busB_Ex <= busB_ID;
            PC_Addr_out_Ex <= PC_Addr_out_ID;
            J_Addr_Ex <= J_Addr_ID;
            func_out_Ex <= func_out_ID;
            OP_out_Ex <= OP_out_ID;
            imm16_Ex <= imm16_ID;
            Rd_Ex <= Rd_ID;
            Rt_Ex <= Rt_ID;
            Rs_Ex <= Rs_ID;

        end
    end 

endmodule