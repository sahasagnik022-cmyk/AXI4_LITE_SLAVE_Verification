class axi_lt_seq_item extends uvm_sequence_item;
    `uvm_object_utils(axi_lt_seq_item)

    rand bit write_req;
    rand bit read_req;
    rand int delay_addr;
    rand int delay_data;
    rand bit [`aw-1:0] awaddr;
    rand bit [`dw-1:0] wdata;
    rand bit [(`dw/8)-1:0] wstrb;
    rand bit [`aw-1:0] araddr;
    rand bit [2:0] awprot;
    rand bit [2:0] arprot;
    bit [1:0] rresp;
    bit [1:0] bresp;
    bit [`dw-1:0] rdata;

    function new(string name="axi_lt_seq_item");
        super.new(name);
    endfunction

    function void do_copy(uvm_object rhs);
    axi_lt_seq_item rhs_;
    if (!$cast(rhs_, rhs)) begin
        `uvm_fatal("DO_COPY", "Cast failed - wrong object type");
    end
    super.do_copy(rhs);
    this.write_req  = rhs_.write_req;
    this.read_req   = rhs_.read_req;
    this.delay_addr = rhs_.delay_addr;
    this.delay_data = rhs_.delay_data;
    this.awaddr     = rhs_.awaddr;
    this.wdata      = rhs_.wdata;
    this.wstrb      = rhs_.wstrb;
    this.araddr     = rhs_.araddr;
    this.awprot     = rhs_.awprot;
    this.arprot     = rhs_.arprot;
    this.rresp      = rhs_.rresp;
    this.bresp      = rhs_.bresp;
    this.rdata      = rhs_.rdata;
    endfunction

    constraint valid_req{
        (write_req==1)||(read_req==1);
    }

    constraint address_delay{
       soft delay_addr == 0;
    }

    constraint data_delay{
       soft delay_data == 0;
    }

    constraint addr_align{
        soft awaddr[1:0]==2'b00;
        soft araddr[1:0]==2'b00;
    }

    constraint addr_range{
        soft araddr<=32'h3C;
        soft awaddr<=32'h3C;
    }

    constraint prot{
        arprot inside {[0:7]};
        awprot inside {[0:7]};
    }

endclass



