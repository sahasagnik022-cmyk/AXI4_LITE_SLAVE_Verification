class axi_lt_input_monitor extends uvm_monitor;
    `uvm_component_utils(axi_lt_input_monitor)
    virtual axi_lt_if vif;
    uvm_analysis_port #(axi_lt_seq_item) ap_in;
    bit aw_done;
    bit w_done;
    bit [31:0] c_awaddr;
    bit [31:0] c_wdata;
    bit [3:0] c_wstrb;

    function new(string name="axi_lt_input_monitor",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_in=new("ap_in",this);
        if(!uvm_config_db#(virtual axi_lt_if)::get(this,"","vif",vif)) begin
            `uvm_fatal("MON", "Failed to get virtual interface")
        end
    endfunction

    task run_phase(uvm_phase phase);
        wait(vif.aresetn==1);
        aw_done=0;
        w_done=0;
        fork
            mon_write_addr();
            mon_write_data();
            mon_read_addr();
        join_none
    endtask

    task mon_read_addr();
        axi_lt_seq_item tx;
        forever begin
            @(vif.in_mon_cb);
            if(vif.in_mon_cb.arvalid && vif.in_mon_cb.arready) begin
                tx=axi_lt_seq_item::type_id::create("tx");
                tx.araddr=vif.in_mon_cb.araddr;
                tx.read_req=1;
                ap_in.write(tx);
            end
        end
    endtask

    task mon_write_addr();
        forever begin
            @(vif.in_mon_cb iff (vif.in_mon_cb.awvalid && vif.in_mon_cb.awready));
            c_awaddr=vif.in_mon_cb.awaddr;
            aw_done=1;
            check_done();
            @(vif.in_mon_cb iff (!vif.in_mon_cb.awvalid || !vif.in_mon_cb.awready));
        end
    endtask

    task mon_write_data();
        forever begin
            @(vif.in_mon_cb iff (vif.in_mon_cb.wvalid && vif.in_mon_cb.wready));
            c_wdata=vif.in_mon_cb.wdata;
            c_wstrb=vif.in_mon_cb.wstrb;
            w_done=1;
            check_done();
            @(vif.in_mon_cb iff (!vif.in_mon_cb.wvalid || !vif.in_mon_cb.wready));
        end
    endtask


    task check_done();
        axi_lt_seq_item tx;
        if(aw_done && w_done) begin
            tx=axi_lt_seq_item::type_id::create("tx");
            tx.awaddr=c_awaddr;
            tx.wdata=c_wdata;
            tx.wstrb=c_wstrb;
            tx.write_req=1;
           `uvm_info("MON",$sformatf("Sending write tX to scoreboard Addr:%0h|Data:%0h|wstrb:%0d",tx.awaddr,tx.wdata,tx.wstrb),UVM_LOW)
            ap_in.write(tx);
            aw_done=0;
            w_done=0;
        end
    endtask
endclass
