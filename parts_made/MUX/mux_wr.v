module mux_wr(
    input wire [1:0] Selector,
    input wire [4:0] Data_0, //RT
//  input wire [4:0] Data_1 // sp
//  input wire [4:0] Data_2 // ra
    input wire [15:0] Data_3, //IMMEDIATE (rd)
    output wire [4:0] Data_out
   
);

// Pegamos o [15-11] depos
    wire [31:0] out1, out2;
    parameter sp = 5'd29;
    parameter ra = 5'd31;
    /*
        Data_0 -- 0|
        sp     -- 1| -- out1 -- 0\
        ra     -- 0|              | -- Data_out ->
        Data_3 -- 1| -- out2 -- 1/
    */


    assign out1 = (Selector[0]) ? sp : Data_0;
    assign out2 = (Selector[0]) ? Data_3[15:11] : ra;
    assign Data_out = (Selector[1]) ? out2 : out1;

    
endmodule