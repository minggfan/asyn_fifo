`timescale 1ns / 1ps
`include "uvm_macros.svh"

module afifo_tb_top;

  import uvm_pkg::*;
  import afifo_test_pkg::*;

  asyn_fifo_interface afifo_if();
  asyn_fifo dut(
    .w_clk    (afifo_if.w_clk  ),
    .w_rst_n  (afifo_if.w_rst_n),
    .w_inc    (afifo_if.w_inc  ),
    .w_data   (afifo_if.w_data ),
    .w_full   (afifo_if.w_full ),
    .r_clk    (afifo_if.r_clk  ),
    .r_rst_n  (afifo_if.r_rst_n),
    .r_inc    (afifo_if.r_inc  ),
    .r_data   (afifo_if.r_data ),
    .r_empty  (afifo_if.r_empty)
  );

  initial begin
    uvm_config_db #(virtual afifo_if)::set(null, "*", "afifo_vif", afifo_vif);
    run_test("test"); 
  end
 
endmodule