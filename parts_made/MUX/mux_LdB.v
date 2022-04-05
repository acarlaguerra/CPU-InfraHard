// MUX to select which comes from register and which from Mem[offset + rs][4-0]
module mux_LdB (
    input   wire    LoadBMem,
    input   wire    [31:0]  Data_0,     //  REG B
    input   wire    [31:0]  Data_1,     //  Mem[offset + rs][4-0]
    output  wire    [31:0]  Data_out
);

assign  Data_out    =   (LoadBMem) ? Data_1  :   Data_0;

endmodule