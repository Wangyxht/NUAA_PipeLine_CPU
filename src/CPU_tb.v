`include "CPU.v"
//~ `New testbench
`timescale  1ns / 1ps     

module tb_PipeLine_CPU;   

// PipeLine_CPU Parameters
parameter PERIOD  = 10;   


// PipeLine_CPU Inputs
reg   clk                                  = 1 ;
reg   rst                                  = 1 ;

// PipeLine_CPU Outputs



initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD/2) rst  =  0;
end

PipeLine_CPU  u_PipeLine_CPU (
    .clk                     ( clk   ),
    .rst                     ( rst   )
);


integer fd;
initial 
begin
    fd = $fopen("./CPU_Output.txt","w");
end

integer     i = 0;
integer     clk_num = 0;
always @(negedge clk) begin
    #2;
    $fdisplay(fd,"-------------------------------------------");
    $fdisplay(fd,"[clock %2d↓]:", clk_num++);
    $fdisplay(fd,"各段执行指令地址:");
    $fdisplay(fd,"$| PC_IF | %h |", {u_PipeLine_CPU.IUnit.PC.I_Addr,2'b00});
    $fdisplay(fd,"$| PC_ID | %h |", u_PipeLine_CPU.IDUnit.PC_Addr_ID );
    $fdisplay(fd,"$| PC_Ex | %h |", u_PipeLine_CPU.ExecUnit.PC_Addr_Ex );
    $fdisplay(fd,"$| PC_Mem| %h |", u_PipeLine_CPU.MemUnit.PC_Addr_Mem );
    $fdisplay(fd,"$| PC_Wr | %h |", u_PipeLine_CPU.WrUnit.PC_Addr_Wr );
    $fdisplay(fd,"寄存器组状态:");
    for(i = 0; i <= 31; ++i)    
    begin
        $fdisplay(fd,"$| Reg%2d | %h |", i,u_PipeLine_CPU.IDUnit.Regfile.Register[i]);
    end
    $fdisplay(fd,"目标内存状态:");
    $fdisplay(fd,"Mem|0000_0014H| %h |" ,{u_PipeLine_CPU.MemUnit.DM_4K.DM[20+3],u_PipeLine_CPU.MemUnit.DM_4K.DM[20+2],u_PipeLine_CPU.MemUnit.DM_4K.DM[20+1],u_PipeLine_CPU.MemUnit.DM_4K.DM[20+0]});
    $fdisplay(fd,"Mem|0000_001CH| %h |" ,{u_PipeLine_CPU.MemUnit.DM_4K.DM[28+3],u_PipeLine_CPU.MemUnit.DM_4K.DM[28+2],u_PipeLine_CPU.MemUnit.DM_4K.DM[28+1],u_PipeLine_CPU.MemUnit.DM_4K.DM[28+0]});
end

initial
begin
    $dumpfile("CPU_Wave.vcd");
    $dumpvars(4);
    # (80*PERIOD);
    $finish;    
end

endmodule