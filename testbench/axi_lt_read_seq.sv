class axi_lt_read_seq extends uvm_sequence #(axi_lt_seq_item);
    `uvm_object_utils(axi_lt_read_seq)

    function new(string name="axi_lt_read_seq");
        super.new(name);
    endfunction

    task body();
        axi_lt_seq_item tx;
        `uvm_info("DBG","starting read sequence",UVM_LOW)
        for(int i=0;i<10;i++) begin
            tx=axi_lt_seq_item::type_id::create("tx");
            start_item(tx);
            if(!tx.randomize() with { write_req==0;read_req==1;araddr==i*4;})
                `uvm_error("SEQ","Randomization failed");
            finish_item(tx);
        end
        `uvm_info("DBG","read sequence complete",UVM_LOW)
    endtask

endclass


