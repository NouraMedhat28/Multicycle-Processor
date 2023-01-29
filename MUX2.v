module MUX2 #(
    parameter MUXInputWidth = 'd32
) (
    input  wire [MUXInputWidth-1:0]  MUXIn1,
    input  wire [MUXInputWidth-1:0]  MUXIn2,
    input  wire                      MUXSelection,
    output reg  [MUXInputWidth-1:0]  MUXOut
);

always @(*) begin
    case (MUXSelection)
      'b0  : begin
        MUXOut = MUXIn1;
      end 
      'b1  : begin
        MUXOut = MUXIn2;
      end
        default: begin
            MUXOut = 'b0;
        end
    endcase
end  
endmodule