class axi_lt_test extends uvm_test;
    `uvm_component_utils(axi_lt_test)
    axi_lt_env env;
    axi_lt_write_seq wseq;
    axi_lt_read_seq rseq;
    axi_lt_addr_first afseq;
    axi_lt_data_first dfseq;
    axi_lt_wstrb_wr stseq;
    axi_lt_wo_violation wvseq;
    axi_lt_ro_violation rvseq;
    axi_lt_addr_vio_wr awseq;
    axi_lt_addr_vio_rd arseq;
    axi_lt_b2b_write w2seq;
    axi_lt_b2b_read r2seq;

    function new(string name="axi_lt_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env=axi_lt_env::type_id::create("env",this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        wseq=axi_lt_write_seq::type_id::create("wseq");
        wseq.start(env.in_agt.w_seqr);
        rseq=axi_lt_read_seq::type_id::create("rseq");
        rseq.start(env.in_agt.r_seqr);
        afseq=axi_lt_addr_first::type_id::create("afseq");
        afseq.start(env.in_agt.w_seqr);
        dfseq=axi_lt_data_first::type_id::create("dfseq");
        dfseq.start(env.in_agt.w_seqr);
        stseq=axi_lt_wstrb_wr::type_id::create("stseq");
        stseq.start(env.in_agt.w_seqr);
        wvseq=axi_lt_wo_violation::type_id::create("wvseq");
        wvseq.start(env.in_agt.r_seqr);
        rvseq=axi_lt_ro_violation::type_id::create("rvseq");
        rvseq.start(env.in_agt.w_seqr);
        awseq=axi_lt_addr_vio_wr::type_id::create("awseq");
        awseq.start(env.in_agt.w_seqr);
        arseq=axi_lt_addr_vio_rd::type_id::create("arseq");
        arseq.start(env.in_agt.r_seqr);
        fork
        begin
            w2seq=axi_lt_b2b_write::type_id::create("w2seq");
            w2seq.start(env.in_agt.w_seqr);
        end
        begin
            r2seq=axi_lt_b2b_read::type_id::create("r2seq");
            r2seq.start(env.in_agt.r_seqr);
        end
        join
        phase.drop_objection(this);
    endtask

endclass
