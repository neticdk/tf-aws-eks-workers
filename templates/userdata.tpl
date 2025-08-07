#!/bin/bash
set -o xtrace

# upgrade 
dnf upgrade -y

dnf install amazon-cloudwatch-agent -y

# config Cloudwatch Agent
dnf install amazon-cloudwatch-agent -y
mkdir -p /opt/aws/amazon-cloudwatch-agent/etc
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
/usr/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
fi

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
    "kubelet": {
      "flags": ${kubelet_flags_json}
    }
  }
}
EOF

# Initializes of the worker node
/usr/bin/nodeadm init --config-source file:/root/nodeadm.json
