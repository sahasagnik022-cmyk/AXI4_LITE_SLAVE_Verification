class axi_lt_subscriber extends uvm_subscriber#(axi_lt_seq_item);
    `uvm_component_utils(axi_lt_subscriber)
    axi_lt_seq_item tx;

    covergroup cg;
        cp_AWADDR:coverpoint tx.awaddr[5:2]{
            bins aw[]={[0:9],[13:15]};
        }
        cp_ARADDR:coverpoint tx.araddr[5:2]{
            bins ar[]={[0:12],15};
        }
        cp_WDATA: coverpoint tx.wdata{
            bins low={[0:32'h0000FFFF]};
            bins med={[32'h00010000:32'h7FFFFFFF]};
            bins high={[32'h80000000:32'hFFFFFFFF]};
        }
        cp_WSTRB:coverpoint tx.wstrb{
            bins strb[]={1,2,4,8,15};
        }

        cp_WDATA_WSTRB:cross cp_WDATA,cp_WSTRB;
    endgroup

    function new(string name="axi_lt_subscriber",uvm_component parent=null);
        super.new(name,parent);
        cg=new();
    endfunction

    virtual function void write(axi_lt_seq_item t);
        tx=t;
        cg.sample();
    endfunction

endclass


