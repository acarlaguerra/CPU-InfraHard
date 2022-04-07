//arrive with 26bits and leave with 38bits
module shift_left26(
    input   wire    [25:0]  Data_in, // ConcatINSTOut
    output  wire    [37:0]  Data_out
);
    
    assign Data_out     =   {Data_in, 2'b0};

endmodule