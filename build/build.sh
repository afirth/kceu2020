#!/usr/bin/env bash
set -eux -o pipefail

# do not run this directly, run make from the root instead

for cluster in "$@"
do
  echo building "$cluster"
  mkdir -p $(dirname ./generated/${cluster})
  kustomize build --load_restrictor=none ./deploy/${cluster} > ./generated/${cluster}.yaml
done
