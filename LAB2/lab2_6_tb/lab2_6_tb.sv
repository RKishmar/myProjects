`timescale 1ns/1ns

module lab2_6_tb;

  localparam DATA_WIDTH = 12;

  logic                                                clk;
  logic                                                reset;
  logic [ DATA_WIDTH - 1:0 ]                           data;
  logic [ $clog2(DATA_WIDTH)-1 : 0 ]                   result;
  logic                                                data_valid;
  logic                                                result_valid;

  logic [ $clog2(DATA_WIDTH) - 1 : 0 ]                 result_expect;
  logic [ ( $clog2(DATA_WIDTH) + DATA_WIDTH ) - 1 :0]  testvectors[1000:0];
  integer                                              vector_num; 
  integer                                              errors;
//----------------------------------------------------------------------------  
  
  lab2_6  
  #( 
    .WIDTH       (DATA_WIDTH)) 
  DUT 
  (
    .clk_i       ( clk          ),
    .srst_i      ( reset        ),
    .data_i      ( data         ),
    .data_val_i  ( data_valid   ),
    .data_val_o  ( result_valid ),
    .data_o      ( result       )
  );
  
//---------------------------------------------------------------------------- 
  
  always begin
    clk = 1; #5; 
    clk = 0; #5;
  end

  always begin
    data_valid = 1; #100; 
    data_valid = 0; #5;
  end

  always begin
    reset = 0; #3; 
    reset = 1; #10000;
  end

  initial begin
    $readmemb( "lab2_6_test_vector.tv", testvectors );
    vector_num = 0; 
    errors     = 0;
  end

  initial begin
    while ( testvectors[ vector_num ] !== 'x ) begin
      
      { data, result_expect } = testvectors[ vector_num ];  
      
      @( data_valid   == 1 ); 
      #5                    ;
      @( result_valid == 1 ); 
      #1                    ;
     
      if ( result_expect !== result ) begin
        $display( " " );
        $display( "Error! test vector number = %d,   data tested = %b,   result received = %b,   result expected = %b ", vector_num, data, result, result_expect );

        errors = errors + 1;
    
      end
      
      vector_num = vector_num + 1;
            
    end    
      
      $display( " " );
      $display( "%d tests completed with %d errors", vector_num, errors );
      $display( " " );
      
  $finish;    
   
  end  

endmodule