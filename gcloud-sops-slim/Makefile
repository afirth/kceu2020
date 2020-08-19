.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
SHELL = /bin/bash
.SUFFIXES:

# simplifies CI pipelines which call sops decrypt
# afirth 2020

PATH_PATTERN := *sopsenc*

.PHONY: all
	all: usage

.PHONY: usage
usage:
	@echo 'Usage:'
	@echo 'docker run ... -v $$PWD:$(CURDIR) [validate|decrypt]'
	@echo 'application default credentials must be mounted for GCP'

.PHONY: validate
validate:
	find . -type f -wholename '$(PATH_PATTERN)' | xargs -n1 -t sops -d > /dev/null

.PHONY: decrypt
decrypt:
	find . -type f -wholename '$(PATH_PATTERN)' | xargs -n1 -t sops -i -d
