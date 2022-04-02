//data_in *4
module shift_left2(
    input   wire    [31:0]  Data_in,
    output  wire    [31:0]  Data_out
);
    
    assign Data_out     =   Data_in << 2;
>>>>>>> 789d4f417dd125fccf5be7a6a43f7a1f8af631f2

endmodule