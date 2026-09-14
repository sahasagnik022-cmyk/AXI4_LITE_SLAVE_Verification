`include "defines.svh"
interface axi_lt_if(input bit aclk, aresetn);
    logic [`aw-1:0] awaddr;
    logic [2:0] awprot;
    logic  awvalid;
    logic  awready;
    logic [`dw-1:0] wdata;
    logic [(`dw/8)-1:0]  wstrb;
    logic wvalid;
    logic wready;
    logic [1:0] bresp;
    logic  bvalid;
    logic  bready;
    logic [`aw-1:0] araddr;
    logic [2:0] arprot; 
    logic arvalid;
    logic arready;
    logic [`dw-1:0] rdata;
    logic [1:0]rresp;
    logic rready;
    logic rvalid;
    clocking drv_cb @(posedge aclk);
        default input #1 output #1;
        output awaddr,awvalid,wdata,wstrb,wvalid,bready,araddr,arvalid,rready,awprot,arprot;
        input  awready,wready,bvalid,bresp,arready,rvalid,rdata,rresp;
    endclocking
    clocking in_mon_cb @(posedge aclk);
        default input #1 output #1;
        input awaddr,awvalid,awready,wdata,wstrb,wvalid,wready,araddr,arvalid,arready,awprot,arprot;
    endclocking
    clocking out_mon_cb @(posedge aclk);
        default input #1 output #1;
        input bresp,bvalid,bready,rdata,rresp,rvalid,rready;
    endclocking
    modport drv(clocking drv_cb, input aclk, aresetn);
    modport in_mon(clocking in_mon_cb, input aclk, aresetn);
    modport out_mon(clocking out_mon_cb, input aclk, aresetn);
endinterface
