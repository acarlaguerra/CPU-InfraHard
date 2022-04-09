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
parameter ALUOUTRT = 7'd9;
parameter ALUOUTRD = 7'd10;
parameter SHIFTENDRD = 7'd11;
parameter SHIFTENDRT = 7'd12;
parameter EXECPTOPCODE = 7'd20;
parameter EXCEPTOVERFLOW1 = 7'd21;

parameter SLLM2 = 7'd32;
parameter SLLM3 = 7'd33;
parameter SLLM4 = 7'd34;
parameter ADDM2 = 7'd35;
parameter ADDM3 = 7'd36;
parameter ADDM4 = 7'd37;
parameter ADDM5 = 7'd38;
parameter JAL2 = 7'd39;
parameter JAL3 = 7'd40;
parameter SB2 = 7'd41;
parameter LW2 = 7'd42;
parameter LW3 = 7'd43;
parameter LW4 = 7'd44;
parameter LH2 = 7'd45;
parameter LH3 = 7'd46;
parameter LH4 = 7'd47;
parameter LB2 = 7'd48; 
parameter LB3 = 7'd49; 
parameter LB4 = 7'd50;  
parameter SLLV2 = 7'd51; 
parameter SRAV2 = 7'd52; 
parameter SLL2 = 7'd53;  
parameter SRL2 = 7'd54;
parameter SRA2 = 7'd55;
parameter BEQ2 = 7'd56;
parameter BNE2 = 7'd57;
parameter BLE2 = 7'd58;
parameter BGT2 = 7'd59;

parameter END = 7'd60; //

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
                                SLL: begin // rd <= rt << shant
                                    SHIFTSrc = 0; // rt
                                    SHIFTAmt = 2'd1; // shamt
                                    SHIFTOp = 3'b001; // LOAD                                     
                                    CURRSTATE = SLL2;
                                end
                                SLLV: begin // rd <= rs << rt
                                    SHIFTSrc = 1; // rs
                                    SHIFTAmt = 2'd0; // rt
                                    SHIFTOp = 3'b001; // LOAD
                                    CURRSTATE = SLLV2;
                                end  
                                SLT: begin // rd <= (rs < rt) ? 1 : 0 
                                    ALUSrcA = 2'd2; // rs
                                    ALUSrcB = 2'd0; // rt
                                    ALUOp = 3'b111; // COMPARE
                                    DataSrc = 3'd6; // LT
                                    RegDst = 2'd0; // rd
                                    RegWrite = 1;
                                    CURRSTATE = END;
                                end                                                                                                      
                                SRA: begin // rd <= rt >> shamt*
                                    SHIFTSrc = 0 ; // rt
                                    SHIFTAmt = 2'd1; // shamt
                                    SHIFTOp = 3'b001; // LOAD 
                                    CURRSTATE = SRA2;
                                end  
                                SRAV: begin   // rd <= rs >> rt*
                                    SHIFTSrc = 1; // rs
                                    SHIFTAmt = 2'd0; // rt
                                    SHIFTOp = 3'b001; // LOAD  
                                    CURRSTATE = SRAV2;
                                end  
                                SRL: begin // rd <= rt >> shamt
                                    SHIFTSrc = 0; // rt
                                    SHIFTAmt = 2'd1; // shamt
                                    SHIFTOp = 3'b001; // LOAD                                  
                                    CURRSTATE = SRL2;
                                end
                                SUB: begin
                                    ALUSrcA = 2'd2; // rs
                                    ALUSrcB = 2'd0; // rt
                                    ALUOp = 3'b010; // -
                                    ALUOutWrite = 1;
                                    CURRSTATE = ALUOUTRD;
                                end
                                BREAK: begin // PC dont change
                                    ALUSrcA = 2'd1; // PC + 4 
                                    ALUSrcB = 2'd1; // 4
                                    ALUOp = 3'b010; // -
                                    PCSrc = 2'd0;
                                    PCWrite = 1;
                                end
                                RTE: begin // PC <= EPC
                                    PCSrc = 2'd3; // EPC
                                    PCWrite = 1;
                                    CURRSTATE = END;
                                end
                                ADDM: begin // rd <= Mem[rs] + Mem[rt] // read Mem[rt] and store in MDR
                                    IorD = 3'd5; // rt as address
                                    MDRWrite = 1;
                                    CURRSTATE = ADDM2;     
                                end 
                        endcase
                    end

                    // ADDM OTHER PARTS
                    ADDM2: begin // store Mem[rt] in B
                        MDRWrite = 0;
                        LoadBMem = 1;
                        RegBWrite = 1;
                        CURRSTATE = ADDM3;
                    end

                    ADDM3: begin // read Mem[rs] and store in MDR
                        LoadBMem = 0;
                        RegBWrite = 0;
                        IorD = 3'd5; // rs
                        MDRWrite = 1;
                        CURRSTATE = ADDM4;
                    end
                    ADDM4: begin // store Mem[rs] in A
                        MDRWrite = 0;
                        LoadAMem = 1;
                        RegAWrite = 1;
                        CURRSTATE = ADDM5;
                    end
                    ADDM5: begin // ADD Mem[rs] + Mem[rt]
                        LoadAMem = 0;
                        ALUSrcA = 2'd2; // Mem[rs]
                        ALUSrcB = 2'd0; // Mem[rt]
                        ALUOp = 3'b001; // +
                        ALUOutWrite = 1;
                        CURRSTATE = ALUOUTRD;
                    end

                    // J FORMAT //
                    J: begin 
                        PCSrc = 2'd2; // ConcatIPCOut
                        PCWrite = 1;
                        CURRSTATE = END;
                    end 
                    JAL: begin
                        ALUSrcA = 2'd0; // PC
                        ALUOp = 3'b000; // LOAD
                        ALUOutWrite = 1; 
                        CURRSTATE = JAL2;                        
                    end                   

                    // I FORMAT //
                    ADDI: begin // rt <= rs + IMMEDIATE* (overflow)
                        ALUSrcA = 2'd2; // rs
                        ALUSrcB = 2'd2; // rt
                        ALUOp = 3'b001; // Selector
                        ALUOutWrite = 1;
                        CURRSTATE = ALUOUTRT;
                    end
                    ADDIU: begin // rt <= rs + IMMEDIATE* 
                        ALUSrcA = 2'd2; // rs
                        ALUSrcB = 2'd2; // rt
                        ALUOp = 3'b001; // Selector
                        ALUOutWrite = 1;
                        CURRSTATE = ALUOUTRT;
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
                    SLLM: begin  // rt <= rt << Mem[offset + rs]
                        ALUSrcA = 2'd2; // rs
                        ALUSrcB = 2'd2; // offset
                        ALUOp = 3'b001; // +
                        ALUOutWrite = 1;
                        CURRSTATE = SLLM2; 
                    end
                    LB: begin
                        ALUSrcA    = 2'd2;  // A
                        ALUSrcB    = 2'd2;  // sign-extended 16-32
                        ALUOp      = 3'b001;   // soma
                        IorD       =  3'd2;  // alu result  segundo ciclo??
                        MemWrite   = 0;
                        CURRSTATE  = LB2;
                    end
                    LH: begin
                        LoadAMem   = 0;     // reg
                        ALUSrcA    = 2'd2;  // reg A
                        ALUSrcB    = 2'd2;  // sign-extended 16-32
                        ALUOp      = 3'b001;   // soma
                        IorD       = 3'd2;  // alu result  segundo ciclo??
                        MemWrite   = 0;
                        CURRSTATE  = LH2;
                    end
                    LUI: begin
                        DataSrc = 4'd5;   // shift left 16
                        RegDst = 2'd0;     // rt
                        RegWrite = 1;
                        CURRSTATE = END;
                    end
                    LW: begin
                        LoadAMem   = 0;     // reg
                        ALUSrcA    = 2'd2;  // reg A
                        ALUSrcB    = 2'd2;  // sign-extended 16-32
                        ALUOp      = 3'b001;   // soma
                        IorD       = 3'd2;  // alu result  segundo ciclo??
                        MemWrite   = 0;
                        CURRSTATE  = LW2;
                    end
                    SB: begin
                        LoadAMem    = 0;
                        ALUSrcA     = 2'd2; // reg A
                        ALUSrcB     = 2'd2; // shift left 16-32
                        ALUOp       = 3'd1; // soma
                        ALUOutWrite = 1;
                        CURRSTATE   = SB2;
                    end
                    SH: begin
                        // controles SH
                    end
                    SLTI: begin // rt <= (rs < IMMEDIATE) ? 1 : 0
                        ALUSrcA  = 2'd2;   // A
                        ALUSrcB  = 2'd2;   // IMMEDIATE
                        ALUOp    = 3'b111;  // Compare
                        DataSrc  = 4'd6; // LT
                        RegDst   = 2'd0;   // rt
                        RegWrite = 1;  
                        CURRSTATE = END;
                    end
                    SW: begin
                        // controles SW
                    end

                    // OPCODE inexistente
                    default: begin
                        CURRSTATE = EXECPTOPCODE;
                    end
                endcase
            end
            ALUOUTRD: begin
                if(overflow == 1 && (funct ==  ADD || funct == SUB)) begin
                    CURRSTATE = EXCEPTOVERFLOW1;
                end
                else begin
                    RegWrite = 1;
                    ALUOutWrite = 0;
                    RegDst = 2'd3; // rd
                    DataSrc = 4'd0; // ALUOut 
                    CURRSTATE = END; 
                end
            end
            ALUOUTRT: begin
                if(overflow == 1 &&  funct ==  ADDI) begin
                    CURRSTATE = EXCEPTOVERFLOW1;
                end
                else begin
                    RegWrite = 1;
                    ALUOutWrite = 0;
                    RegDst = 2'd0; // rt
                    DataSrc = 4'd0; // ALUOut 
                    CURRSTATE = END; 
                end
            end

            JAL2: begin
                DataSrc = 3'd0; // ALUOutOut
                RegDst = 2'd2; // $ra
                RegWrite = 1;
                CURRSTATE = JAL3;
            end
            JAL3: begin
                RegWrite = 0;
                PCSrc = 2'd1; // ALUOutOut
                PCWrite = 1;
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

            SLLM2: begin // READ Mem[offset+rs] 
                IorD = 3'd3; 
                MemWrite = 0;
                MDRWrite = 1;
                CURRSTATE = SLLM3;
            end
            SLLM3: begin // SHIFT LOAD
                SHIFTAmt = 2'd2; // Mem[offset+rs]
                SHIFTSrc = 0; // rt (B)
                SHIFTOp = 3'b001; // LOAD
                CURRSTATE = SLLM4;
            end
            SLLM4: begin // ACTUAL SHIFT
                SHIFTOp = 3'b010; 
                CURRSTATE = SHIFTENDRT;
            end
 
            LB2: begin
                MDRWrite = 1;       // segundo ciclo??
                CURRSTATE = LB3;  
            end

            LB3: begin
                CURRSTATE = LB4;
            end
            
            LB4: begin
                LSCtrl       = 2'b11;    // load byte
                DataSrc      = 4'd1;  // load byte
                RegDst       = 2'd0;    // rt
                RegWrite     = 1;
                CURRSTATE = END;
            end

            LH2: begin
                MDRWrite = 1;
                CURRSTATE  = LH3;
            end

            LH3: begin
                CURRSTATE  = LH4;
            end

            LH4: begin
                LSCtrl = 2'd2; // load halfbyte
                RegWrite = 1;
                RegDst  = 2'd0;
                DataSrc = 1;
                CURRSTATE  = END;
            end

            LW2: begin
                MDRWrite = 1;       // segundo ciclo??
                CURRSTATE = LW3;  
            end

            LW3: begin
                CURRSTATE = LW4;
            end

            LW4: begin
                LSCtrl = 2'd1; // load word
                RegWrite = 1;
                DataSrc = 1;
                RegDst = 2'd0;
                CURRSTATE = END;
            end

            SLLV2: begin
                SHIFTOp = 3'b010;
                CURRSTATE = SHIFTENDRD;
            end
            SRAV2: begin
                SHIFTOp = 3'b100;
                CURRSTATE = SHIFTENDRD;
            end 
            SLL2: begin
                SHIFTOp = 3'b010;
                CURRSTATE = SHIFTENDRD;
            end
            SRL2: begin
                SHIFTOp = 3'b011;
                CURRSTATE = SHIFTENDRD;                
            end
            SRA2: begin
                SHIFTOp = 3'b100;
                CURRSTATE = SHIFTENDRD;
            end
            SHIFTENDRT: begin
                DataSrc = 3'd7;
                RegDst = 2'd0; // rt
                RegWrite = 1;
                CURRSTATE = END;
            end
            SHIFTENDRD: begin
                DataSrc = 3'd7;
                RegDst = 2'd3; // rd
                RegWrite = 1;
                CURRSTATE = END;
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