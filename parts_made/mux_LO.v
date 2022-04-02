// MUX to select which comes from MULT and which from DIV
module mux_LO (
    input   wire    [1:0]   LOSrc,
    input   wire    [31:0]  Data_0,     // comes from MULT
    input   wire    [31:0]  Data_1,     // comes from DIV
    output  wire    [31:0]  Data_out
);

assign  Data_out    =   (LOSrc[0])? Data_1  :   Data_0;

endmodule