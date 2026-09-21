`include "uvm_macros.svh"
`include "axi_lt_pkg.sv"
`include "axi_lt_if.sv"
`include "axi_lt_sva.sv"
`include "axi4_lite_slave.v"

import uvm_pkg::*;
import axi_lt_pkg::*;

module tb_top();

bit aclk;
bit aresetn;

initial begin
    aclk=0;
    forever #5 aclk=~aclk;
end

initial begin
    aresetn=0;
    #5;
    aresetn=1;
    #5;
    aresetn=0;
    #20;
    aresetn=1;
end

axi_lt_if vif(aclk,aresetn);

axi4_lite_slave DUT (
        .ACLK    (vif.aclk),
        .ARESETn (vif.aresetn),
        .AWADDR  (vif.awaddr),
        .AWVALID (vif.awvalid),
        .AWREADY (vif.awready),
        .WDATA (vif.wdata),
        .WSTRB   (vif.wstrb),
        .WVALID  (vif.wvalid),
        .WREADY  (vif.wready),
        .BRESP  (vif.bresp),
        .BVALID  (vif.bvalid),
        .BREADY  (vif.bready),
        .ARADDR  (vif.araddr),
        .ARVALID (vif.arvalid),
        .ARREADY (vif.arready),
        .RDATA   (vif.rdata),
        .RRESP   (vif.rresp),
        .RVALID  (vif.rvalid),
        .RREADY  (vif.rready),
        .ARPROT  (vif.arprot),
        .AWPROT  (vif.awprot)
);
 
bind axi4_lite_slave axi_lt_sva ast(
  .ACLK  (ACLK),
  .ARESETn (ARESETn),
  .AWADDR  (AWADDR),
  .AWVALID (AWVALID),
  .AWREADY (AWREADY),
  .WDATA (WDATA),
  .WSTRB   (WSTRB),
  .WVALID  (WVALID),
  .WREADY  (WREADY),
  .BRESP  (BRESP),
  .BVALID  (BVALID),
  .BREADY  (BREADY),
  .ARADDR  (ARADDR),
  .ARVALID (ARVALID),
  .ARREADY (ARREADY),
  .RDATA   (RDATA),
  .RRESP   (RRESP),
  .RVALID  (RVALID),
  .RREADY  (RREADY),
  .ARPROT  (ARPROT),
  .AWPROT  (AWPROT)
);


initial begin
    uvm_top.set_timeout(50000ns,1);
    uvm_config_db#(virtual axi_lt_if)::set(null,"*","vif",vif);
   // run_test("axi_lt_test");
    run_test();
end
/*
initial begin
    $fsdbDumpvars(0, tb_top);
    $fsdbDumpSVA;
end
 */ 
endmodule
