module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire       [31:0]   pc_out;
wire       [31:0]   next_pc;
wire       [31:0]   instr;
wire        [1:0]   ALUOp;
wire                ALUSrc;
wire                RegWrite;
wire       [31:0]   sign_extend_imm;
wire       [31:0]   Mux_out;
wire       [31:0]   RS1data;
wire       [31:0]   RS2data;
wire       [2:0]    ALUCtrl;
wire       [31:0]   ALU_out;
wire                zero;


parameter pc_imm = {{29{1'b0}}, 3'b100};

Control Control(
    .Op_i       (instr[6:0]),
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (ALUSrc),
    .RegWrite_o (RegWrite)
);


Adder Add_PC(
    .data1_in   (pc_out),
    .data2_in   (pc_imm),
    .data_o     (next_pc)
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (next_pc),
    .pc_o       (pc_out)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_out), 
    .instr_o    (instr)
);

Registers Registers(
    .clk_i       (clk_i),
    .RS1addr_i   (instr[19:15]),
    .RS2addr_i   (instr[24:20]),
    .RDaddr_i    (instr[11:7]), 
    .RDdata_i    (ALU_out),
    .RegWrite_i  (RegWrite), 
    .RS1data_o   (RS1data), 
    .RS2data_o   (RS2data) 
);


Mux32 MUX_ALUSrc(
    .data1_i    (RS2data),
    .data2_i    (sign_extend_imm),
    .select_i   (ALUSrc),
    .data_o     (Mux_out)
);



Sign_Extend Sign_Extend(
    .data_i     (instr[31:20]),
    .data_o     (sign_extend_imm)
);

  

ALU ALU(
    .data1_i    (RS1data),
    .data2_i    (Mux_out),
    .ALUCtrl_i  (ALUCtrl),
    .data_o     (ALU_out),
    .Zero_o     (zero)
);



ALU_Control ALU_Control(
    .funct_i    ({instr[31:25], instr[14:12]}),
    .ALUOp_i    (ALUOp),
    .ALUCtrl_o  (ALUCtrl)
);


endmodule

