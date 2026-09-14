
class axi_lt_w2_seq extends uvm_sequence#(axi_lt_seq_item);
    `uvm_object_utils(axi_lt_w2_seq)

    function new(string name="axi_lt_w2_seq");
        super.new(name);
    endfunction

    task body();
        axi_lt_seq_item tx;
            tx=axi_lt_seq_item::type_id::create("tx");
            start_item(tx);
          if(!tx.randomize() with {write_req==1; read_req==0;awaddr==32'd0; wdata inside {[1:100]}; wstrb==15;})
                `uvm_error("SEQ","Randomization failed");
          `uvm_info("DEBUG", "Randomization done", UVM_LOW)
            finish_item(tx);
        `uvm_info("DEBUG", "WRITE SEQUENCE COMPLETED SUCCESSFULLY", UVM_LOW)
    endtask

endclass
