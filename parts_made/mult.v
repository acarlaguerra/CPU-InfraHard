// colocar multStop wire na implementação do algoritmo

module mult(
    input   wire            clk,
    input   wire            reset,
    input   wire            MultCtrl,
    input   wire    [31:0]  Data_A,
    input   wire    [31:0]  Data_B,
    output  reg     [31:0]  Data_HI,
    output  reg     [31:0]  Data_LO
);

endmodule