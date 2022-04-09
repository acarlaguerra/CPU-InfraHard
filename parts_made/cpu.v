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

// Operations
    wire [2:0] SHIFTOp;
    wire [2:0] ALUOp;
    wire [1:0]  LSCtrl;
    wire [1:0]  SSCtrl; 

//  write wires
    wire PCWrite;
    wire MemWrite;
    wire IRWrite;
    wire RegWrite;
    wire ALUOutWrite;
    wire EPCWrite;
    wire HILOWrite;
    wire RegABWrite;
    wire MDRWrite;


// control wires mult and div   //add multStop e DivStop
    wire  MultCtrl;
    wire  DivCtrl;
    wire  DivZero;


// data wires out from muxes
    wire [31:0] MUXIorDOut;
    wire [4:0] MUXRegDstOut;
    wire [31:0] MUXDataSrcOut;
    wire [31:0] MUXEXCPOut;
    wire [31:0] MUXLoadAOut;
    wire [31:0] MUXLoadBOut;
    wire [31:0] MUXALUSrcAOut;
    wire [31:0] MUXALUSrcBOut;
    wire [31:0] MUXLOOut;
    wire [31:0] MUXHIOut;
    wire [4:0] MUXSHIFTAmtOut;
    wire [31:0] MUXSHIFTSrcOut;
    wire [31:0] MUXPCSrcOut;

// data wires out from regs
    wire [31:0] PCOut;
    wire [31:0] HIOut;
    wire [31:0] LOOut;
    wire [31:0] AOut;
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
    wire [31:0] ReadData1Out; // rs
    wire [31:0] ReadData2Out; // rt
    wire [31:0] MEMOut;
    wire [31:0] SSOut; // STORE SIZE
    wire [31:0] LSOut; // LL SIZE
    wire [31:0] SL16Out; // shift left que vai pro mux wd
    wire [27:0] SL26_28Out; // shift left 26-28
    wire [31:0] SL2Out; // shift left depois do SE 16-32
    wire [31:0] SE1_32Out; // sign extend 1 - 32 para o SLT
    wire [31:0] SE16_32Out; // sign extend 16 - 32
    wire [31:0] SHIFTRegOut;
    wire [31:0] ALUResult;

    wire [31:0]  MultHOut;
    wire [31:0]  MultLOut;
    wire [31:0]  DivHOut;
    wire [31:0]  DivLOut;

    wire [25:0] ConcatINSTOut;
    wire [31:0] ConcatIPCOut;

// REGS
    Registrador PC_ (
        clk,
        reset,
        PCWrite,
        MUXPCSrcOut,
        PCOut
    );
 
    Registrador MDR_(
        clk,
        reset,
        MDRWrite,
        MEMOut,
        MDROut
    );

    Registrador HI_(
        clk,
        reset,
        HILOWrite,
        MUXHIOut,
        HIOut        
    );

    Registrador LO_(
        clk,
        reset,
        HILOWrite,
        MUXLOOut,
        LOOut        
    );

    Registrador A_(
        clk,
        reset,
        RegABWrite,
        MUXLoadAOut,
        AOut
    );

    Registrador B_(
        clk,
        reset,
        RegABWrite,
        MUXLoadBOut,
        BOut
    );

    Registrador ALUOut_(
        clk,
        reset,
        ALUOutWrite,
        ALUResult,
        ALUOutOut
    );

    Registrador EPC_(
        clk,
        reset,
        EPCWrite,
        ALUResult,
        EPCOut
    );

// SHIFT REG
    RegDesloc SHIFTReg_(
        clk,
        reset,
        SHIFTOp,
        MUXSHIFTAmtOut,
        MUXSHIFTSrcOut,
        SHIFTRegOut
    );

// ULA
    ula32 ALU_(
        MUXALUSrcAOut,
        MUXALUSrcBOut,
        ALUOp,
        ALUResult,
        overflow,
        NG,
        zero,
        EQ,
        GT,
        LT
    );

// MEMORY

    Memoria MEM_(
        MUXIorDOut,
        clk,
        MemWrite,
        SSOut,
        MEMOut
    );

// IR
    Instr_Reg IR_(
        clk,
        reset,
        IRWrite,
        MEMOut,
        OPCODE,
        RS,
        RT,
        IMMEDIATE
    );

// REGISTER BANK
    Banco_reg REGS_(
        clk,
        reset,
        RegWrite,
        RS,
        RT,
        MUXRegDstOut,
        MUXDataSrcOut,
        ReadData1Out,
        ReadData2Out
    );
      
// LOAD SIZE

    load_size LSize_(
        LSCtrl,
        MDROut,
        LSOut
    );
     
// STORE SIZE

    store_size SSize_(
        SSCtrl,
        MDROut,
        BOut,
        SSOut
    );

//MULT
    mult Mult_(
        clk,
        reset,
        MultCtrl,
        AOut,
        BOut,
        MultHOut,
        MultLOut
    );

//DIV
    div Div_(
        clk,
        reset,
        DivCtrl,
        AOut,
        BOut,
        DivZero,
        DivHOut,
        DivLOut       
    );

// CONCATS

    concat_inst concat_inst_(
         RS,
         RT,
         IMMEDIATE,
         ConcatINSTOut
    );

    concat_IPC concat_IPC_(
        SL26_28Out,
        PCOut,
        ConcatIPCOut
    );

// SHIFTS

    shift_left26 shift_left26_(
        ConcatINSTOut,
        SL26_28Out
    );

    shift_left16 shift_left16_(
        IMMEDIATE,
        SL16Out
    );

    shift_left2 shift_left2_(
        SE16_32Out,
        SL2Out   
    );

// SIGN EXTENDS
     sign_extend1_32 sign_extend1_32_(
         LT,
         SE1_32Out
     );

     sign_extend16_32 sign_extend16_32_(
         IMMEDIATE,
         SE16_32Out
     );

// MUXES
    //mux_IorD
    mux_IorD mux_IorD_( 
        IorD, 
        PCOut,
        EXCPOut,
        ALUResult,
        ALUOutOut,
        AOut,
        BOut,
        MUXIorDOut
    );
    
    mux_Except mux_Except_(
        EXCPCtrl,
        MUXEXCPOut
    );
    
    mux_LO mux_LO_(
        LOSrc,
        MultLOut,
        DivLOut,
        MUXLOOut
    );

    mux_HI mux_HI_( 
        HISrc,
        MultHOut,
        DivHOut,
        MUXHIOut
    );

    mux_wr mux_WR_(
        RegDst,
        RT,
        IMMEDIATE,
        MUXRegDstOut 
    );

    mux_wd mux_WD_(
        DataSrc,
        ALUOutOut,
        LSOut,
        HIOut,
        LOOut,
        SL16Out,
        SE1_32Out,
        SHIFTRegOut,
        PCOut 
    );
 
    mux_LdA mux_LdA_( 
        LoadAMem,
        ReadData1Out,
        MDROut,
        MUXLoadAOut
    );

    mux_LdB mux_LdB_( 
        LoadBMem,
        ReadData2Out,
        MDROut,
        MUXLoadBOut
    );

    mux_Sa mux_Sa_(
        SHIFTAmt,
        BOut,
        IMMEDIATE,
        MDROut,
        MUXSHIFTAmtOut
    );


    mux_Src mux_Src_( 
        SHIFTSrc,
        BOut,
        AOut,
        MUXSHIFTSrcOut
    );

    mux_aluA mux_aluA_(
        ALUSrcA,
        PCOut,
        AOut,
        MUXALUSrcAOut
    );

    mux_aluB mux_aluB_(
        ALUSrcB,
        BOut,
        SE16_32Out,
        SL2Out,
        MUXALUSrcBOut      
    );

    mux_pc mux_pc_( 
        PCSrc,
        ALUOutOut,
        ConcatIPCOut,
        EPCOut,
        MUXPCSrcOut
    );
// CTRL UNIT
    control_unit control_unit_(
        clk,
        reset,
        overflow,
        EQ,
        GT,
        zero,
        NG,
        DivZero,
        //DivStop,
        //multStop,
        OPCODE,
        funct,
        ALUOp,
        SHIFTOp,
        SSCtrl,
        LSCtrl,
        MultCtrl,
        DivCtrl,
        IorD,
        EXCPCtrl,
        RegDst,
        DataSrc,
        LoadAMem,
        LoadBMem,
        SHIFTAmt,
        SHIFTSrc,
        ALUSrcA,
        ALUSrcB,
        LOSrc,
        HISrc,
        PCSrc,
        PCWrite,
        MemWrite,
        IRWrite,
        RegWrite,
        ALUOutWrite,
        EPCWrite,
        HILOWrite,
        RegABWrite,
        MDRWrite
    );



endmodule          
