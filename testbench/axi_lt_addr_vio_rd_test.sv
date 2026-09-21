class axi_lt_addr_vio_rd_test extends uvm_test;
    `uvm_component_utils(axi_lt_addr_vio_rd_test)
    axi_lt_env env;

    function new(string name="axi_lt_addr_vio_rd_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env=axi_lt_env::type_id::create("env",this);
    endfunction

    task run_phase(uvm_phase phase);
        axi_lt_addr_vio_rd arseq;
        phase.raise_objection(this);
        `uvm_info("TST","Addr read violation sequence",UVM_LOW)
        arseq=axi_lt_addr_vio_rd::type_id::create("arseq");
        arseq.start(env.in_agt.r_seqr);
        phase.drop_objection(this);
        `uvm_info("TST","Completed Addr read violation sequence",UVM_LOW)
    endtask
endclass
