class axi_lt_addr_vio_rd extends uvm_sequence#(axi_lt_seq_item);
    `uvm_object_utils(axi_lt_addr_vio_rd)
    function new(string name="axi_lt_addr_vio_rd");
        super.new(name);
    endfunction

    task body();
        axi_lt_seq_item tx;
        tx=axi_lt_seq_item::type_id::create("tx");
      `uvm_info("DEBUG", "START ADDR VIOLATION READ", UVM_LOW)
        start_item(tx);
        if(!tx.randomize() with {write_req==0;read_req==1;araddr inside {[32'h40:32'hFFFFFFFF]};})
            `uvm_error("SEQ","Randomization failed");
        finish_item(tx);
      `uvm_info("DEBUG", "COMPLETED ADDR VIOLATION READ", UVM_LOW)
    endtask

endclass
