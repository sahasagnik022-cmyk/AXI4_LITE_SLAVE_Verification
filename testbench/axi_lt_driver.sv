class axi_lt_driver extends uvm_driver #(axi_lt_seq_item);
    `uvm_component_utils(axi_lt_driver)
    uvm_seq_item_pull_port #(axi_lt_seq_item) seq_item_port_rd;
    virtual axi_lt_if vif;

    function new(string name="axi_lt_driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq_item_port_rd = new("seq_item_port_rd", this);
        if(!uvm_config_db#(virtual axi_lt_if)::get(this, "","vif",vif)) begin
            `uvm_fatal("DRV","Failed to get virtual interface")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        wait(!vif.aresetn);
        vif.drv_cb.awaddr<=0;
        vif.drv_cb.awvalid<=0;
        vif.drv_cb.wdata<=0;
        vif.drv_cb.wstrb<=0;
        vif.drv_cb.wvalid<=0;
        vif.drv_cb.araddr<=0;
        vif.drv_cb.arvalid<=0;
        vif.drv_cb.rready<=0;
        vif.drv_cb.bready<=0;
        wait(vif.aresetn==1);
        fork
            forever begin
                axi_lt_seq_item wr_req;
                seq_item_port.get_next_item(wr_req);
                drive_write(wr_req);
                seq_item_port.item_done();
            end
            
            forever begin
                axi_lt_seq_item rd_req;
                seq_item_port_rd.get_next_item(rd_req);
                drive_read(rd_req);
                seq_item_port_rd.item_done();
            end
        join
    endtask

    virtual task drive_write(axi_lt_seq_item req);
       @(vif.drv_cb);
      // vif.drv_cb.bready<=1;
        fork
            begin
                repeat(req.delay_addr)@(vif.drv_cb);
                vif.drv_cb.awaddr<=req.awaddr;
                vif.drv_cb.awprot<=req.awprot;
                vif.drv_cb.awvalid<=1;
                `uvm_info("DRV", "waiting for awready", UVM_LOW)
                @(vif.drv_cb iff vif.drv_cb.awready==1);
                `uvm_info("DRV","got awready", UVM_LOW)
                vif.drv_cb.awvalid<=0;
            end
            begin
                repeat(req.delay_data)@(vif.drv_cb);
                vif.drv_cb.wdata<=req.wdata;
                vif.drv_cb.wstrb<=req.wstrb;
                vif.drv_cb.wvalid<=1;
                `uvm_info("DRV", "waiting for wready", UVM_LOW)
                @(vif.drv_cb iff vif.drv_cb.wready==1);
                `uvm_info("DRV","got wready", UVM_LOW)
                vif.drv_cb.wvalid<=0;
            end
        join
        vif.drv_cb.bready<=1;
        `uvm_info("DRV","waiting for bvalid", UVM_LOW)
        if (vif.drv_cb.bvalid !== 1) begin 
            @(vif.drv_cb iff vif.drv_cb.bvalid == 1);
        end
      `uvm_info("DRV", "got bvalid", UVM_LOW)
        vif.drv_cb.bready<=0;
    endtask

    virtual task drive_read(axi_lt_seq_item req);
        @(vif.drv_cb);
        vif.drv_cb.araddr<=req.araddr;
        vif.drv_cb.arprot<=req.arprot;
        vif.drv_cb.arvalid<=1;
        @(vif.drv_cb iff vif.drv_cb.arready==1);
        vif.drv_cb.arvalid<=0;
        @(vif.drv_cb);
        vif.drv_cb.rready<=1;
        @(vif.drv_cb iff vif.drv_cb.rvalid==1);
        vif.drv_cb.rready<=0;
    endtask

endclass
