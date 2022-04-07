//data_in *4
module shift_left2(
    input   wire    [31:0]  Data_in, // SE16_32Out
    output  wire    [31:0]  Data_out
);
    
    assign Data_out     =   Data_in << 2;

endmodule