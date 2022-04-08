module control_unit(
// input
    input wire clk,
    input wire reset,

    // flags
        // alu flags
    input wire overflow,
    input wire EQ,
    input wire GT,
    input wire zero,
    input wire NG,

    input wire DivZero,
    // input wire DivStop,
    // input wire multStop,

    // instructions
    input wire [5:0] OPCODE,
    input wire [5:0] funct,
// output
    // operations 
    output wire [2:0] ALUOp,
    output wire [2:0] SHIFTOp,
    output wire [1:0] SSCtrl,
    output wire [1:0] LSCtrl,
    output wire  MultCtrl,
    output wire  DivCtrl,

    // selectors muxes
    output wire [2:0] IorD, 
    output wire [1:0] EXCPCtrl,
    output wire [1:0] RegDst,
    output wire [3:0] DataSrc,
    output wire LoadAMem,
    output wire LoadBMem,
    output wire [1:0] SHIFTAmt,
    output wire SHIFTSrc,
    output wire [1:0] ALUSrcA,
    output wire [1:0] ALUSrcB, 
    output wire LOSrc,
    output wire HISrc,
    output wire [1:0] PCSrc,

    // regs write
    output wire PCWrite,
    output wire PCWriteCond, // ?
    output wire MemWrite,
    output wire IRWrite,
    output wire RegWrite,
    output wire ALUOutWrite,
    output wire EPCWrite,
    output wire HILOWrite,
    output wire RegAWrite,
    output wire RegBWrite, 
    output wire MDRWrite

);

endmodule