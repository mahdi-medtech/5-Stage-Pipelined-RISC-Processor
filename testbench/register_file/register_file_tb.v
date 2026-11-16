module register_file_tb;

reg clk;
reg reg_write;

reg [4:0] read_addr1;
reg [4:0] read_addr2;
reg [4:0] write_addr;

reg [31:0] write_data;

wire [31:0] read_data1;
wire [31:0] read_data2;

register_file uut (
    .clk(clk),
    .reg_write(reg_write),
    .read_addr1(read_addr1),
    .read_addr2(read_addr2),
    .write_addr(write_addr),
    .write_data(write_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

// Clock generation
always #5 clk = ~clk;

initial begin

    $dumpfile("register_file.vcd");
    $dumpvars(0, register_file_tb);

    clk = 0;
    reg_write = 0;

    read_addr1 = 0;
    read_addr2 = 0;
    write_addr = 0;
    write_data = 0;

    // Test 1: Write 25 into x1
    #10;
    reg_write = 1;
    write_addr = 1;
    write_data = 25;

    #10;
    reg_write = 0;
    read_addr1 = 1;

    #5;
    $display("Test 1: x1 = %d", read_data1);

    // Test 2: Write 40 into x2
    #5;
    reg_write = 1;
    write_addr = 2;
    write_data = 40;

    #10;
    reg_write = 0;
    read_addr2 = 2;

    #5;
    $display("Test 2: x2 = %d", read_data2);

    // Test 3: Simultaneous read
    read_addr1 = 1;
    read_addr2 = 2;

    #5;
    $display("Test 3: x1 = %d, x2 = %d", read_data1, read_data2);

    // Test 4: Attempt to write into x0
    #5;
    reg_write = 1;
    write_addr = 0;
    write_data = 100;

    #10;
    reg_write = 0;
    read_addr1 = 0;

    #5;
    $display("Test 4: x0 = %d", read_data1);

    #10;
    $finish;

end

endmodule