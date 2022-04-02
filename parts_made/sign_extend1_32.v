module sign_extend1_32(

    input wire         Data_in,     // LT
    output wire [31:0] Data_out

);

    assign Data_out = {31'b0, Data_in};

endmodule