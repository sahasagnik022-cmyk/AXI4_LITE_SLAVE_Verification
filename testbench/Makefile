#=====================================================================

# VCS / UVM Regression Makefile

#=====================================================================
 

# ---- Config ---------------------------------------------------------

TESTLIST      ?= axi_lt_addr_first_test axi_lt_data_first_test axi_lt_wo_violation_test axi_lt_ro_violation_test axi_lt_addr_un_wr_test axi_lt_addr_un_rd_test axi_lt_addr_vio_wr_test axi_lt_addr_vio_rd_test axi_lt_wstrb_wr_test axi_lt_write_read_test axi_lt_write_read_test2 axi_lt_write_read_parallel_test

NUM_RUNS      ?= 10

UVM_VERBOSITY ?= UVM_MEDIUM

UVM_TIMEOUT   ?= 5000000

 

# Set to 1 to also generate an HTML report for every individual run

PER_RUN_REPORT ?= 0

 

# Standalone smoke-test coverage dir (used by vcs_sanity / vcs_error)

CM_DIR        ?= simv.vdb

 

# Compile-time coverage DB: VCS writes the design data here, and URG needs

# it as an extra -dir so the per-run (test-only) DBs have a design to load.

DESIGN_VDB    ?= simv.vdb

 

# Single-test runs (make run TEST=...): one directory per test

SINGLE_ROOT   ?= single_runs

 

# Regression layout:

#   regression_cm/runs/<test>_run<i>/simv.vdb   <- coverage DB (always named simv)

#   regression_cm/runs/<test>_run<i>/<test>_run<i>.log

#   regression_cm/merged/simv.vdb               <- merged DB (also named simv)

#   regression_cm/merged/report/dashboard.html

REGR_ROOT       ?= regression_cm

REGR_RUNS_DIR    = $(REGR_ROOT)/runs

REGR_MERGED_DIR  = $(REGR_ROOT)/merged

REGR_MERGED      = $(REGR_MERGED_DIR)/simv

REGR_REPORT      = $(REGR_MERGED_DIR)/report

 

CM_OPTS       = -cm line+cond+fsm+tgl+branch

 

.PHONY: all vcs run regression merge_regression clean clean_regression

 

all: vcs

 

# ---- Compile ----------------------------------------------------------

vcs:
	vcs -full64 -sverilog -ntb_opts uvm -licqueue \
		$(CM_OPTS) -assert svaext -lca -assert enable_diag \
		tb_top.sv -l compile.log
 

# ---- Run a single, arbitrary test on demand -----------------------------

# Usage: make run TEST=unaligned_address_test

#        make run TEST=unaligned_address_test SEED=12345

# Output: single_runs/<TEST>/simv.vdb, <TEST>.log, report/

run:
ifndef TEST
	$(error Usage: make run TEST=<test_name>  [SEED=<n>])

endif
	@rm -rf $(SINGLE_ROOT)/$(TEST)

	@mkdir -p $(SINGLE_ROOT)/$(TEST)

	./simv $(CM_OPTS) -cm_dir $(SINGLE_ROOT)/$(TEST)/simv.vdb -assert nopostproc \

		+UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(UVM_VERBOSITY) \

		+UVM_TIMEOUT=$(UVM_TIMEOUT) \

		$(if $(SEED),+ntb_random_seed=$(SEED)) \

		-l $(SINGLE_ROOT)/$(TEST)/$(TEST).log

	urg -dir $(DESIGN_VDB) $(SINGLE_ROOT)/$(TEST)/simv.vdb -report $(SINGLE_ROOT)/$(TEST)/report

	@echo ">>> Log            : $(SINGLE_ROOT)/$(TEST)/$(TEST).log"

	@echo ">>> Coverage DB    : $(SINGLE_ROOT)/$(TEST)/simv.vdb"

	@echo ">>> Coverage report: $(SINGLE_ROOT)/$(TEST)/report/dashboard.html"

 

# ---- Regression: run every test in TESTLIST, NUM_RUNS times each --------

# Every run gets its own directory containing its log and a coverage DB

# named simv.vdb. Every run that produced a DB is merged, INCLUDING runs

# that failed. Failures are still recorded in failed_runs.txt.

#   make regression TESTLIST=unaligned_address_test NUM_RUNS=20

#   make regression PER_RUN_REPORT=1      (also an HTML report per run)

regression:
	@mkdir -p $(REGR_RUNS_DIR)
	@rm -f $(REGR_ROOT)/vdb_list.txt $(REGR_ROOT)/failed_runs.txt
	@for t in $(TESTLIST); do \
		for i in $$(seq 1 $(NUM_RUNS)); do \
		run_dir=$(REGR_RUNS_DIR)/$${t}_run$${i}; \
		vdb=$$run_dir/simv.vdb; \
		log=$$run_dir/$${t}_run$${i}.log; \
		rm -rf $$run_dir; \
		mkdir -p $$run_dir; \
		echo ">>> Running $$t (run $$i/$(NUM_RUNS)) -> $$run_dir"; \
		./simv $(CM_OPTS) -cm_dir $$vdb -assert nopostproc \
		+UVM_TESTNAME=$$t +UVM_VERBOSITY=$(UVM_VERBOSITY) \
		+UVM_TIMEOUT=$(UVM_TIMEOUT) +ntb_random_seed_automatic \
		-l $$log; \
		status=$$?; \
		if grep -qE "UVM_FATAL *: *[1-9]|UVM_ERROR *: *[1-9]" $$log 2>/dev/null; then \
		status=1; \
		fi; \
		if [ $$status -ne 0 ]; then \
			echo "$$t run $$i (exit=$$status) -> $$log" >> $(REGR_ROOT)/failed_runs.txt; \
			echo "!!! $$t run $$i FAILED - see $$log (coverage still merged if a vdb exists)"; \
			fi; \
			if [ -d $$vdb ] && [ -n "$$(ls -A $$vdb 2>/dev/null)" ]; then \
				echo $$vdb >> $(REGR_ROOT)/vdb_list.txt; \
			else \
				echo "!!! $$t run $$i produced no coverage DB - nothing to merge for this run"; \
				echo "$$t run $$i (NO VDB) -> $$log" >> $(REGR_ROOT)/failed_runs.txt; \
			fi; \
			if [ "$(PER_RUN_REPORT)" = "1" ] && [ -d $$vdb ]; then \
				urg -dir $(DESIGN_VDB) $$vdb -report $$run_dir/report > /dev/null 2>&1; \
			fi; \
		done; \
	done
	@$(MAKE) merge_regression

 

# ---- Merge coverage from every run that produced a vdb ------------------

# Output: regression_cm/merged/simv.vdb + regression_cm/merged/report/

# $(DESIGN_VDB) is passed first so URG has the design loaded before the tests.

merge_regression:
	@if [ ! -s $(REGR_ROOT)/vdb_list.txt ]; then \
		echo "!!! No coverage DBs found to merge. Check per-run logs in $(REGR_RUNS_DIR)."; \
		exit 1; \
	fi
	@echo ">>> Merging coverage from $$(wc -l < $(REGR_ROOT)/vdb_list.txt) run(s) (failed runs included)..."
	@rm -rf $(REGR_MERGED_DIR)
	@mkdir -p $(REGR_MERGED_DIR)
	urg -dir $(DESIGN_VDB) $$(cat $(REGR_ROOT)/vdb_list.txt) -dbname $(REGR_MERGED) -report $(REGR_REPORT)
	@echo ">>> Merged coverage DB : $(REGR_MERGED).vdb"
	@echo ">>> Merged HTML report : $(REGR_REPORT)/dashboard.html"
	@if [ -s $(REGR_ROOT)/failed_runs.txt ]; then \
		echo ">>> NOTE: $$(wc -l < $(REGR_ROOT)/failed_runs.txt) run(s) failed - see $(REGR_ROOT)/failed_runs.txt"; \
	fi
 
# ---- Housekeeping ---------------------------------------------------------

clean_regression:
	rm -rf $(REGR_ROOT)

 

clean:
	rm -rf simv simv.daidir csrc *.log $(CM_DIR) urgReport DVEfiles ucli.key $(SINGLE_ROOT)

 
 
