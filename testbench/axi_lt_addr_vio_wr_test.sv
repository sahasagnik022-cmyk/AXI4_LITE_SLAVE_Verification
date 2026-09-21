class axi_lt_addr_vio_wr_test extends uvm_test;
    `uvm_component_utils(axi_lt_addr_vio_wr_test)
    axi_lt_env env;

    function new(string name="axi_lt_addr_vio_wr_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env=axi_lt_env::type_id::create("env",this);
    endfunction

    task run_phase(uvm_phase phase);
        axi_lt_addr_vio_wr awseq;
        phase.raise_objection(this);
        `uvm_info("TST","Addr write violation sequence",UVM_LOW)
        awseq=axi_lt_addr_vio_wr::type_id::create("awseq");
        awseq.start(env.in_agt.w_seqr);
        phase.drop_objection(this);
        `uvm_info("TST","Completed Addr write violation sequence",UVM_LOW)
    endtask
endclass
