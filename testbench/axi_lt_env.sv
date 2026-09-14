class axi_lt_env extends uvm_env;
    `uvm_component_utils(axi_lt_env);
    axi_lt_in_agt in_agt;
    axi_lt_out_agt out_agt;
    axi_lt_scoreboard scb;
    axi_lt_subscriber sub;

    function new(string name="axi_lt_env",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        in_agt=axi_lt_in_agt::type_id::create("in_agt",this);
        out_agt=axi_lt_out_agt::type_id::create("out_agt",this);
        scb=axi_lt_scoreboard::type_id::create("scb",this);
        sub=axi_lt_subscriber::type_id::create("sub",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        in_agt.in_mon.ap_in.connect(scb.port_in);
        out_agt.out_mon.ap_out.connect(scb.port_out);
        in_agt.in_mon.ap_in.connect(sub.analysis_export);
    endfunction

endclass
