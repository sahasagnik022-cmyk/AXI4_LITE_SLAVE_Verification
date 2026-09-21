class axi_lt_write3_seq extends uvm_sequence#(axi_lt_seq_item);
    `uvm_object_utils(axi_lt_write3_seq)

    function new(string name="axi_lt_write3_seq");
        super.new(name);
    endfunction

    task body();
        axi_lt_seq_item tx;
        `uvm_info("DBG","Start write seqquence", UVM_LOW)
        for(int i=0;i<10;i++) begin
            tx=axi_lt_seq_item::type_id::create("tx");
            start_item(tx);
          if(!tx.randomize() with {write_req==1; read_req==0;awaddr==i*4; wdata inside {[1:100]}; wstrb inside {[0:15]};delay_data==1;delay_addr==0;})
                `uvm_error("SEQ","Randomization failed");
          `uvm_info("DEBUG", "Randomization done", UVM_LOW)
            finish_item(tx);
        end
        `uvm_info("DBG","write seqquence completed", UVM_LOW)
    endtask

endclass
