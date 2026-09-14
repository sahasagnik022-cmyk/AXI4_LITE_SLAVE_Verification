class axi_lt_sequencer extends uvm_sequencer#(axi_lt_seq_item);
    `uvm_component_utils(axi_lt_sequencer)

    function new(string name="axi_lt_sequencer",uvm_component parent=null);
        super.new(name,parent);
    endfunction

endclass

