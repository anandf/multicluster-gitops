
ARGOCD_VERSION="v2.7.6"
MANAGED_CLUSTERS="cluster1 cluster2"

for mc in ${MANAGED_CLUSTERS}; do
echo "Uninstalling ArgoCD from cluster: ${mc}"
curr_ctx="kind-${mc}"
kubectl delete -f https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml -n argocd --context ${curr_ctx} 
kubectl delete ns argocd
echo "============================"
done;




