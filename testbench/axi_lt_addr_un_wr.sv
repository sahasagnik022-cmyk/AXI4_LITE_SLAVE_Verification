class axi_lt_addr_un_wr extends uvm_sequence#(axi_lt_seq_item);
  `uvm_object_utils(axi_lt_addr_un_wr)

  function new(string name="axi_lt_addr_un_wr");
    super.new(name);
  endfunction

  task body();
    axi_lt_seq_item tx;
    tx=axi_lt_seq_item::type_id::create("tx");
    start_item(tx);
    `uvm_info("DEBUG", "START ADDR UNALIGN WRITE", UVM_LOW)
    if(!tx.randomize() with {write_req==1;read_req==0;wstrb==15;delay_addr==0;delay_data==1;awaddr inside {[32'h0:32'h24]}; awaddr[1:0]!=2'b00;})
      `uvm_error("SEQ","Randomization failed");
    finish_item(tx);
    `uvm_info("DEBUG", "COMPLETED ADDR UNALIGN WRITE", UVM_LOW)
  endtask
endclass
