// MUX to select which comes from register and which from Mem[offset + rs][4-0]
module mux_LdA (
    input   wire    LoadAMem,
    input   wire    [31:0]  Data_0,     //  REG A
    input   wire    [31:0]  Data_1,     //  Mem[offset + rs]
    output  wire    [31:0]  Data_out
);

assign  Data_out    =   (LoadAMem) ? Data_1  :   Data_0;

endmodule