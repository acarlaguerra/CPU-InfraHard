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

//  write wires
    wire PCWrite;
    wire PCWriteCond; // ?
    wire MemWrite;
    wire IRWrite;
    wire RegWrite;
    wire ALUOutWrite;
    wire EPCWrite;
    wire HILOWrite;
    wire RegAWrite;
    wire RegBWrite; 
    wire MDRWrite;

//  control wires
    wire LSCtrl; // nao sei o tamanho ainda
    wire SSCtrl; // nao sei o tamanho ainda

// control wires mult





// control wires div




// data wires out from muxes
    wire [31:0] IorDOut;
    wire [4:0] RegDstOut;
    wire [31:0] DataSrcOut;
    wire [31:0] EXCPOut;
    wire [31:0] LoadAOut;
    wire [31:0] LoadBOut;
    wire [31:0] ALUSrcAOut;
    wire [31:0] ALUSrcBOut;
    wire [31:0] LOOut;
    wire [31:0] HIOut;
    wire [4:0] SHIFTAmtOut;
    wire [31:0] SHIFTSrcOut;
    wire [31:0] PCSrcOut;

// data wires out from regs
    wire [31:0] PCOut;
    wire [31:0] HIOut;
    wire [31:0] LOOut;
    wire [31:0] AOUt;
    wire [31:0] BOut;
    wire [31:0] ALUOutOut;
    wire [31:0] MDROut;
    wire [31:0] EPCOut;

// data wires out -- others
//// parts of instruction
    wire [5:0] OPCODE;
    wire [4:0] RS;
    wire [4:0] RT;
    wire [15:0] IMMEDIATE;
//
    wire [31:0] MEMOut;
    wire [31:0] SSOut; // STORE SIZE
    wire LSOut; // LL SIZE nao sei como ele eh/ tamanho  
    wire [31:0] SL16Out; // shift left que vai pro mux wd
    wire [27:0] SL26_28Out; // shift left 26-28
    wire [31:0] SL2Out; // shift left depois do SE 16-32
    wire [31:0] SE1_32Out; // sign extend 1 - 32 para o SLT
    wire [31:0] SE16_32Out; // sign extend 16 - 32
    wire [31:0] SHIFTRegOut;
    wire [31:0] ALUResult;
    // REGS
    Registrador PC_ (
        clk,
        reset,
        PCWrite,
        PCSrcOut,
        PCOut
    );
    



    // MUXES
    mux_IorD mux_IorD_(
        IorD, // selector
        PCOut,
        EXCPOut,

    );



      
     






endmodule          
