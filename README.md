# multicluster-gitops
OCM + ArgoCD based multicluster deployments

## Steps To Run this script

### Create a local kind cluster based setup 
```
create-multicluster-kind.sh
```

### Create a clusterset and bind it to a namespace
This step would create a clusterset called `app-platform` and binds it with namespace default
```
create-multicluster-kind.sh
```

### Create a Placement

```
create-placement.sh
```

