`uvm_analysis_imp_decl (_in)
`uvm_analysis_imp_decl (_out)

class axi_lt_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(axi_lt_scoreboard)
    uvm_analysis_imp_in #(axi_lt_seq_item,axi_lt_scoreboard) port_in;
    uvm_analysis_imp_out #(axi_lt_seq_item,axi_lt_scoreboard) port_out;

    bit [31:0] ref_mem[int];
    axi_lt_seq_item exp_wr_q[$];
    axi_lt_seq_item exp_rd_q[$];

    function new(string name="axi_lt_scoreboard",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        port_in = new("port_in",this);
        port_out = new("port_out",this);
    endfunction

    function void write_in(axi_lt_seq_item tx);
        axi_lt_seq_item exp_tx;
        bit [3:0] word_idx;
        bit [31:0] exp_data;
        `uvm_info("SCB","Cloning transaction",UVM_MEDIUM)
      $cast(exp_tx,tx.clone());

        if(exp_tx.write_req == 1) begin
            word_idx = exp_tx.awaddr[5:2];
            exp_tx.bresp = 2'b00;

            if(word_idx > 15 || exp_tx.awaddr>32'h3C) begin
                exp_tx.bresp = 2'b11;
            end
            else if(word_idx >= 10 && word_idx <= 12 || exp_tx.awaddr[1:0]!=2'b00) begin
                exp_tx.bresp = 2'b10;
            end
            if(exp_tx.bresp == 2'b00) begin
                exp_data = ref_mem.exists(word_idx) ? ref_mem[word_idx] : 32'd0;
                
                for(int i=0; i<4; i++) begin
                    if(exp_tx.wstrb[i] == 1) begin
                        exp_data[i*8+:8]=exp_tx.wdata[i*8+:8];
                    end
                end
                ref_mem[word_idx] = exp_data;
            end
            `uvm_info("SCB","Push write tx in write queue",UVM_MEDIUM)
            exp_wr_q.push_back(exp_tx);
        end
        else if(exp_tx.read_req == 1) begin
            word_idx = exp_tx.araddr[5:2];
            exp_tx.rresp = 2'b00;

            if(word_idx > 15 || exp_tx.araddr>32'h3C) begin
                exp_tx.rresp = 2'b11;
            end
            else if(word_idx >= 13 && word_idx <= 14 || exp_tx.araddr[1:0]!=2'b00) begin
                exp_tx.rresp = 2'b10;
            end
            if(exp_tx.rresp == 2'b00) begin
                if(ref_mem.exists(word_idx)) begin
                    exp_tx.rdata = ref_mem[word_idx];
                end else begin
                    exp_tx.rdata = 32'd0; 
                end
            end
            `uvm_info("SCB","Push read tx in read queue",UVM_MEDIUM)
            exp_rd_q.push_back(exp_tx);
        end
    endfunction

    function void write_out(axi_lt_seq_item tx);
        axi_lt_seq_item exp_tx;
        
        if (tx.write_req == 1) begin
            if(exp_wr_q.size() == 0) begin
                `uvm_error("SCB","Expected write queue is empty!")
                return;
            end
            exp_tx = exp_wr_q.pop_front();
            
            if (tx.bresp !== exp_tx.bresp) begin
                `uvm_error("SCB_FAIL", $sformatf("Write resp mismatch! Addr: %0h | Act: %0b | Exp: %0b", exp_tx.awaddr, tx.bresp, exp_tx.bresp))
            end else begin
              `uvm_info("SCB_PASS",$sformatf("Write response matched for Addr:%0h| resp:%0b", exp_tx.awaddr,tx.bresp), UVM_MEDIUM)
            end
        end
        else if (tx.read_req == 1) begin
            if(exp_rd_q.size() == 0) begin
                `uvm_error("SCB", "Expected read queue is empty!")
                return;
            end
            exp_tx = exp_rd_q.pop_front();
            
            if(tx.rresp !== exp_tx.rresp) begin
                `uvm_error("SCB_FAIL", $sformatf("Read resp mismatch! Addr: %0h | Act: %0b | Exp: %0b", exp_tx.araddr, tx.rresp, exp_tx.rresp))
            end
            else if(exp_tx.rresp == 2'b00 && tx.rdata !== exp_tx.rdata) begin
              `uvm_error("SCB_FAIL", $sformatf("Read data mismatch! Addr: %0h | Act: %0h | Exp: %0h", exp_tx.araddr, tx.rdata, exp_tx.rdata))
            end
            else begin
              `uvm_info("SCB_PASS",$sformatf("Read data and response matched for Addr:%0h|Data:%0h|Resp:%0b", exp_tx.araddr,exp_tx.rdata,exp_tx.rresp), UVM_MEDIUM)
            end
        end
    endfunction
endclass
