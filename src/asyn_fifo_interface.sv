
interface asyn_fifo_interface #(
  parameter int unsigned DATA_WIDTH = 8  // Number of bit in a data
)();

  logic w_clk;
  logic w_rst_n;
  logic w_inc;
  logic [DATA_WIDTH-1:0] w_data;
  logic w_full;
  logic r_clk;
  logic r_rst_n;
  logic r_inc;
  logic [DATA_WIDTH-1:0] r_data;
  logic r_empty;

  clocking w_cb @(posedge w_clk);
    default input #1step output #1;
    input w_full;
    output w_rst_n;
    output w_inc;
    output w_data;
  endclocking: w_cb

  clocking r_cb @(posedge r_clk);
    default input #1step output #1;
    input r_empty;
    output r_rst_n;
    output r_inc;
    output r_data;
  endclocking: r_cb

endinterface: asyn_fifo_interface