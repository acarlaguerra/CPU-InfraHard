//  MUX to select which comes from register A and which from register B
module mux_Src(
    input   wire    [1:0]   SHIFTSrc,
    input   wire    [31:0]  Data_0,     // rt (REG B)
    input   wire    [31:0]  Data_1,     // rs (REG A)
    input   wire    [31:0]  Data_out
);

    assign  Data_out    =   (SHIFTSrc[0])? Data_1  :   Data_0;

endmodule