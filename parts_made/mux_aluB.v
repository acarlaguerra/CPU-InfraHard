module mux_aluB(
    input wire [1:0] ALUSrcB,
    input wire [31:0] Data_0, // rt       // 00
    //                Data_1  =  4        // 01
    input wire [31:0] Data_2, // SE       // 10
    input wire [31:0] Data_3, // SE + SL2 // 11
    output wire [31:0] Data_out
);

    parameter four = 32'd4;
    wire [31:0] out1;
    wire [31:0] out2;

    /*
    Data_0 -- 0|
    four   -- 1| -- out1 -- 0\
    Data_2 -- 0|              | -- Data_out ->
    Data_3 -- 1| -- out2 -- 1/
    */

    assign out1 = (AluSrcB[0]) ? four : Data_0;
    assign out2 = (AluSrcB[0]) ? Data_3 : Data_2;
    assign Data_out = (AluSrcB[1]) ? out2 : out1;

endmodule

