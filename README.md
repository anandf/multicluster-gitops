# multicluster-gitops
OCM + ArgoCD based multicluster deployments

## Steps To Run this script

### Create a local kind cluster based setup 
```
create-multicluster-kind.sh
```

### Create a clusterset and bind it to a namespace
This step would create a clusterset called `app-platform-clusters` and binds it with the namespace `default`
```
create-multicluster-kind.sh
```

### Create a Placement

```
create-placement.sh
```

### Install ArgoCD 
Run the below script to install ArgoCD in managed cluster set `app-platform-clusters`
```
create-mwr-argocd.sh
```

### Install OAM platform in the clusters 
Run the below script to install OAM platform in managed cluster set `app-platform-clusters`
```
create-mwr-app-platform.sh
```
