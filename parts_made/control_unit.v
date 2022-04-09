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
    output reg [2:0] ALUOp,
    output reg [2:0] SHIFTOp,
    output reg [1:0] SSCtrl,
    output reg [1:0] LSCtrl,
    output reg  MultCtrl,
    output reg  DivCtrl,

    // selectors muxes
    output reg [2:0] IorD, 
    output reg [1:0] EXCPCtrl,
    output reg [1:0] RegDst,
    output reg [3:0] DataSrc,
    output reg LoadAMem,
    output reg LoadBMem,
    output reg [1:0] SHIFTAmt,
    output reg SHIFTSrc,
    output reg [1:0] ALUSrcA,
    output reg [1:0] ALUSrcB, 
    output reg LOSrc,
    output reg HISrc,
    output reg [1:0] PCSrc,

    // regs write
    output reg PCWrite,
    output reg MemWrite,
    output reg IRWrite,
    output reg RegWrite,
    output reg ALUOutWrite,
    output reg EPCWrite,
    output reg HILOWrite,
    output reg RegABWrite,
    output reg MDRWrite

);

//States
parameter FETCH1 = 7'd0;
parameter FETCH2 = 7'd1;
parameter FETCH3 = 7'd2;
parameter DECODE1 = 7'd3;
parameter DECODE2 = 7'd4;
parameter EXECUTE = 7'd5;
parameter ALUOUTRD = 7'd10;
parameter SHIFTEND = 7'd11;
parameter UNEXOPCODE = 7'd40;  
parameter BEQ2 = 7'd56;
parameter BNE2 = 7'd57;
parameter BLE2 = 7'd58;
parameter BGT2 = 7'd59;

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
      PCWrite      = 0;
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
      
      IorD         = 3'd0;
      EXCPCtrl     = 2'd0;
      RegDst       = 2'd1;   /// // gets 29 ($sp)
      DataSrc      = 4'd4; /// // gets 227
      LoadAMem     = 0;
      LoadBMem     = 0;
      SHIFTAmt     = 2'd0;
      SHIFTSrc     = 0;
      ALUSrcA      = 2'd0;
      ALUSrcB      = 2'd0;
      LOSrc        = 0;
      HISrc        = 0;
      PCSrc        = 2'd0;
      CURRSTATE = FETCH1;        
    end
    else begin
        case(CURRSTATE)
            FETCH1: begin
                RegWrite = 0;
                RegDst = 2'd0; // reset to rt
                DataSrc = 4'd0; // reset to ALUOutOut

                IorD = 3'd0; // PC address
                MemWrite = 0; // read from mem
                ALUSrcA = 2'd0; // PC address
                ALUOp = 3'b001; // +
                ALUSrcB = 2'd1; // 4
                CURRSTATE = FETCH2;             
            end
            FETCH2: begin
                PCSrc = 2'd0; // ALUResult
                PCWrite = 1;
                CURRSTATE = FETCH3;  
            end
            FETCH3: begin
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
                ALUOutWrite = 0;
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
                                    RegWrite = 1;
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
                        ALUOutWrite = 1;
                        
                    end                   

                    // I FORMAT //
                    ADDI: begin
                        ALUSrcA = 2'd2; // rs
                        ALUSrcB = 2'd2; // rt
                        ALUOp = 3'b001; // Selector
                        ALUOutWrite = 1;
                        CURRSTATE = ALUOUTRD;
                        
                    end
                    ADDIU: begin
                        ALUSrcA = 2'd2; // rs
                        ALUSrcB = 2'd2; // rt
                        ALUOp = 3'b001; // Selector
                        ALUOutWrite = 1;
                        CURRSTATE = ALUOUTRD;
                    end
                    BEQ: begin
                        ALUSrcA = 2'd2; // rs
                        ALUSrcB = 2'd0; // rt
                        ALUOp = 3'b111; // Compare
                        CURRSTATE = BEQ2;
                    end
                    BNE: begin
                        ALUSrcA = 2'd2; // rs
                        ALUSrcB = 2'd0; // rt
                        ALUOp = 3'b111; // Compare
                        CURRSTATE = BNE2;
                    end
                    BLE: begin
                        ALUSrcA = 2'd2; // rs
                        ALUSrcB = 2'd0; // rt
                        ALUOp = 3'b111; // Compare
                        CURRSTATE = BLE2;
                    end
                    BGT: begin
                        ALUSrcA = 2'd2; // rs
                        ALUSrcB = 2'd0; // rt
                        ALUOp = 3'b111; // Compare
                        CURRSTATE = BGT2;
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
                RegDst = 2'd3; // rd
                DataSrc = 4'd0; // ALUOut 
                CURRSTATE = END; 
            end
            BEQ2: begin
                if (EQ == 1) begin
                    PCSrc = 2'd1;
                    PCWrite = 1;                
                end    
                CURRSTATE = END;
            end
            BNE2: begin
                if (EQ == 0) begin
                    PCSrc = 2'd1;
                    PCWrite = 1;                                    
                end
                CURRSTATE = END;
            end
            BLE2: begin
                if(GT == 0) begin
                    PCSrc = 2'd1;
                    PCWrite = 1;                    
                end
                CURRSTATE = END;
            end
            BGT2: begin
                if(GT == 1) begin
                    PCSrc = 2'd1;
                    PCWrite = 1;
                end
                CURRSTATE = END;
            end

            SHIFTEND: begin


            end

            END: begin // close wires
                PCWrite      = 0;
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
                RegDst       = 2'b00;   /// 
                DataSrc      = 4'b0000; /// 
                LoadAMem     = 0;
                LoadBMem     = 0;
                SHIFTAmt     = 2'b00;
                SHIFTSrc     = 0;
                ALUSrcA      = 2'b00;
                ALUSrcB      = 2'b00;
                LOSrc        = 0;
                HISrc        = 0;
                PCSrc        = 2'b00;
                CURRSTATE = FETCH1;        
            end

        endcase
    end
end

endmodule