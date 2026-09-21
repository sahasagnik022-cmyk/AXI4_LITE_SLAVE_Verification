
class axi_lt_write_seq extends uvm_sequence#(axi_lt_seq_item);
    `uvm_object_utils(axi_lt_write_seq)

    function new(string name="axi_lt_write_seq");
        super.new(name);
    endfunction

    task body();
        axi_lt_seq_item tx;
        `uvm_info("DBG","write sequence start", UVM_LOW)
        tx=axi_lt_seq_item::type_id::create("tx");
        start_item(tx);
        if(!tx.randomize() with {write_req==1;read_req==0;awaddr==32'h3C;wdata inside{[50:100]};wstrb inside {[0:15]};delay_data==0;delay_addr==1;})
            `uvm_error("SEQ","Randomization failed");
        finish_item(tx);
        `uvm_info("DBG","write sequence complete", UVM_LOW)
    endtask

endclass
