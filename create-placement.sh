cat << EOF | kubectl apply --context kind-hub -f -
apiVersion: cluster.open-cluster-management.io/v1beta1
kind: Placement
metadata:
  name: app-platform-clusters
  namespace: default
spec:
  numberOfClusters: 2
  clusterSets:
    - app-platform
EOF
