
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

localparam int unsigned FIFO_WIDTH = $clog2(FIFO_DEPTH);

logic [DATA_WIDTH-1]   mem [0:FIFO_DEPTH]; // Memory
logic [FIFO_WIDTH-1:0] w_addr;             // Memory write address
logic [FIFO_WIDTH:0]   w_ptr;            
logic [FIFO_WIDTH:0]   w_ptr_grey;         // grey code
logic [FIFO_WIDTH:0]   w_ptr_grey_sync1; 
logic [FIFO_WIDTH:0]   w_ptr_grey_sync2;   // Synchronize by 2FF in read domain

logic [FIFO_WIDTH-1:0] r_addr;             // Memory read address
logic [FIFO_WIDTH:0]   r_ptr;            
logic [FIFO_WIDTH:0]   r_ptr_grey;         // grey code
logic [FIFO_WIDTH:0]   r_ptr_grey_sync1; 
logic [FIFO_WIDTH:0]   r_ptr_grey_sync2;   // Synchronize by 2FF in write domain

// Memory address
always_comb begin
  w_addr     = w_ptr[FIFO_WIDTH-1:0];
  w_ptr_grey = w_ptr ^ (w_ptr >> 1);
  r_addr     = r_ptr[FIFO_WIDTH-1:0];
  r_ptr_grey = r_ptr ^ (r_ptr >> 1);
end

// Write data to memory
always_ff @(posedge w_clk) begin
  if(w_inc && !w_full)
    mem[w_addr] <= w_data;
end

// Write pointer sync in read domain
always_ff @(posedge r_clk or negedge r_rst_n) begin
  if(!r_rst_n) begin
    w_ptr_grey_sync1 <= 0;
    w_ptr_grey_sync2 <= 0; 
  end
  else begin
    w_ptr_grey_sync1 <= w_ptr_grey;
    w_ptr_grey_sync2 <= w_ptr_grey_sync1;
  end
end

// Read pointer sync in write domain
always_ff @(posedge w_clk or negedge w_rst_n) begin
  if(!w_rst_n) begin
    r_ptr_grey_sync1 <= 0;
    r_ptr_grey_sync2 <= 0; 
  end
  else begin
    r_ptr_grey_sync1 <= r_ptr_grey;
    r_ptr_grey_sync2 <= r_ptr_grey_sync1;
  end
end

// Write Logic
always_ff @(posedge w_clk or negedge w_rst_n) begin
  if(!w_rst_n) begin
    w_ptr <= 0;
  end

end

// Read Logic
always_ff @(posedge r_clk or negedge r_rst_n) begin
  if(!r_rst_n) begin
    r_ptr <= 0;
  end

end


endmodule