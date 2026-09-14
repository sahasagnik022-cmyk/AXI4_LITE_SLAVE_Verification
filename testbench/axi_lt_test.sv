class axi_lt_test extends uvm_test;
    `uvm_component_utils(axi_lt_test)
    axi_lt_env env;
    axi_lt_write_seq wseq;
    axi_lt_read_seq rseq;
    axi_lt_read2_seq r2seq;
    axi_lt_addr_first afseq;
    axi_lt_data_first dfseq;
    axi_lt_wo_violation woseq;
    axi_lt_ro_violation roseq;
    axi_lt_addr_vio_wr awseq;
    axi_lt_addr_vio_rd arseq;
    axi_lt_addr_un_rd urseq;
    axi_lt_addr_un_wr uwseq;
    axi_lt_wstrb_wr wtseq;
  

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

    virtual task run_phase(uvm_phase phase);
        `uvm_info("DBG","sequences start,raise objection", UVM_LOW)
        phase.raise_objection(this);
        afseq=axi_lt_addr_first::type_id::create("afseq");
        dfseq=axi_lt_data_first::type_id::create("dfseq");
        woseq=axi_lt_wo_violation::type_id::create("woseq");
        roseq=axi_lt_ro_violation::type_id::create("roseq");
        rseq=axi_lt_read_seq::type_id::create("rseq");
        awseq=axi_lt_addr_vio_wr::type_id::create("awseq");
        arseq=axi_lt_addr_vio_rd::type_id::create("arseq");
        urseq=axi_lt_addr_un_rd::type_id::create("urseq");
        uwseq=axi_lt_addr_un_wr::type_id::create("uwseq");
        wtseq=axi_lt_wstrb_wr::type_id::create("wtseq");
        r2seq=axi_lt_read2_seq::type_id::create("r2seq");
        wseq=axi_lt_write_seq::type_id::create("wseq");
        repeat(50) begin
            afseq.start(env.in_agt.w_seqr);
            dfseq.start(env.in_agt.w_seqr);
            rseq.start(env.in_agt.r_seqr);
            woseq.start(env.in_agt.r_seqr);
            roseq.start(env.in_agt.w_seqr);
            awseq.start(env.in_agt.w_seqr);
            arseq.start(env.in_agt.r_seqr);
            uwseq.start(env.in_agt.w_seqr);
      		urseq.start(env.in_agt.r_seqr);
            wtseq.start(env.in_agt.w_seqr);
            rseq.start(env.in_agt.r_seqr);
            wseq.start(env.in_agt.w_seqr);
            r2seq.start(env.in_agt.r_seqr);
        end
      	/*	fork
              wseq.start(env.in_agt.w_seqr);
              rseq.start(env.in_agt.r_seqr);
            join */
              
        `uvm_info("DBG","sequences finished,drop objection", UVM_LOW)
        phase.drop_objection(this);
    endtask

endclass
