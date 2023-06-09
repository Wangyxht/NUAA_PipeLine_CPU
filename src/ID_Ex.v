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

    //控制信号输出
    output          Branch_Ex,          
    output          Jump_Ex,            
    output          RegDst_Ex,          
    output          ALUSrc_Ex,          
    output[5-1:0]   ALUCtr_Ex,          
    output          MemToReg_Ex,        
    output          RegWr_Ex,           
    output          MemWr_Ex,           
    output[2-1:0]   ExtOp_Ex,           
    output          Rtype_Ex,           
    output          Jal_Ex,             
    output          Rtype_J_Ex,         
    output          Rtype_L_Ex,         
    output          WrByte_Ex,          
    output[2-1:0]   LoadByte_Ex,        

    //数据输出
    output[32-1:0]  busA_Ex,            
    output[32-1:0]  busB_Ex,            
    output[32-1:0]  PC_Addr_out_Ex,         
    output[32-1:0]  J_Addr_Ex,          
    output[6-1:0]   func_out_Ex,            
    output[6-1:0]   OP_out_Ex,          
    output[16-1:0]  imm16_Ex,   
    output[5-1:0]   shamt_Ex,
    output[5-1:0]   Rd_Ex,
    output[5-1:0]   Rt_Ex       
);

    reg             Branch_Ex;         
    reg             Jump_Ex;           
    reg             RegDst_Ex;         
    reg             ALUSrc_Ex;         
    reg[5-1:0]      ALUCtr_Ex;         
    reg             MemToReg_Ex;       
    reg             RegWr_Ex;          
    reg             MemWr_Ex;          
    reg[2-1:0]      ExtOp_Ex;          
    reg             Rtype_Ex;          
    reg             Jal_Ex;            
    reg             Rtype_J_Ex;        
    reg             Rtype_L_Ex;        
    reg             WrByte_Ex;         
    reg[2-1:0]      LoadByte_Ex;       

    reg[32-1:0]     busA_Ex;         
    reg[32-1:0]     busB_Ex;         
    reg[32-1:0]     PC_Addr_out_Ex;  
    reg[32-1:0]     J_Addr_Ex;       
    reg[6-1:0]      func_out_Ex;     
    reg[6-1:0]      OP_out_Ex;       
    reg[16-1:0]     imm16_Ex; 
    reg[5-1:0]      shamt_Ex; 
    reg[5-1:0]      Rd_Ex;
    reg[5-1:0]      Rt_Ex;      

    always @(posedge clk) begin
        if(!stall) begin
            // 控制信号保存
            Branch_Ex <= Branch_ID;
            Jump_Ex <= Jump_ID;
            RegDst_Ex <= RegDst_ID;
            ALUSrc_Ex <= ALUSrc_ID;
            ALUCtr_Ex <= ALUCtr_ID;
            MemToReg_Ex <= MemToReg_ID;
            RegWr_Ex <= RegDst_ID;
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
            Rt_Ex <= Rt_Ex;

        end
    end 

endmodule