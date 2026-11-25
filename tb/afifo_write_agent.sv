
class afifo_write_agent extends uvm_agent;
`uvm_component_utils(afifo_write_agent)
 
function new(input string inst = "afifo_write_agent", uvm_component parent = null);
super.new(inst,parent);
endfunction
 
afifo_write_driver drv_w;
afifo_write_monitor mon_w;
uvm_sequencer #(trans) sqr;
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
    drv_w = afifo_write_driver::type_id::create("drv_w",this);
    mon_w = afifo_write_monitor::type_id::create("mon_w",this);
    seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
endfunction
 
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv_w.seq_item_port.connect(seqr.seq_item_export);
endfunction
 
endclass