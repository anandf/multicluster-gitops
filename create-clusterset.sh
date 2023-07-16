clusteradm create clusterset app-platform --context kind-hub
clusteradm clusterset set app-platform --clusters=cluster1,cluster2 --context kind-hub

clusteradm clusterset bind app-platform --namespace default --context kind-hub
