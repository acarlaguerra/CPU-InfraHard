module mux_aluA(
    input wire [1:0] ALUSrcA,
    input wire [31:0] Data_0, // PC
    input wire [31:0] Data_1, // PC + 4
    input wire [31:0] Data_2, // rs
    output wire [31:0] Data_out
);
    wire out1 [31:0];
    
    assign out1 = (ALUSrcA[0]) ? Data_1 : Data_0;
    assign Data_out = (ALUSrcA[1]) ? Data_2 : out1;

endmodule