//arrive with 16bits and leave with 32bit
module shift_left16(
    input   wire    [15:0]  Data_in,
    output  wire    [32:0]  Data_out
);
    // shift left 16
    assign Data_out     =   Data_in << 16;

endmodule