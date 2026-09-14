class axi_lt_out_agt extends uvm_agent;
    `uvm_component_utils(axi_lt_out_agt)
    axi_lt_output_monitor out_mon;

    function new(string name="axi_lt_out_agt",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        out_mon=axi_lt_output_monitor::type_id::create("out_mon",this);
    endfunction

endclass

