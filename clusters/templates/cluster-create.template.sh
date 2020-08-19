#!/usr/bin/env bash
set -eux -o pipefail

gcloud beta container \
  --project "${_PROJECT}" clusters create "${_NAME}" \
  --zone ${_ZONE} \
  --release-channel regular \
  --preemptible \
  --num-nodes "${_START_NODES}" \
  --enable-autoscaling --max-nodes=${_MAX_NODES} --min-nodes=${_MIN_NODES} \
  --default-max-pods-per-node "110" \
  --machine-type "n1-standard-4" \
  --disk-type "pd-ssd" \
  --disk-size "50" \
  --image-type "COS" \
  --addons HorizontalPodAutoscaling \
  --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append","https://www.googleapis.com/auth/ndev.clouddns.readwrite" \
  --enable-autoupgrade \
  --enable-autorepair \
  --enable-ip-alias \
  --enable-stackdriver-kubernetes \
  --enable-shielded-nodes \
  --shielded-secure-boot \
  --metadata disable-legacy-endpoints=true \
  --no-enable-basic-auth \
  --no-issue-client-certificate
