#!/usr/bin/env bash
set -eux -o pipefail

# Execute once per cluster
# grants RBAC write to cloudbuild

# by default cloudbuild doesn't have access to modify RBAC. We must trade of the security of granting that access vs the security of delegating it to people. At least if cloudbuild does it we have an audit trail.

# add project-wide IAM policy for cloudbuild cluster administration
PROJECT_ID="$(gcloud projects describe afirth-kceu2020 --format='get(projectNumber)')"
SERVICE_ACCOUNT="${PROJECT_ID}@cloudbuild.gserviceaccount.com"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=serviceAccount:${SERVICE_ACCOUNT} \
    --role=roles/container.admin

# cluster specific
gcloud container clusters get-credentials delta --zone europe-west1-d --project afirth-kceu2020

# and bind the role for creating RBAC roles
kubectl get clusterrolebinding cluster-admin-cloudbuild-binding -o jsonpath='{.subjects[*].name}' | grep $SERVICE_ACCOUNT || \
  kubectl create clusterrolebinding cluster-admin-cloudbuild-binding \
    --clusterrole cluster-admin --user $SERVICE_ACCOUNT
