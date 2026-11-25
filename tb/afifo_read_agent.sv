
class afifo_read_agent extends uvm_agent;
`uvm_component_utils(afifo_read_agent)
 
function new(input string inst = "afifo_read_agent", uvm_component parent = null);
super.new(inst,parent);
endfunction
 
afifo_read_driver drv_r;
afifo_read_monitor mon_r;
uvm_sequencer #(trans) sqr;
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
    drv_r = afifo_read_driver::type_id::create("drv_r",this);
    mon_r = afifo_read_monitor::type_id::create("mon_r",this);
    seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
endfunction
 
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv_r.seq_item_port.connect(seqr.seq_item_export);
endfunction
 
endclass