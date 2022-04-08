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

//States
parameter FETCH1 = 7'd0;

parameter UNEXOPCODE = 7'd2 // valor temporario
parameter EXECUTE = 7'd5; // valor temporario
//declarar todos estados aqui e tal

//R instructions (funct) -- opcode = 0
parameter OPCODEZero = 6'd0;
parameter ADD = 6'h20;
parameter AND = 6'h24;
parameter DIV = 6'h1a;
parameter MULT = 6'h18;
parameter JR = 6'h8;
parameter MFHI = 6'h10;
parameter MFLO = 6'h12;
parameter SLL = 6'h0;
parameter SLLV = 6'h4;
parameter SLT = 6'h2a;
parameter SRA = 6'h3;
parameter SRAV = 6'h7;
parameter SRL = 6'h2;
parameter SUB = 6'h22;
parameter BREAK = 6'hD;
parameter RTE = 6'h13;
parameter ADDM = 6'h5;


//I instructions (opcode)
parameter ADDI = 6'h8;
parameter ADDIU = 6'h9;
parameter BEQ = 6'h4;
parameter BNE = 6'h5;
parameter BLE = 6'h6;
parameter BGT = 6'h7;
parameter SLLM = 6'h1;
parameter LB = 6'h20;
parameter LH = 6'h21;
parameter LUI = 6'hF;
parameter LW = 6'h23;
parameter SB = 6'h28;
parameter SH = 6'h29;
parameter SLTI = 6'hA;
parameter SW = 6'h2a;


//J instructions (opcode)
parameter J = 6'h2;
parameter JAL = 6'h3;

reg[6:0] CURRSTATE;
initial begin
        CURRSTATE = FETCH1;
end

always @(posedge clk) begin
    if(reset == 1'b1) begin
        // fazer reset e tals
    end
    else begin
        case(CURRSTATE)
            FETCH1: begin
                // fazer fetch1
            end
            
            // outros estados aqui
        
            EXECUTE: begin
                case(OPCODE)
                    // R FORMAT //
                    OPCODEZero: begin 
                        case(funct)
                                ADD: begin
                                    // controles ADD
                                end
                                AND: begin
                                    // controles AND
                                end
                                DIV: begin
                                    // controles DIV
                                end
                                MULT: begin
                                    // controles MULT
                                end
                                JR: begin
                                    // controles JR
                                end
                                MFHI: begin
                                    // controles MFHI
                                end 
                                MFLO: begin
                                    // controles MFLO
                                end
                                SLL: begin
                                    // controles SLL
                                end
                                SLLV: begin
                                    // controles SLLV
                                end  
                                SLT: begin
                                    // controles SLT
                                end                                                                                                      
                                SRA: begin
                                    // controles SRA
                                end  
                                SRAV: begin
                                    // controles SRAV
                                end  
                                SRL: begin
                                    // controles SRL
                                end
                                SUB: begin
                                    // controles SUB
                                end
                                BREAK: begin
                                    // controles BREAK
                                end
                                RTE: begin
                                    // controles RTE
                                end
                                ADDM: begin
                                    // controles ADDM
                                end 
                        endcase
                    end

                    // J FORMAT //
                    J: begin
                        // controles J
                    end 
                    JAL: begin
                        // controles JAL
                    end                   

                    // I FORMAT //
                    ADDI: begin
                        // controles ADDI
                    end
                    ADDIU: begin
                        // controles ADDIU
                    end
                    BEQ: begin
                        // controles BEQ
                    end
                    BNE: begin
                        // controles BNE
                    end
                    BLE: begin
                        // controles BLE
                    end
                    BGT: begin
                        // controles BGT
                    end
                    SLLM: begin
                        // controles SLLM
                    end
                    LB: begin
                        // controles LB
                    end
                    LH: begin
                        // controles LH
                    end
                    LUI: begin
                        // controles LUI
                    end
                    LW: begin
                        // controles LW
                    end
                    SB: begin
                        // controles SB
                    end
                    SH: begin
                        // controles SH
                    end
                    SLTI: begin
                        // controles SLTI
                    end
                    SW: begin
                        // controles SW
                    end

                    // OPCODE inexistente
                    default: begin
                        STATE = UNEXOPCODE;
                    end
                endcase
            end

        endcase
    end
end

endmodule