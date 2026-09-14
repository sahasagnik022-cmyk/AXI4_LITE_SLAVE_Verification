class axi_lt_in_agt extends uvm_agent;
    `uvm_component_utils(axi_lt_in_agt)
    axi_lt_sequencer w_seqr;
    axi_lt_sequencer r_seqr;
    axi_lt_driver drv;
    axi_lt_input_monitor in_mon;

    function new(string name="axi_lt_in_agt",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        in_mon=axi_lt_input_monitor::type_id::create("in_mon",this);
        if(get_is_active()==UVM_ACTIVE) begin
            drv=axi_lt_driver::type_id::create("drv",this);
            w_seqr=axi_lt_sequencer::type_id::create("w_seqr",this);
            r_seqr=axi_lt_sequencer::type_id::create("r_seqr",this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(get_is_active()==UVM_ACTIVE) begin
            drv.seq_item_port.connect(w_seqr.seq_item_export);
            drv.seq_item_port_rd.connect(r_seqr.seq_item_export);
        end
    endfunction

endclass




