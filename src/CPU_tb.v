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

initial
begin
    $dumpfile("CPU_Wave.vcd");
    $dumpvars(4);
    # (50*PERIOD);
    $finish;    
end

endmodule