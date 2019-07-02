#!/bin/bash
set -o xtrace

/etc/eks/bootstrap.sh --apiserver-endpoint '${cluster_endpoint}' --b64-cluster-ca '${certificate_authority_data}' ${bootstrap_extra_args} --kubelet-extra-args '${kubelet_extra_args}' '${cluster_name}'
