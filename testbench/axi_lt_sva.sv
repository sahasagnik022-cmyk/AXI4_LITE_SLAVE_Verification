module axi_lt_sva(
    input logic ACLK,
    input logic ARESETn,
  input  logic [`aw-1:0] AWADDR,
  input  logic [2:0] AWPROT,
    input logic AWVALID,
    input logic AWREADY,
  input  logic [`dw-1:0] WDATA,
  input  logic [(`dw/8)-1:0] WSTRB,
    input logic WVALID,
    input logic WREADY,
  input logic [1:0] BRESP,
    input logic  BVALID,
    input logic BREADY,
  input logic [`aw-1:0] ARADDR,
  input logic [2:0]  ARPROT,
    input logic ARVALID,
    input logic  ARREADY,
  input logic  [`dw-1:0] RDATA,
  input logic  [1:0] RRESP,
   input logic  RVALID,
    input logic RREADY
);
  property p1;
      @(posedge ACLK) disable iff (!ARESETn)
      (AWVALID && !AWREADY) |=> AWVALID;
  endproperty

  p1_check: assert property (p1)
      else $error("awvalid dropped before awready");
  
     
  property p2;
      @(posedge ACLK) disable iff (!ARESETn)
      (WVALID && !WREADY) |=> WVALID;
  endproperty

    p2_check: assert property (p2)
      else $error("wvalid dropped before wready");

property p3;
  @(posedge ACLK) (!ARESETn) |-> (!BVALID && !RVALID && !RDATA); 
endproperty
p3_check: assert property (p3)
    else $error("Output pins high during reset");

endmodule
