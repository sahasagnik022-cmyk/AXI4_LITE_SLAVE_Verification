class axi_lt_output_monitor extends uvm_monitor;
    `uvm_component_utils(axi_lt_output_monitor)
    virtual axi_lt_if vif;
    uvm_analysis_port #(axi_lt_seq_item) ap_out;

    function new(string name="axi_lt_output_monitor",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_out=new("ap_out",this);
        uvm_config_db#(virtual axi_lt_if)::get(this,"","vif",vif);
    endfunction

    task run_phase(uvm_phase phase);
        wait(vif.aresetn==1);
        fork
            mon_read_resp();
            mon_write_resp();
        join_none
    endtask

    task mon_read_resp();
        axi_lt_seq_item tx;
        forever begin
            @(vif.out_mon_cb);
            if(vif.out_mon_cb.rready && vif.out_mon_cb.rvalid) begin
                tx=axi_lt_seq_item::type_id::create("tx");
                tx.rdata=vif.out_mon_cb.rdata;
                tx.rresp=vif.out_mon_cb.rresp;
                tx.read_req=1;
                ap_out.write(tx);
            end
        end
    endtask

    task mon_write_resp();
        axi_lt_seq_item tx;
        forever begin
            @(vif.out_mon_cb);
            if(vif.out_mon_cb.bready && vif.out_mon_cb.bvalid) begin
                tx=axi_lt_seq_item::type_id::create("tx");
                tx.bresp=vif.out_mon_cb.bresp;
                tx.write_req=1;
                ap_out.write(tx);
            end
        end
    endtask

endclass
