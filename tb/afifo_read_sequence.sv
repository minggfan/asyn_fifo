
class afifo_seq extends uvm_sequence#(transaction);
`uvm_object_utils(generator)
  
   transaction afifo_trans;
 
   function new(input string path = "afifo_seq");
    super.new(path);
   endfunction
   
   virtual task body(); 
   tr = transaction::type_id::create("tr");
   repeat(30)
     begin
         start_item(tr);
         assert(1'(tr.randomize()));
         `uvm_info("SEQ", $sformatf("a : %0d  b : %0d  y : %0d", tr.a, tr.b, tr.y), UVM_NONE);
         finish_item(tr);     
     end
   endtask
 
endclass