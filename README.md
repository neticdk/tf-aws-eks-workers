# Netic AWS Terraform EKS Workers

## Supported Terraform Versions

Terraform 0.12

## Usage

```hcl
module "vpc" {
  source = "github.com/neticdk/tf-aws-vpc"
  [...]
}

module "eks_cluster" {
  source = "github.com/neticdk/tf-aws-eks-cluster"
  [...]
}

module "eks_workers" {
  source = "github.com/neticdk/tf-aws-eks-workers"

  name                  = "my-eks-workers"
  instance_type         = "m5.large"
  instance_profile_name = module.eks_cluster.instance_profile_name
  key_name              = "my-key-name"
  vpc_id                = module.vpc.vpd_id
  subnets               = module.vpc.private_subnets

  cluster_version                    = "1.12"
  cluster_name                       = module.eks_cluster.name
  cluster_endpoint                   = module.eks_cluster.eks_cluster_endpoint
  cluster_certificate_authority_data = module.eks_cluster.eks_cluster_certificate_authority_data
  cluster_security_group_id          = module.eks_cluster.security_group_id
}
```

<!---BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK--->
<!---END OF PRE-COMMIT-TERRAFORM DOCS HOOK--->

# Copyright
Copyright (c) 2019 Netic A/S. All rights reserved.

# License
MIT Licened. See LICENSE for full details.

