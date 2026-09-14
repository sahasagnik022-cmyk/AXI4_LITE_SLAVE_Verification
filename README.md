# AMBA AXI4-Lite Slave UVM Verification Environment

## 📌 Project Overview
The objective of this project is to verify the functional correctness and protocol compliance of an AMBA AXI4-Lite slave design using the Universal Verification Methodology (UVM)[cite: 1]. AXI4-Lite is widely used for low-throughput control register accesses, requiring strict adherence to unpipelined, in-order handshake protocols across its address, data, and response channels[cite: 1]. This verification environment is built in SystemVerilog using Synopsys VCS and Verdi[cite: 1]. The testing strategy employs constrained-random stimulus generation to cover base operational scenarios, Assertion-Based Verification (ABV) for continuous protocol monitoring, and negative testing techniques via UVM Factory overrides to validate the design's robustness against intentional protocol violations[cite: 1].

## 🏗️ Verification Architecture
The environment follows a standard UVM topology, utilizing transaction-level modeling (TLM) to decouple stimulus generation from signal-level pin toggling[cite: 1]. The architecture is designed to handle strict delta-cycle scheduling and avoid race conditions during continuous capture[cite: 1].

* **Sequences and Sequencer:** Generates randomized `axi_lt_seq_item` transactions[cite: 1]. The environment utilizes a dual-sequencer architecture—one dedicated to write sequences and another to read sequences—to accurately model the independent nature of the AXI protocol's read and write channels[cite: 1]. Dedicated error sequences (e.g., `axi_lt_w2_seq`) are used to target corner cases[cite: 1].
* **Driver:** Translates TLM transactions into cycle-accurate AXI4-Lite pin toggles[cite: 1]. The driver implements an additional TLM pull port (`uvm_seq_item_pull_port #(axi_lt_seq_item) seq_item_port_rd;`) to fetch from both sequencers independently and drive read and write channels concurrently using `fork...join` blocks[cite: 1]. A custom `axi_lt_error_driver` is registered in the UVM Factory to safely inject protocol errors using watchdog timers to prevent simulation deadlocks[cite: 1].
* **Monitors (Input and Output):** Passively sample the virtual interface on valid handshakes (VALID and READY high)[cite: 1]. They utilize delta-delay synchronization (`#0`) and strict transition wait states to prevent multiple-triggering bugs and pointer corruption[cite: 1].
* **Scoreboard:** Acts as the golden reference model[cite: 1]. It maintains an associative array (`ref_mem`) to predict memory states and separate queues (`exp_wr_q`, `exp_rd_q`) for incoming write and read expectations[cite: 1]. It independently calculates expected responses (`BRESP` and `RRESP`), accounting for decoding errors[cite: 1].
* **SystemVerilog Assertions (SVA):** Encapsulated within a dedicated assertion module and instantiated non-intrusively into the design hierarchy using the SystemVerilog `bind` construct in the top-level testbench (`tb_top`)[cite: 1]. These act as an independent protocol watchdog, concurrently enforcing AXI Valid-Stability rules without relying on UVM temporal logic[cite: 1].

## 🧪 Test Plan & Execution
The verification strategy includes reset/sanity tests, decoupled channel timing manipulation, error response boundary targeting (read-only, out-of-bounds, unaligned), and stress/override testing[cite: 1]. 

| Feature | Test Name | Expected Output | Status | Failure Reason (If Applicable) |
| :--- | :--- | :--- | :--- | :--- |
| **Reset Behaviour** | `axi_lt_sys_reset` | All output pins are cleared[cite: 1] | ✅ PASS[cite: 1] | |
| **Normal Read/Write** | `axi_lt_sanity_rw` | Data correctly written and RDATA matches[cite: 1] | ✅ PASS[cite: 1] | |
| **Decoupled Channels** | `axi_lt_addr_data_both` | Transaction completes OKAY only after data arrives[cite: 1] | ❌ **FAIL**[cite: 1] | Simulation hangs as DUT is not sending bvalid[cite: 1] |
| **Decoupled Channels** | `axi_lt_addr_first` | Transaction completes OKAY only after address arrives[cite: 1] | ✅ PASS[cite: 1] | |
| **Decoupled Channels** | `axi_lt_data_first` | Transaction completes OKAY only after address arrives[cite: 1] | ✅ PASS[cite: 1] | |
| **Parallel Read/Write** | `axi_lt_parallel_rw` | Slave should process both operations independently[cite: 1] | ❌ **FAIL**[cite: 1] | Parallel read/write functionality of DUT is not functioning[cite: 1] |
| **Byte Enables** | `axi_lt_wstrb_write` | Proper data written into the slave[cite: 1] | ✅ PASS[cite: 1] | |
| **Error Response** | `axi_lt_ro_violation` | Slave should return SLVERR[cite: 1] | ✅ PASS[cite: 1] | |
| **Error Response** | `axi_lt_wo_violation` | Slave should return SLVERR and RDATA is 0/default[cite: 1] | ✅ PASS[cite: 1] | |
| **Out of Bounds** | `axi_lt_addr_violation` | Slave should return DECERR[cite: 1] | ✅ PASS[cite: 1] | |
| **Unaligned Address** | `axi_lt_addr_unalign` | Slave should return SLVERR and hold old data[cite: 1] | ❌ **FAIL**[cite: 1] | DUT gives correct response (SLVERR) but data is corrupted to zero[cite: 1] |
| **Back to Back Write** | `axi_lt_b2b_write` | Data continuously written into the slave[cite: 1] | ✅ PASS[cite: 1] | |
| **Back to Back Read** | `axi_lt_b2b_read` | Correct data continuously read from the slave[cite: 1] | ✅ PASS[cite: 1] | |
| **Override_addr** | `axi_lt_override_addr_check`| First address considered, rest ignored[cite: 1] | ✅ PASS[cite: 1] | |
| **Override_data** | `axi_lt_override_data_check`| First data considered, rest ignored[cite: 1] | ✅ PASS[cite: 1] | |
| **Prot_signal** | `axi_lite_arprot` | Prot should not affect DUT[cite: 1] | ✅ PASS[cite: 1] | |
| **Prot_signal** | `axi_lite_awprot` | Prot should not affect DUT[cite: 1] | ✅ PASS[cite: 1] | |

## 🐛 Defect Tracking
The UVM verification environment identified three critical functional bugs within the AXI4-Lite slave RTL design, caught by the scoreboard and simulation timeout mechanisms[cite: 1].

* **BUG-1: Simulation Deadlock on Simultaneous Address/Data Assertion:** When the master asserts `AWVALID` (Write Address) and `WVALID` (Write Data) on the exact same clock edge, the slave's internal state machine fails to progress to the response phase[cite: 1]. The DUT never asserts `BVALID`, causing a complete simulation deadlock[cite: 1].
* **BUG-2: Parallel Read/Write Channel Coupling:** When the testbench issues a write request and a read request to different addresses in the RW memory region concurrently, the DUT fails to process them[cite: 1]. This indicates the slave's read and write state machines are improperly coupled or sharing a blocking resource[cite: 1].
* **BUG-3: Memory Corruption on Unaligned Address Access:** When an unaligned address is targeted by a write operation, the slave correctly detects the violation and returns the expected `SLVERR` response[cite: 1]. However, it corrupts the target memory address by overwriting it with zeroes instead of preserving existing data[cite: 1].

## 📊 Coverage Metrics
The verification environment utilizes Synopsys VCS and Verdi to extract structural, functional, and assertion coverage metrics[cite: 1]. 

### Code Coverage (88.72%)
The extended test cases drove a massive improvement in toggle activity (up from 61.68%), confirming nearly all internal memory registers and data bus nodes successfully transitioned between 0-to-1 and 1-to-0 states[cite: 1].

* **Toggle Coverage:** 99.33%[cite: 1]
* **Line Coverage:** 97.37%[cite: 1]
* **Branch Coverage:** 89.66%[cite: 1]
* **Condition Coverage:** 76.00%[cite: 1]
* **FSM Coverage:** 70.00% (Bottlenecked by BUG-1 deadlock)[cite: 1]

### Functional Coverage (100%)
The SystemVerilog UVM subscriber (`axi_lt_subscriber`) maintained 100.00% functional coverage across all 50 expected bins[cite: 1]

* **Address Ranges:** `cp_ARADDR` and `cp_AWADDR` hit 100%, targeting normal, unaligned, and out-of-bounds boundaries[cite: 1].
* **Data & Strobes:** `cp_WDATA` and `cp_WSTRB` achieved 100%[cite: 1].
* **Cross Coverage:** `cp_WDATA_WSTRB` metric reached 100% (15/15 bins)[cite: 1].

### Assertion Coverage (100%)
The assertion coverage achieved a perfect 100.00% score on the DUT protocol checks[cite: 1]. 

* The bound assertions (`p1_check`, `p2_check`, `p3_check`) logged 10,078 attempts each[cite: 1].
* Extended test sequences successfully forced the RTL into backpressure scenarios, triggering real, non-vacuous successes validating the SVA logic and handshake wait-states[cite: 1].
