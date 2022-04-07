// colocar divStop wire na implementação do algoritmo

module div(
    input   wire            clk,
    input   wire            reset,
    input   wire            DivCtrl,
    input   wire            Div0,
    input   wire    [31:0]  Data_A,
    input   wire    [31:0]  Data_B,
    output  reg     [31:0]  Data_HI,
    output  reg     [31:0]  Data_LO
);

endmodule