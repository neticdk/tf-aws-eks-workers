#!/bin/bash
set -o xtrace

# Initializes nodeadm.json
tee /root/nodeadm.json > /dev/null <<EOF
{
  "apiVersion": "node.eks.aws/v1alpha1",
  "kind": "NodeConfig",
  "spec": {
    "cluster": {
      "name": "${cluster_name}",
      "apiServerEndpoint": "${cluster_endpoint}",
      "certificateAuthority": "${certificate_authority_data}",
      "cidr": "${vpc_cidr}"
    },
    "kubeletExtraArgs": "${kubelet_extra_args}"
  }
}
EOF

# Initializes of the worker node
/usr/bin/nodeadm init --config-source file:/tmp/nodeadm.json

# config Cloudwatch Agent
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOF
{
  "metrics": {
    "metrics_collected": {
      "disk": {
        "resources": [
          "/"
        ],
        "measurement": [
          "used_percent"
        ]
      }
    }
  }
}
EOF
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
fi
