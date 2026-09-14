class axi_lt_error_test extends axi_lt_test;
    `uvm_component_utils(axi_lt_error_test)
    axi_lt_w2_seq w2_seq;
    axi_lt_r2_seq r2_seq;

    function new(string name="axi_lt_error_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        axi_lt_driver::type_id::set_type_override(axi_lt_error_driver::get_type());
        super.build_phase(phase);        
        `uvm_info("TEST", "Factory override applied: Error Driver is active!", UVM_NONE)
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        w2_seq=axi_lt_w2_seq::type_id::create("w2_seq");
        r2_seq=axi_lt_r2_seq::type_id::create("r2_seq");
        w2_seq.start(env.in_agt.w_seqr);
        r2_seq.start(env.in_agt.r_seqr);
        phase.drop_objection(this);

    endtask

endclass
