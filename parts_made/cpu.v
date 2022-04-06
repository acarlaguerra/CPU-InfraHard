module cpu (
    input wire clk,
    input wire reset
);
// flags
    wire overflow;
    wire EQ;
    wire GT;
    wire zero;
    wire NG; 

// one purpose flag
    wire LT; // slt


// mux_ctrl selectors
    wire [2:0] IorD; 
    wire [1:0] EXCPCtrl;
    wire [1:0] RegDst;
    wire [3:0] DataSrc;
    wire LoadAMem;
    wire LoadBMem;
    wire [1:0] SHIFTAmt;
    wire SHIFTSrc;
    wire [1:0] ALUSrcA;
    wire [1:0] ALUSrcB; 
    wire LOSrc;
    wire HISrc;
    wire [1:0] PCSrc;

// write wires
    wire PCWrite;
    wire PCWriteCond; // ?
    wire MemWrite;
    wire IRWrite;
    wire MDRWrite;
    wire RegWrite;
    wire ALUOutWrite;
    wire EPCWrite;
    wire HILOWrite;
    wire RegAWrite;
    wire RegBWrite; 

 //  control wires
    wire LSCtrl; // nao sei o tamanho ainda
    wire SSCtrl; // nao sei o tamanho ainda

    wire 
endmodule          
