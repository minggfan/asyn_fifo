
class afifo_trans #(int DATA_WIDTH = 8) extends uvm_sequence_item;
`uvm_object_utils(afifo_trans #(DATA_WIDTH))
  
   logic w_clk;
   logic w_rst_n;
   logic w_inc;
   randc logic w_data[DATA_WIDTH-1:0];
   logic w_full;
   logic r_clk;
   logic r_rst_n;
   logic r_inc;
   logic r_data[DATA_WIDTH-1:0];
   logic r_empty;

   function new(input string path = "afifo_trans");
    super.new(path);
   endfunction

endclass

typedef afifo_trans #(8)  afifo_trans_1byte;
typedef afifo_trans #(16) afifo_trans_2byte;