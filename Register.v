//Ports & Parameters
module Register #(
    parameter Reg_width = 'd32
) (
    input  wire   [Reg_width-1:0] RegIn,
    input  wire                   CLK,
    input  wire                   RST,
    output reg    [Reg_width-1:0] RegOut
);


always @(posedge CLK or negedge RST) begin
    if(!RST) begin
        RegOut <= 'b0;
    end

    else begin
        RegOut <= RegIn;
    end
end
    
endmodule