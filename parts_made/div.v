// colocar divStop wire na implementação do algoritmo

module div(
    input   wire            clk,
    input   wire            reset,
    input   wire            DivCtrl,
    input   wire    [31:0]  Data_A,
    input   wire    [31:0]  Data_B,

    output  wire            Div0,
    output  reg     [31:0]  Data_HI,
    output  reg     [31:0]  Data_LO
);

endmodule