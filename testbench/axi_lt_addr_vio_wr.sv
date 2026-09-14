class axi_lt_addr_vio_wr extends uvm_sequence#(axi_lt_seq_item);
  `uvm_object_utils(axi_lt_addr_vio_wr)

  function new(string name="axi_lt_addr_vio_wr");
    super.new(name);
  endfunction

  task body();
    axi_lt_seq_item tx;
    tx=axi_lt_seq_item::type_id::create("tx");
    start_item(tx);
    `uvm_info("DEBUG", "START ADDR VIOLATION WRITE", UVM_LOW)
    if(!tx.randomize() with {write_req==1;read_req==0;wstrb==15;delay_addr==1;delay_data==0;awaddr inside {[32'h40:32'hFFFFFFFF]};})
      `uvm_error("SEQ","Randomization failed");
    finish_item(tx);
    `uvm_info("DEBUG", "COMPLETED ADDR VIOLATION WRITE", UVM_LOW)
  endtask
endclass
