## Clusters

Included for reproducibility are cluster creation scripts for GKE. These scripts create two basic clusters named bravo and delta, add a node pool, and grant cloudbuild permissions.

1. Run make (with GNU make you heathens) in `/templates` for each cluster
```bash
$ make -C templates CLUSTER=gke_afirth-kceu2020_europe-west1-d_bravo
$ make -C templates CLUSTER=gke_afirth-kceu2020_europe-west1-d_delta
```

2. Commit and run the generated scripts
```bash
$ ./generated/setup_scripts/gke_afirth-kceu2020_europe-west1-d_bravo/cluster-create.sh
# wait some minutes or background it and move on
$ ./generated/setup_scripts/gke_afirth-kceu2020_europe-west1-d_delta/cluster-create.sh
# wait until both are created before applying permissions

$ ./generated/setup_scripts/gke_afirth-kceu2020_europe-west1-d_bravo/cluster-permissions.sh
$ ./generated/setup_scripts/gke_afirth-kceu2020_europe-west1-d_delta/cluster-permissions.sh
```

It's like infra as code, only worse
