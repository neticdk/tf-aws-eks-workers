#!/bin/bash
set -o xtrace

# Install CloudWatch Agent
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

# enable swapfile
fallocate -l 2G /.swapfile
chmod 600 /.swapfile
mkswap /.swapfile
swapon /.swapfile
echo '/.swapfile none swap sw 0 0' | tee -a /etc/fstab

# Start CloudWatch Agent
/usr/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

# Initialize nodeadm.yaml
tee /root/nodeadm.yaml > /dev/null <<EOF
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: "${cluster_name}"
    apiServerEndpoint: "${cluster_endpoint}"
    certificateAuthority: "${certificate_authority_data}"
    cidr: "${eks_cluster_ip_range}"
  kubelet:
    flags:
%{ for f in kubelet_extra_args ~}
      - ${f}
%{ endfor ~}
EOF

# Run nodeadm init
/usr/bin/nodeadm init --config-source file:/root/nodeadm.yaml