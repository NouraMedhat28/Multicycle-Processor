module InstructionDataMemory #(
    parameter MemoryWidth = 'd32
) (
    input  wire CLK,
    input  wire RST,
    input  wire WE,
    input  wire [MemoryWidth-1:0] A,
    input  wire [MemoryWidth-1:0] WD,
    output reg  [MemoryWidth-1:0] RD
);

reg [MemoryWidth-1:0] Memory [0:MemoryWidth-1];
integer i;

//Read Combinationally
always @(*) begin
    RD = Memory[A];
end

always @(posedge CLK or negedge RST) begin
    //Asynchronous RST
    if(!RST) begin
        for (i =0 ; i<MemoryWidth ; i = i+1 ) begin
            Memory[i] = 'b0;
        end
    end

    else if (WE) begin
        Memory[A] <= WD;
    end
end
endmodule