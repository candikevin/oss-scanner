
export NOMOS_OUTPUT_FILE := logs/nomos.log
export NOMOS_FILTERED_FILE := logs/nomos-licenses.log
export SVN_CHECKOUT_DIR := ../repos
export SCANTOOL := /usr/share/fossology/nomos/agent/nomos
export REPORT_FILE := report.txt

# eh, let jenkins do this
# .PHONY: checkout
# checkout:
# 	cd SVN_CHECKOUT_DIR
	# svn co 

# assuming directory layout:
# (...)/workspace/repos
# (...)/workspace/oss-scanner/Makefile

help:
	@echo "make scan   - run FOSSology tool on codebase (long task!)"
	@echo "make report - create report from output of 'make scan'"
	@echo "              (does not do 'make scan' for you because it takes so long"
	@echo "make clean  - delete scan logs and report.txt"
	@echo "make clean-report - delete report.txt"


# $(REPORT_FILE):
report:
	# python main.py $(NOMOS_FILTERED_FILE)
	python main.py > $(REPORT_FILE)

# .PHONY: scan
scan:
	rm $(NOMOS_OUTPUT_FILE)
	time find $(SVN_CHECKOUT_DIR) \
	    -not -type d -not -wholename '*.svn*' -not -wholename '*.git*' \
	    -exec echo -n "{} " >> $(NOMOS_OUTPUT_FILE) \; \
	    -exec $(SCANTOOL) {} >> $(NOMOS_OUTPUT_FILE) \;

	grep -v No_license_found $(NOMOS_OUTPUT_FILE) > $(NOMOS_FILTERED_FILE)

clean-report:
	rm $(REPORT_FILE)

clean: clean-report
	rm $(NOMOS_OUTPUT_FILE)
	rm $(NOMOS_FILTERED_FILE)

