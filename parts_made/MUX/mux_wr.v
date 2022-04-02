module mux_wr(
    input wire [1:0] Selector,
    input wire [4:0] Data_0, //RT
    input wire [:0] Data_3, //RD
    output wire [4:0] Data_out
   
);

wire [31:0] out1, out2;

assign out1 = (Selector[0]) ? 5'd29 : Data_0;
assign out2 = (Selector[0]) ? Data_3[15:11] : 5'31;
assign Data_out = (Selector[1]) ? out2 : out1;

    
endmodule