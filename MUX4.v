module MUX4 #(
    parameter MUXInputWidth = 'd32
) (
    input  wire [MUXInputWidth-1:0]  MUXIn1,
    input  wire [2:0]                MUXIn2,
    input  wire [MUXInputWidth-1:0]  MUXIn3,
    input  wire [MUXInputWidth-1:0]  MUXIn4,
    input  wire [1:0]                MUXSelection,
    output reg  [MUXInputWidth-1:0]  MUXOut
);

always @(*) begin
    case (MUXSelection)
      'b00  : begin
        MUXOut = MUXIn1;
      end 
      'b01  : begin
        MUXOut = MUXIn2;
      end
       'b10  : begin
        MUXOut = MUXIn3;
      end
        'b11  : begin
        MUXOut = MUXIn4;
      end
        default: begin
            MUXOut = 'b0;
        end
    endcase
end  
endmodule