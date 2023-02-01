///Ports & Parameters
module RegisterWithEN #(
    parameter Reg_width = 'd32
) (
    input  wire                   CLK,
    input  wire                   RST,
    input  wire                   EN,
    input  wire   [Reg_width-1:0] RegIn,
    output reg    [Reg_width-1:0] RegOut
);

//Instruction register logic
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        RegOut <= 'b0;
    end

    else if (EN) begin
        RegOut <= RegIn;
    end
end 
endmodule