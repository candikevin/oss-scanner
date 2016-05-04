
export NOMOS_OUTPUT_FILE := /tmp/nomos.log
export NOMOS_FILTERED_FILE := /tmp/nomos-licenses.log
export SVN_CHECKOUT_DIR := ./repos
export SCANTOOL := /usr/share/fossology/nomos/agent/nomos

# eh, let jenkins do this
# .PHONY: checkout
# checkout:
# 	cd SVN_CHECKOUT_DIR
	# svn co 

# assuming directory layout:
# (...)/workspace/repos
# (...)/workspace/oss-scanner/Makefile

.PHONY: scan
scan:
	echo "GPL" > $(NOMOS_OUTPUT_FILE)
	echo "No_license_found" >> $(NOMOS_FILTERED_FILE)

	# time find . -not -type d -not -wholename '*.svn*' -not -wholename '*.git*' \
	#     -exec echo -n "{} " >> $(NOMOS_OUTPUT_FILE) \; \
	#     -exec $(SCANTOOL) {} >> $(NOMOS_OUTPUT_FILE) \;
	grep -v No_license_found $(NOMOS_OUTPUT_FILE) > $(NOMOS_FILTERED_FILE)

.PHONY: report
report: scan
	@echo "make report depends on scan"


