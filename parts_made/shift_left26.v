//arrive with 26bits and leave with 28bits
module shift_left26(
    input   wire    [25:0]  Data_in,
    output  wire    [27:0]  Data_out
);
    
    assign Data_out     =   {Data_in, 2'd0}

endmodule