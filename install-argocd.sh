
ARGOCD_VERSION="v2.7.6"
MANAGED_CLUSTERS="cluster1 cluster2"

for mc in ${MANAGED_CLUSTERS}; do
echo "Installing ArgoCD in cluster: ${mc}"
curr_ctx="kind-${mc}"
kubectl create ns argocd --context ${curr_ctx}
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml -n argocd --context ${curr_ctx}
echo "============================"
done;




