module mux_aluB(
    input wire [1:0] ALUSrcB,
    input wire [31:0] Data_0, // rt
    //                Data_1  =  4
    input wire [31:0] Data_2, // SE
    input wire [31:0] Data_3, // SE + SL2
    output wire [31:0] Data_out
);

    parameter four = 32'd4;
    assign out1 = (AluSrcB[0]) ? four : Data_0;
    assign out2 = (AluSrcB[0]) ? Data_3 : Data_2;
    assign Data_out = (AluSrcB[1]) ? out2 : out1;
    
endmodule

