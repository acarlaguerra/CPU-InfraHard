//  MUX to select which comes from register A and which from register B
module mux_Src(
    input   wire    SHIFTSrc,
    input   wire    [31:0]  Data_0,     // rt (REG B)
    input   wire    [31:0]  Data_1,     // rs (REG A)
    input   wire    [31:0]  Data_out
);

    assign  Data_out    =   (SHIFTSrc)? Data_1  :   Data_0;

endmodule