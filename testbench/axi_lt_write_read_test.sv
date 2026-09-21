class axi_lt_write_read_test extends uvm_test;
    `uvm_component_utils(axi_lt_write_read_test)
    axi_lt_env env;

    function new(string name="axi_lt_write_read_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env=axi_lt_env::type_id::create("env",this);
    endfunction

    task run_phase(uvm_phase phase);
        axi_lt_write2_seq wseq;
        axi_lt_read_seq rseq;
        phase.raise_objection(this);
        `uvm_info("TST","Write read sequence",UVM_LOW)
        wseq=axi_lt_write2_seq::type_id::create("wseq");
        rseq=axi_lt_read_seq::type_id::create("rseq");
        wseq.start(env.in_agt.w_seqr);
        rseq.start(env.in_agt.r_seqr);
        phase.drop_objection(this);
        `uvm_info("TST","Completed write read sequence",UVM_LOW)
    endtask
endclass
