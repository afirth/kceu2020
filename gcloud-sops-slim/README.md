# gcloud-sops-slim

common case image for sops in cloudbuild

see `cloudbuild.yaml` for examples of how to use

## validate

`validate` finds all secrets with `sopsenc` in the path and confirms that cloudbuild can decrypt them, without saving the output. Use it for CI checks

## decrypt

`decrypt` finds all secrets with `sopsenc` in the path and decrypts them in place. Use it just prior to calling `kubectl apply`

## prior art

https://github.com/GoogleCloudPlatform/cloud-builders-community/tree/master/gcloud-sops + bash can do the same thing, but the bash is finicky and the image is 3.8GB instead of 38MB

Creation of this repo was inspired by an incident

## use locally (only for testing, install sops for dev)

gcloud auth application-default login
docker build . -t sops-slim
docker run --rm -it -v $PWD:/workspace -v ~/.config/gcloud:/root/.config/gcloud sops-slim validate

## Create a build trigger
```
➜  ~/git/utility-images/gcloud-sops-slim (master)
gcloud beta builds triggers import --source=cloudbuild-deploy-trigger.yaml
ERROR: (gcloud.beta.builds.triggers.import) FAILED_PRECONDITION: Repository mapping does not exist. Please visit https://console.cloud.google.com/cloud-build/triggers/connect?project=redacted to connect a repository to your project
```
do that and select `Github`...

then rerun
