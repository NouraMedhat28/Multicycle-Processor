module LeftShift #(
    parameter width  = 'd32
) (
    input  wire [width-1:0] ShiftIn,
    output reg  [width-1:0] ShiftOut
);
    
always @(*) begin
    ShiftOut = ShiftIn << 2;
end
endmodule