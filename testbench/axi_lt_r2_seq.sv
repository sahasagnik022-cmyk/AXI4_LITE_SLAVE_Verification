class axi_lt_r2_seq extends uvm_sequence #(axi_lt_seq_item);
    `uvm_object_utils(axi_lt_r2_seq)

    function new(string name="axi_lt_r2_seq");
        super.new(name);
    endfunction

    task body();
        axi_lt_seq_item tx;
        tx=axi_lt_seq_item::type_id::create("tx");
        start_item(tx);
        if(!tx.randomize() with { write_req==0;read_req==1;araddr==32'd0;})
            `uvm_error("SEQ","Randomization failed");
        finish_item(tx);
    endtask

endclass
