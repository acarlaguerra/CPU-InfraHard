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
    output wire RegABWrite,
    output wire MDRWrite

);

//States
parameter FETCH1 = 7'd0;
parameter FETCH2 = 7'd1;
parameter DECODE1 = 7'd2;
parameter DECODE2 = 7'd3;

parameter ALUOUTRD = 7'd10;
parameter UNEXOPCODE = 7'd40 // valor temporario
parameter EXECUTE = 7'd50; // valor temporario
parameter END = 7'd60; //
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
      STATE = FETCH1
      PCWrite      = 0;
      //PCWriteCond  = 0;
      MemWrite     = 0;
      IRWrite      = 0;
      RegWrite     = 1;  ///
      ALUOutWrite  = 0;
      EPCWrite     = 0;
      HILOWrite    = 0;
      RegABWrite   = 0;   
      MDRWrite     = 0;
      
      ALUOp        = 3'b000;
      SHIFTOp      = 3'b000;
      SSCtrl       = 2'b00;
      LSCtrl       = 2'b00;
      MultCtrl     = 0;
      DivCtrl      = 0;
      
      IorD         = 3'b000;
      EXCPCtrl     = 2'b00;
      RegDst       = 2'b01;   /// // gets 29 ($sp)
      DataSrc      = 4'b0100; /// // gets 227
      LoadAMem     = 0;
      LoadBMem     = 0;
      SHIFTAmt     = 2'b00;;
      SHIFTSrc     = 0;
      ALUSrcA      = 2'b00;
      ALUSrcB      = 2'b00;
      LOSrc        = 0;
      HISrc        = 0;
      PCSrc        = 2'b00;        
    end
    else begin
        case(CURRSTATE)
            FETCH1: begin
                RegWrite = 0;
                RegDst = 3'd0; // reset to rt
                DataSrc = 4'd0; // reset to ALUOutOut

                IorD = 3'd0; // PC address
                MemWrite = 0; // read from mem
                ALUSrcA = 2'd0; // PC address
                ALUOp = 3'b001; // +
                ALUSrcB = 2'd1; // 4
                PCSrc = 2'd0; // ALUResult
                PCWrite = 1;
                CURRSTATE = FETCH2;             
            end
            FETCH2: begin
                PCWrite = 0;
                LSCtrl = 0;
                SSCtrl = 0;
                IRWrite = 1;
                CURRSTATE = DECODE1;
            end
            DECODE1: begin // branch
                IRWrite = 0;
                ALUSrcA = 2'd0; // PC
                ALUSrcB = 2'd3; // ADDRESS << 2
                ALUOp = 3'b001; // +
                ALUOutWrite = 1;
                CURRSTATE = DECODE2; 
            end
            DECODE2: begin // A <= rs, B <= rt
                LoadAMem = 0;
                LoadBMem = 0;
                RegABWrite = 1;
                CURRSTATE = EXECUTE;
            end
            EXECUTE: begin
                RegABWrite = 0; 
                case(OPCODE)
                    // R FORMAT //
                    OPCODEZero: begin 
                        case(funct)
                                ADD: begin // rd <= rs + rt
                                    ALUSrcA = 2'd2; // rs
                                    ALUSrcB = 2'd0; // rt
                                    ALUOp = 3'b001; // +
                                    ALUOutWrite = 1;
                                    CURRSTATE = ALUOUTRD;
                                end
                                AND: begin // rd <= rs & rt
                                    ALUSrcA = 2'd2; // rs
                                    ALUSrcB = 2'd0; // rt
                                    ALUOp = 3'b011; // &
                                    ALUOutWrite = 1;
                                    CURRSTATE = ALUOUTRD;
                                end
                                DIV: begin
                                    // controles DIV
                                end
                                MULT: begin
                                    // controles MULT
                                end
                                JR: begin  // PC <= rs
                                    ALUSrcA = 2'd2; // rs
                                    ALUOp = 3'b000; // LOAD
                                    PCSrc = 2'd0;
                                    PCWrite = 1;
                                    CURRSTATE = END;
                                end
                                MFHI: begin // rd <= hi
                                    DataSrc = 3'd2; // HI
                                    RegDst =  2'd3; // rd
                                    RegWrite = 1;
                                    CURRSTATE = END;
                                end 
                                MFLO: begin // rd <= lo
                                    DataSrc = 3'd3; // LO
                                    RegDst =  2'd3; // rd
                                    RegWrite = 1;
                                    CURRSTATE = END; 
                                end
                                SLL: begin
                                    // controles SLL
                                end
                                SLLV: begin
                                    // controles SLLV
                                end  
                                SLT: begin
                                    // controles SLT
                                    ALUSrcA = 2'd2;
                                    ALUSrcB = 2'd0;
                                    ALUOp = 3'b111;
                                    DataSrc = 3'd6;
                                    RegDst = 2'd0;
                                    RegWrite = 1;
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
                                    ALUSrcA = 2'd2; // rs
                                    ALUSrcB = 2'd0; // rt
                                    ALUOp = 3'b010; // -
                                    ALUOutWrite = 1;
                                    CURRSTATE = ALUOUTRD;
                                end
                                BREAK: begin // PC dont change
                                    ALUSrcA = 2'd1;
                                    ALUSrcB = 2'd1;
                                    ALUOp = 3'b010;
                                    PCSrc = 2'd0;
                                    PCWrite = 1;
                                end
                                RTE: begin // PC <= EPC
                                    PCSrc = 2'd3; // EPC
                                    PCWrite = 1;
                                    CURRSTATE = END;
                                end
                                ADDM: begin
                                    // controles ADDM
                                end 
                        endcase
                    end

                    // J FORMAT //
                    J: begin 
                        PCSrc = 2'd2; // ConcatIPCOut
                        PCWrite = 1;
                        CURRSTATE = END;
                    end 
                    JAL: begin
                        // controles JAL
                        ALUSrcA = 2'd0;
                        
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
                        CURRSTATE = UNEXOPCODE;
                    end
                endcase
            end
            ALUOUTRD: begin
                // overflow
                ALUOutWrite = 0;
                RegDst = 3'd3; // rd
                DataSrc = 4'd0; // ALUOut 
                RegWrite = 1;
                CURRSTATE = END; 
            end

            END: begin // close wires
                STATE = FETCH1
                PCWrite      = 0;
                //PCWriteCond  = 0;
                MemWrite     = 0;
                IRWrite      = 0;
                RegWrite     = 0;  ///
                ALUOutWrite  = 0;
                EPCWrite     = 0;
                HILOWrite    = 0;
                RegABWrite   = 0;   
                MDRWrite     = 0;
                
                ALUOp        = 3'b000;
                SHIFTOp      = 3'b000;
                SSCtrl       = 2'b00;
                LSCtrl       = 2'b00;
                MultCtrl     = 0;
                DivCtrl      = 0;
                
                IorD         = 3'b000;
                EXCPCtrl     = 2'b00;
                RegDst       = 2'b01;   /// // gets 29 ($sp)
                DataSrc      = 4'b0100; /// // gets 227
                LoadAMem     = 0;
                LoadBMem     = 0;
                SHIFTAmt     = 2'b00;;
                SHIFTSrc     = 0;
                ALUSrcA      = 2'b00;
                ALUSrcB      = 2'b00;
                LOSrc        = 0;
                HISrc        = 0;
                PCSrc        = 2'b00;        
            end

        endcase
    end
end

endmodule