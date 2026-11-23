
class afifo_environment extends uvm_env;
`uvm_component_utils(afifo_environment)
 
function new(input string inst = "afifo_environment", uvm_component c);
  super.new(inst,c);
endfunction
 
afifo_read_agent agt_r;
afifo_write_agent agt_w;
afifo_scoreboard sco;
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  agt_r = afifo_read_agent::type_id::create("agt_r",this);
  agt_w = afifo_write_agent::type_id::create("agt_w",this);
  sco = afifo_scoreboard::type_id::create("sco", this);
endfunction
 
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
a.m.send.connect(s.recv);
endfunction
 
endclass