class axi_lt_data_first extends uvm_sequence#(axi_lt_seq_item);
  `uvm_object_utils(axi_lt_data_first)

  function new(string name="axi_lt_data_first");
    super.new(name);
  endfunction

  task body();
    axi_lt_seq_item tx;
    for(int i=5;i<10;i++) begin
    	tx=axi_lt_seq_item::type_id::create("tx");
    	start_item(tx);
      if(!tx.randomize() with {write_req==1;read_req==0;delay_addr inside {[1:3]};delay_data==0;awaddr==i*4;wstrb==15;})
      		`uvm_error("SEQ","Randomization failed");
    	finish_item(tx);
    end
  endtask

endclass
