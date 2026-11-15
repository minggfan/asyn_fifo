`timescale 1ns / 1ps
`include "uvm_macros.svh"

module afifo_tb_top;

  import uvm_pkg::*;
  import afifo_test_pkg::*;

  asyn_fifo_interface afifo_if();
  asyn_fifo dut (.a(mif.a), .b(mif.b), .y(mif.y));

  initial begin
    uvm_config_db #(virtual mul_if)::set(null, "*", "mif", mif);
    run_test("test"); 
  end
 
endmodule