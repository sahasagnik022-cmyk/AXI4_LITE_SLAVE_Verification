class axi_lt_write_read_parallel_test extends uvm_test;
    `uvm_component_utils(axi_lt_write_read_parallel_test)
    axi_lt_env env;

    function new(string name="axi_lt_write_read_parallel_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env=axi_lt_env::type_id::create("env",this);
    endfunction

    task run_phase(uvm_phase phase);
        axi_lt_write3_seq wpseq;
        axi_lt_read_seq rpseq;
        axi_lt_write_seq wp1seq;
        axi_lt_read2_seq rp1seq;
        phase.raise_objection(this);
        `uvm_info("TST","Parallel write read sequence",UVM_LOW)
        wpseq=axi_lt_write3_seq::type_id::create("wpseq");
        wp1seq=axi_lt_write_seq::type_id::create("wp1seq");
        rpseq=axi_lt_read_seq::type_id::create("rpseq");
        rp1seq=axi_lt_read2_seq::type_id::create("rp1seq");
        wpseq.start(env.in_agt.w_seqr);
        rp1seq.start(env.in_agt.r_seqr);
        fork
            wpseq.start(env.in_agt.w_seqr);
            rpseq.start(env.in_agt.r_seqr);
        join
        phase.drop_objection(this);
        `uvm_info("TST","Completed parallel write read sequence",UVM_LOW)
    endtask
endclass
