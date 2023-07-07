#!/bin/bash

CLUSTERADM_CLIENT_VERSION=${1:-"v0.6.0"}
TARGET_PATH=${2:-/usr/local/bin}

OS=$(uname -o | cut -f2 -d/ | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)
TAR_FILE=${TMPDIR:-"/tmp"}/clusteradm.tar.gz

wget https://github.com/open-cluster-management-io/clusteradm/releases/download/${CLUSTERADM_CLIENT_VERSION}/clusteradm_${OS}_${ARCH}.tar.gz -O ${TAR_FILE}
if [ -f "${TAR_FILE}" ]; then
 tar zxf /tmp/clusteradm.tar.gz --directory ${TARGET_PATH} clusteradm
fi
rm -rf ${TAR_FILE}
