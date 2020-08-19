## About this repo

Contains slides and some demo code for the Kubecon EU 2020 talk "Ingress on the Rails"

The demo code sets up external-dns using the deployment pattern described in the talk, of calling `helm template | kustomize | kubectl apply` to support multiple K8s clusters. Similar tools are emerging like [helm post-rendering](https://helm.sh/docs/topics/advanced/#post-rendering) and [Ship](https://github.com/replicatedhq/ship)

## Using this code

Hopefully everything works as is on GKE except you need to change the project ID - replace all instances of afirth-kceu2020 with your project ID. Helm 2, sops, and GNU make are required for code generation.

## Clusters

`./clusters` has some scripts to make some GKE clusters if you want to demo this as is.

#TODO
-add sops image
-add triggers + info
-add diffing CI
-add CD
-add external-dns
-add sample ingress
