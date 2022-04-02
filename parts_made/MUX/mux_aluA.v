module mux_aluA(
    input wire [1:0] ALUSrcA,
    input wire [31:0] Data_0, // PC      // 00
    input wire [31:0] Data_1, // PC + 4  // 01
    input wire [31:0] Data_2, // rs      // 10
    output wire [31:0] Data_out
);

    wire [31:0] out1;

    /*
        Data_0 -- 0|
        Data_1 -- 1| -- out 1 -- 0|
        Data_2 ----------------- 1| -- Data_out ->
    */

    assign out1 = (ALUSrcA[0]) ? Data_1 : Data_0;
    assign Data_out = (ALUSrcA[1]) ? Data_2 : out1;

endmodule