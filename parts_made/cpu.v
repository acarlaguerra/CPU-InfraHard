module cpu (
    input wire clk,
    input wire reset
);

// mux_ctrl
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

endmodule          
