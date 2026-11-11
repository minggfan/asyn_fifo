`include "uvm_macros.svh"
import uvm_pkg::*;
import tb_afifo_pkg::*;

module tb;
 
  mul_if mif();
  mul dut (.a(mif.a), .b(mif.b), .y(mif.y));
  UVM_FILE log;
  uvm_root root;

  initial 
  begin
    root = uvm_root::get();
    log = $fopen("./mul4x4/sim.txt", "w");
    root.set_report_default_file_hier(log);
    root.set_report_severity_action_hier(UVM_INFO,    UVM_DISPLAY | UVM_LOG);
    root.set_report_severity_action_hier(UVM_ERROR,   UVM_DISPLAY | UVM_LOG);
    root.set_report_severity_action_hier(UVM_FATAL,   UVM_DISPLAY | UVM_LOG);
    
    uvm_config_db #(virtual mul_if)::set(null, "*", "mif", mif);
    run_test("test"); 

    $fclose(log);
  end
 
  initial begin
    $dumpfile("./mul4x4/dump.vcd");
    $dumpvars;
  end
endmodule