module BranchPredictUnit_206 (
    input               clk,
    input               BranchCtr_Mem,
    input               BranchPredict_Mem,   
    input[32-1:0]       PC_Addr_Mem,            // Ex段运行的指令地址
    input[32-1:0]       PC_Addr_IF,             // IF段运行的指令地址

    output reg          BranchPredict_IF,       // 分支预测选通控制信号
    output reg          BranchPredict_fault     // IF/ID 清零信号
);
    reg[(32+2)-1 : 0]   BHT [1024-1:0];
    integer i = 0;
    always @(posedge clk) begin:FIND_ADDR_IF;
        #1;
        //在分支历史记录表中查询到该分支指令
        for(i = 0; i <= 1024 - 1; i = i + 1) begin
            if(PC_Addr_IF === BHT[i][32-1:0]) begin
                case (BHT[i][33:32])
                    2'b11: BranchPredict_IF <= 1'b1;
                    2'b10: BranchPredict_IF <= 1'b1;
                    2'b01: BranchPredict_IF <= 1'b0;
                    2'b00: BranchPredict_IF <= 1'b0;
                endcase
                disable FIND_ADDR_IF;
            end   
        end
        // 否则
        BranchPredict_IF <= 1'b0;


    end

    always @(negedge clk) begin:CHANGE_STATUS
        #1;
        //在分支历史记录表中查询到该分支指令
        for(i = 0; i <= 1024 - 1; i = i + 1) begin 
            if(PC_Addr_Mem === BHT[i][32-1:0]) begin
                case (BHT[i][33:32])
                    2'b11:begin 
                        BHT[i][33:32] <= BranchCtr_Mem ? 2'b11 : 2'b10;
                    end
                    2'b10:begin 
                        BHT[i][33:32] <= BranchCtr_Mem ? 2'b11 : 2'b00;
                    end
                    2'b00:begin 
                        BHT[i][33:32] <= BranchCtr_Mem ? 2'b01 : 2'b00;
                    end
                    2'b01:begin 
                        BHT[i][33:32] <= BranchCtr_Mem ? 2'b11 : 2'b00;
                    end
                endcase
                disable CHANGE_STATUS;
            end   
            
        end
    end

    always @(*) begin: FIND_ADDR_ID
        //在分支历史记录表中查询到该分支指令
        for(i = 0; i <= 1024 - 1; i = i + 1) begin
            if(PC_Addr_Mem === BHT[i][32-1:0]) begin
                if(BranchPredict_Mem === 1'bX || BranchCtr_Mem === 1'bX) BranchPredict_fault <= 1'b0;
                else BranchPredict_fault <= BranchCtr_Mem != BranchPredict_Mem ? 1'b1 : 1'b0;
                disable FIND_ADDR_ID;
            end
        end   
        // 否则
        BranchPredict_fault <= 1'b0;
    end
    
    initial begin
        $readmemb("BHT.txt", BHT);
    end

endmodule