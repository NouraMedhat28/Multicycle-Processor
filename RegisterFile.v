//Ports & Parameters
module RegisterFile #(
    parameter RegFileAdd = 'd5,
    parameter RegFile_width = 'd32 
) (
    input  wire [RegFileAdd-1:0]    A1,
    input  wire [RegFileAdd-1:0]    A2,
    input  wire [RegFileAdd-1:0]    A3,
    input  wire                     CLK,
    input  wire                     RST,
    input  wire                     WE3,
    input  wire [RegFile_width-1:0] WD3,
    output reg  [RegFile_width-1:0] RD1,
    output reg  [RegFile_width-1:0] RD2
);

reg [RegFile_width-1:0]  RegFile [0:RegFile_width-1];
integer i;

//Reading Combinationally
always @(*) begin
    RD1 = RegFile[A1];
    RD2 = RegFile[A2];
end

always @(posedge CLK or negedge RST) begin
//Asyncronous RST
    if(!RST) begin
        for (i = 0; i<RegFile_width; i = i +1) begin
            RegFile[i] <= 'b0;
        end
    end
    else if(WE3) begin
        RegFile[A3] <= WD3;
    end
end
    
endmodule