class axi_lt_error_driver extends axi_lt_driver;
    `uvm_component_utils(axi_lt_error_driver)

    function new(string name = "axi_lt_error_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task drive_write(axi_lt_seq_item req);
        @(vif.drv_cb);
        `uvm_info("EDRV","Send first address",UVM_MEDIUM)
        vif.drv_cb.awaddr<=req.awaddr;
        vif.drv_cb.awvalid<=1;
        `uvm_info("EDRV", $sformatf("addr:%0h", req.awaddr),UVM_MEDIUM)
        `uvm_info("EDRV","Waiting for first awready",UVM_MEDIUM)
        @(vif.drv_cb);
    //    `uvm_info("EDRV","Got awready",UVM_MEDIUM)
        vif.drv_cb.awvalid<=0;
        repeat(3) @(vif.drv_cb);
        `uvm_info("EDRV", "Send second address", UVM_MEDIUM)
        vif.drv_cb.awaddr<=req.awaddr+32'h60;
        vif.drv_cb.awvalid<=1;
        `uvm_info("EDRV", $sformatf("addr:%0h", req.awaddr+32'h60),UVM_MEDIUM)
        `uvm_info("EDRV","Waiting for second awready",UVM_MEDIUM)
        @(vif.drv_cb);
     //   `uvm_info("EDRV","Got awready",UVM_MEDIUM)
        vif.drv_cb.awvalid<=0;
        vif.drv_cb.wdata<=req.wdata;
        vif.drv_cb.wstrb <=req.wstrb;
        vif.drv_cb.wvalid<=1;
        @(vif.drv_cb);
        vif.drv_cb.wvalid <= 0;
        vif.drv_cb.bready <= 1;
        @(vif.drv_cb);
        vif.drv_cb.bready <= 0;
        `uvm_info("EDRV", "Error tx done", UVM_MEDIUM)
    endtask 

 /*   task drive_write(axi_lt_seq_item req);
         @(vif.drv_cb);
        `uvm_info("EDRV","Send first data",UVM_MEDIUM)
         vif.drv_cb.wdata <= req.wdata;
         vif.drv_cb.wstrb <=req.wstrb;
         vif.drv_cb.wvalid <= 1;
        `uvm_info("EDRV", $sformatf("data:%0h", req.wdata),UVM_MEDIUM)
        `uvm_info("EDRV","Waiting for first wready",UVM_MEDIUM)
      //  @(vif.drv_cb iff vif.drv_cb.wready == 1);
      @(vif.drv_cb);
        `uvm_info("EDRV","Got wready",UVM_MEDIUM)
         vif.drv_cb.wvalid <= 0;
         repeat(3) @(vif.drv_cb);
        `uvm_info("EDRV", "Send second data", UVM_MEDIUM)
         vif.drv_cb.wdata<=100;
         vif.drv_cb.wstrb <=req.wstrb;
         vif.drv_cb.wvalid<=1;
        `uvm_info("EDRV", $sformatf("data:%0h",req.wdata+100),UVM_MEDIUM)
        `uvm_info("EDRV","Waiting for second wready",UVM_MEDIUM)
     //   @(vif.drv_cb iff vif.drv_cb.awready == 1);
         @(vif.drv_cb);
        `uvm_info("EDRV","Got wready",UVM_MEDIUM)
         vif.drv_cb.wvalid<=0;
         vif.drv_cb.awaddr<=req.awaddr;
         vif.drv_cb.awvalid<=1;
         @(vif.drv_cb);
        // @(vif.drv_cb iff vif.drv_cb.awready == 1);
         vif.drv_cb.awvalid <= 0;
         vif.drv_cb.bready <= 1;
         @(vif.drv_cb);
        //  @(vif.drv_cb iff vif.drv_cb.bvalid == 1);
         vif.drv_cb.bready <= 0;
        `uvm_info("EDRV", "Error tx done", UVM_MEDIUM)
    endtask */
endclass
