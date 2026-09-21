class axi_lt_addr_first extends uvm_sequence#(axi_lt_seq_item);
  `uvm_object_utils(axi_lt_addr_first)

  function new(string name="axi_lt_addr_first");
    super.new(name);
  endfunction

  task body();
    axi_lt_seq_item tx;
    for(int i=0;i<10;i++) begin
    	tx=axi_lt_seq_item::type_id::create("tx");
    	start_item(tx);
      if(!tx.randomize() with {write_req==1;read_req==0;delay_addr==0;delay_data inside {[1:3]};awaddr==i*4;wstrb==15;})
      		`uvm_error("SEQ","Randomization failed");
    	finish_item(tx);
    end
  endtask

endclass
