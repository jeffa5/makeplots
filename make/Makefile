DATA_DIR = data
SCRIPTS_DIR = scripts
PLOTS_DIR = plots

.PHONY: clean
clean:
	rm -rf $(DATA_DIR)
	rm -rf $(PLOTS_DIR)

$(DATA_DIR):
	mkdir -p $@

$(PLOTS_DIR):
	mkdir -p $@

$(DATA_DIR)/all.csv: $(SCRIPTS_DIR)/all.py $(wildcard results/*) $(wildcard results/*/results*.csv) $(wildcard results/*/configuration.json) | $(DATA_DIR)
	python3 $(SCRIPTS_DIR)/all.py $(wildcard results/*) $@

$(DATA_DIR)/%.csv: $(SCRIPTS_DIR)/%.data.py $(DATA_DIR)/all.csv
	python3 $< $(DATA_DIR)/all.csv $@

$(PLOTS_DIR)/%.png: $(SCRIPTS_DIR)/%.plot.py $(SCRIPTS_DIR)/utils.py $(DATA_DIR)/%.csv | $(PLOTS_DIR)
	python3 $< $(DATA_DIR)/$*.csv $@

.PHONY: all-plots
all-plots: $(PLOTS_DIR)/*.png

.NOTINTERMEDIATE:
