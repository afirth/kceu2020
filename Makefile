.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
SHELL = /bin/bash
.SUFFIXES:

# generates cluster-specific manifests
# @afirth 2020

CLUSTERS := \
	afirth-kceu2020/bravo \
	afirth-kceu2020/delta

.PHONY: all
all: clean generate

# use bash so we can call it easily from cloudbuild too
.PHONY: generate
generate:
	$(MAKE) -C bases/external-dns-cloudflare
	./build/build.sh $(CLUSTERS)

.PHONY: clean
clean:
	rm -rf ./generated
