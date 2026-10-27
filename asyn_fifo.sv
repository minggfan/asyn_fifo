
module asyn_fifo #(
  parameter int unsigned DATA_WIDTH = 8,  // Number of bit in a data
  parameter int unsigned FIFO_DEPTH = 8   // Maximum number of data in FIFO
)(
  // Write
  input  logic w_clk,
  input  logic w_rst_n,
  input  logic w_inc,
  input  logic w_data[DATA_WIDTH-1:0],
  output logic w_full,

  // Read
  input  logic r_clk,
  input  logic r_rst_n,
  input  logic r_inc,
  output logic r_data[DATA_WIDTH-1:0],
  output logic r_empty,
);

localparam int unsigned ADDR_WIDTH = $clog2(FIFO_DEPTH);

logic [DATA_WIDTH-1]   mem [0:FIFO_DEPTH];

logic [ADDR_WIDTH:0]   w_addr;             // Memory write address in binary      
logic [ADDR_WIDTH:0]   w_ptr_grey;         // grey code
logic [ADDR_WIDTH:0]   w_ptr_grey_r_sync1; 
logic [ADDR_WIDTH:0]   w_ptr_grey_r_sync2; // Synchronized by 2FF in read domain

logic [ADDR_WIDTH:0]   r_addr;             // Memory read address in binary
logic [ADDR_WIDTH:0]   r_ptr_grey;         // grey code
logic [ADDR_WIDTH:0]   r_ptr_grey_w_sync1; 
logic [ADDR_WIDTH:0]   r_ptr_grey_w_sync2; // Synchronized by 2FF in write domain


// ******************** Memory Access *********************
always_ff @(posedge w_clk) begin
  if(w_inc && !w_full)
    mem[w_addr[ADDR_WIDTH-1:0]] <= w_data;
end
always_comb begin
    r_data = mem[r_addr[ADDR_WIDTH-1:0]];
end

// ******************** Memory Address ********************
always_ff @(posedge w_clk or nedegde w_rst_n) begin
  if(~w_rst_n)
    w_addr <= '0;
  else if(!w_full && w_inc)
    w_addr <= w_addr + 1'd1;
end

always_ff @(posedge r_clk or nedegde r_rst_n) begin
  if(~r_rst_n)
    r_addr <= '0;
  else if(!r_empty && r_inc)
    r_addr <= r_addr + 1'd1;
end

// ******************** Write domain ********************
always_ff @(posedge w_clk or negedge w_rst_n) begin
  if(~w_rst_n)
    w_ptr_grey <= '0;
  else
    w_ptr_grey <= w_addr ^ (w_addr >> 1);
end

always_ff @(posedge w_clk or negedge w_rst_n) begin
  if(~w_rst_n) begin
    r_ptr_grey_wsync1 <= '0;
    r_ptr_grey_wsync2 <= '0; 
  end
  else begin
    r_ptr_grey_wsync1 <= r_ptr_grey;
    r_ptr_grey_wsync2 <= r_ptr_grey_wsync1;
  end
end

assign w_full = (w_ptr_grey == {~r_ptr_grey_wsync2[ADDR_WIDTH:ADDR_WIDTH-1], r_ptr_grey_wsync2[ADDR_WIDTH-2:0]});

// ******************** Read domain ********************
always_ff @(posedge r_clk or negedge r_rst_n) begin
  if(~r_rst_n)
    r_ptr_grey <= '0;
  else
    r_ptr_grey <= r_addr ^ (r_addr >> 1);
end

always_ff @(posedge r_clk or negedge r_rst_n) begin
  if(~r_rst_n) begin
    w_ptr_grey_rsync1 <= '0;
    w_ptr_grey_rsync2 <= '0; 
  end
  else begin
    w_ptr_grey_rsync1 <= w_ptr_grey;
    w_ptr_grey_rsync2 <= w_ptr_grey_rsync1;
  end
end

assign r_empty = (r_ptr_grey == w_ptr_grey_rsync2);


endmodule