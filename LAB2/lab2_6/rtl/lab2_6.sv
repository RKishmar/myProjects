module lab2_6 #( parameter WIDTH )
(  input                             clk_i,
   input                             srst_i,
   input  [WIDTH - 1: 0]             data_i,
   input  reg                        data_val_i,
   output reg                        data_val_o,
   output reg [$clog2(WIDTH) - 1: 0] data_o
);

logic [WIDTH - 1: 0]         bit_array_r;
logic [$clog2(WIDTH) + 1: 0] cnt;

typedef enum logic[2:0] {IDLE, START, COUNT, RESULT} state_type;
state_type state;

always_ff @(posedge clk_i) begin
   if(!srst_i) begin
      cnt         <= '0;
      data_val_o  <= 1'b0;
      bit_array_r <= '0;
   end else begin
	   case (state) 
         IDLE: begin
            cnt        <= '0;
            data_val_o <= 0;
               if (data_val_i) state <= START;
               else            state <= IDLE;
	      end
			
         START: begin
			   bit_array_r <= data_i;
			   data_val_o  <= 0;
			   state       <= COUNT;
			end
		
	      COUNT: begin
		      if (bit_array_r != '0) begin
		         cnt <= cnt + 1;
	   	      bit_array_r <= bit_array_r & (bit_array_r - 1);
					state <= COUNT;
	         end else begin
					state <= RESULT;
				end
         end
			
         RESULT: begin
            data_o     <= cnt;
            data_val_o <= 1;	
            state      <= IDLE;		    
         end	
			
         default: begin
			   state <= IDLE;
         end
			
      endcase	
   end
end			
	

endmodule
