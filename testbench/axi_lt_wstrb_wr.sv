class axi_lt_wstrb_wr extends uvm_sequence#(axi_lt_seq_item);
  `uvm_object_utils(axi_lt_wstrb_wr)

  function new(string name="axi_lt_wstrb_wr");
    super.new(name);
  endfunction
  bit [3:0] strb[$]='{1,2,4,8,15};
  task body();
    axi_lt_seq_item tx;
   // strb[$]=`{1,2,4,8,15};
    `uvm_info("DEBUG", "START WRITE STRB", UVM_LOW)
    foreach(strb[i]) begin
      tx=axi_lt_seq_item::type_id::create("tx");
      start_item(tx);
      if(!tx.randomize() with {write_req==1;read_req==0;delay_addr==1;delay_data==0; awaddr==i*4; wstrb==strb[i];})
        `uvm_error("SEQ","Randomization failed");
      finish_item(tx);
    end
    `uvm_info("DEBUG", "COMPLETED WRITE STRB ", UVM_LOW)
  endtask

endclass
