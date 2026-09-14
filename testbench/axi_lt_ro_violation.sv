class axi_lt_ro_violation extends uvm_sequence#(axi_lt_seq_item);
  `uvm_object_utils(axi_lt_ro_violation)

  function new(string name="axi_lt_ro_violation");
    super.new(name);
  endfunction

  task body();
    axi_lt_seq_item tx;
    tx=axi_lt_seq_item::type_id::create("tx");
    `uvm_info("DEBUG", "START RO VIOLATION", UVM_LOW)
    start_item(tx);
    if(!tx.randomize() with {write_req==1;read_req==0;wstrb==15;delay_data==0;delay_addr==1;awaddr inside {32'h28,32'h2C,32'h30};})
      `uvm_error("SEQ","Randomization failed");
    finish_item(tx);
    `uvm_info("DEBUG", "COMPLETED RO VIOLATION", UVM_LOW)
  endtask

endclass
