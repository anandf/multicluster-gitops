cat << EOF | kubectl apply --context kind-hub -f -
apiVersion: cluster.open-cluster-management.io/v1beta1
kind: Placement
metadata:
  name: demo-clusters
  namespace: default
spec:
  numberOfClusters: 2
  clusterSets:
    - default
EOF
