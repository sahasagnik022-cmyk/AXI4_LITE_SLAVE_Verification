class axi_lt_data_first_test extends uvm_test;
    `uvm_component_utils(axi_lt_data_first_test)
    axi_lt_env env;

    function new(string name="axi_lt_data_first_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env=axi_lt_env::type_id::create("env",this);
    endfunction

    task run_phase(uvm_phase phase);
        axi_lt_data_first dfseq;
        phase.raise_objection(this);
        `uvm_info("TST","Data first sequence",UVM_LOW)
        dfseq=axi_lt_data_first::type_id::create("dfseq");
        dfseq.start(env.in_agt.w_seqr);
        phase.drop_objection(this);
        `uvm_info("TST","Completed data first sequence",UVM_LOW)
    endtask
endclass
