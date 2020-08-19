.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
SHELL = /bin/bash
.SUFFIXES:

# this makefile just fills in some shell scripts with placeholder variables and saves them
# you could use terraform or whatever instead
# @afirth 2019

ifndef CLUSTER
$(error CLUSTER is not set. make CLUSTER=<cluster_name>)
endif

# this file contains the vars to sub into the templates
VARS_FILE := ../$(CLUSTER).env
OUT_DIR := ../generated/setup_scripts/$(CLUSTER)/

# files in CWD ending in in_suffix will be templated
IN_SUFFIX := .template.sh
OUT_SUFFIX := .sh

IN_FILES := $(wildcard *$(IN_SUFFIX))
OUT_FILES := $(patsubst %$(IN_SUFFIX), $(OUT_DIR)/%$(OUT_SUFFIX), $(IN_FILES))

# make vars available to envsubst
include $(VARS_FILE)
export

.PHONY: all
all: $(OUT_FILES)

#only variables prefixed with _ and exported will be replaced
$(OUT_FILES): $(OUT_DIR)/%$(OUT_SUFFIX): %$(IN_SUFFIX) $(VARS_FILE)
	@mkdir -p $(@D)
	envsubst "$$(printf '$${%s} ' $${!_*})" < $< > $@
	chmod +x $@
