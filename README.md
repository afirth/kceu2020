## About this repo

Contains [slides](SLIDES_ingress_on_the_rails.pdf) and some demo code for the Kubecon EU 2020 talk ("Ingress on the Rails"](https://kccnceu20.sched.com/event/ea4d05e0e543c633f29c00148a20ea5f)

The demo code sets up external-dns using the deployment pattern described in the talk, of calling `helm template | kustomize | kubectl apply` to support multiple K8s clusters. Similar tools are emerging like [helm post-rendering](https://helm.sh/docs/topics/advanced/#post-rendering) and [Ship](https://github.com/replicatedhq/ship)

If there is demand for more samples, please open an issue with which components would be most useful -- sample helm-values and patches can be found in the slides and will likely be specific to your environment anyway.

## Using this code

Hopefully everything works as is on GKE except you need to change the project ID - replace all instances of afirth-kceu2020 with your project ID. Helm 2, sops, and GNU make are required for code generation.

### Images

For CD to work you need the images available:

- for gcloud-sops-slim the Dockerfile is in this repo
- for kustomize clone and submit [the community image](https://github.com/GoogleCloudPlatform/cloud-builders-community/tree/master/kustomize#building-this-builder)

see the `cloudbuild.yamls` for info

### KMS

for sops to work with gcp kms, you need to create a KMS key (in this case called sops). operators will use this key to encrypt and decrypt secrets, and cloudbuild will use it to decrypt during CD.

First, enable both cloudbuild and kms APIs at https://console.cloud.google.com/apis/library if you haven't already
Then create a keyring, key, and rolebinding

```
PROJECT_ID=afirth-kceu2020 #IMPORTANT! replace
PROJECT_NUM="$(gcloud projects describe ${PROJECT_ID} --format='get(projectNumber)')"
gcloud kms keyrings create cloudbuild --location=global --project=${PROJECT_ID}
gcloud kms keys create sops --keyring=cloudbuild --location=global --purpose=encryption --next-rotation-time=30d --rotation-period=30d --project=${PROJECT_ID}
SERVICE_ACCOUNT="${PROJECT_NUM}@cloudbuild.gserviceaccount.com"
gcloud kms keys add-iam-policy-binding sops --keyring='cloudbuild' --location='global' --member=serviceAccount:${SERVICE_ACCOUNT} --role='roles/cloudkms.cryptoKeyDecrypter' --project=${PROJECT_ID}
```

## Cloudbuild triggers

Triggers and pipelines are included for CI and CD of both the deployment to clusters and the sops image. The sops readme has some more info if you're just getting started with cloud-build. Other docker-image based pipeline tools should be easily adapatable.

## Extending this code
We manage each component (external-dns, cert-manager, prometheus-operator, oauth2-proxy, and ingress-nginx) as its own repository. This has the disadvantage of duplicating a lot of the generator and pipeline code, and requiring lots of updates to add another cluster, but the advantage of breaking one thing at a time.

## Clusters

`./clusters` has some scripts to make some GKE clusters if you want to demo this as is.
