CLUSTERS="hub cluster1 cluster2"
for cluster in ${CLUSTERS};do
  kind delete cluster --name ${cluster}
done;
