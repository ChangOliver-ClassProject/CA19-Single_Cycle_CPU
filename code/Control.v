module Control
(
	Op_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o
);

input         [6:0] Op_i;
output  reg   [1:0] ALUOp_o;
output  reg         ALUSrc_o, RegWrite_o;

always@ (*)
begin
	case (Op_i)
		7'b0110011: 				//R-format
		begin
			ALUOp_o    = 2'b10;
			ALUSrc_o   = 0;
			RegWrite_o = 1;
		end
		7'b0010011: 				//I-format(addi)
		begin
			ALUOp_o    = 2'b00;
			ALUSrc_o   = 1;
			RegWrite_o = 1;
		end	
	endcase
end

endmodule