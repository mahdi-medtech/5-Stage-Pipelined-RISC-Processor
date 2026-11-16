module register_file (
    input clk,
    input reg_write,

    input [4:0] read_addr1,
    input [4:0] read_addr2,
    input [4:0] write_addr,

    input [31:0] write_data,

    output [31:0] read_data1,
    output [31:0] read_data2
);

reg [31:0] registers [0:31];

// Read operation
assign read_data1 = (read_addr1 == 0) ? 32'b0 : registers[read_addr1];
assign read_data2 = (read_addr2 == 0) ? 32'b0 : registers[read_addr2];

// Write operation
always @(posedge clk) begin
    if (reg_write && write_addr != 0)
        registers[write_addr] <= write_data;
end

endmodule