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
  cluster_name                       = "my-eks-cluster"
  cluster_endpoint                   = module.eks_cluster.eks_cluster_endpoint
  cluster_certificate_authority_data = module.eks_cluster.eks_cluster_certificate_authority_data
  cluster_security_group_id          = module.eks_cluster.security_group_id
}
```

<!---BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK--->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed\_cidr\_blocks | List of CIDR blocks allowed to allow traffic from | list | `<list>` | no |
| allowed\_security\_groups | List of additoinal security group ids allowed to allow traffic from | list | `<list>` | no |
| allowed\_security\_groups\_count | Count of allowed security groups | string | `"0"` | no |
| associate\_public\_ip\_address | Associate a public IP address with an instance in a VPC | string | `"false"` | no |
| autoscaling\_enabled | Sets whether policy and matching tags will be added to allow autoscaling. | string | `"false"` | no |
| bootstrap\_extra\_args | Extra arguments passed to the bootstrap.sh. | string | `""` | no |
| cluster\_certificate\_authority\_data | The base64 encoded certificate data required to communicate with the cluster | string | n/a | yes |
| cluster\_endpoint | EKS cluster endpoint | string | n/a | yes |
| cluster\_name | EKS Cluster Name | string | n/a | yes |
| cluster\_security\_group\_id | Security group ID of the EKS Cluster | string | n/a | yes |
| cluster\_version | Cluster Version | string | n/a | yes |
| credit\_specification | Customize the credit specification of the instances | list | `<list>` | no |
| default\_cooldown | The amount of time, in seconds, after a scaling activity completes before another scaling activity can start | string | `"300"` | no |
| desired\_capacity | The desired size of the autoscale group | string | `"1"` | no |
| disable\_api\_termination | If `true`, enables EC2 Instance Termination Protection | string | `"false"` | no |
| ebs\_encrypted | Enables EBS encryption on the volume | string | `"false"` | no |
| ebs\_kms\_key\_id | AWS Key Management Service (AWS KMS) customer master key (CMK) to use when creating the encrypted volume | string | `"null"` | no |
| ebs\_optimized | If true, the launched EC2 instance will be EBS-optimized | string | `"false"` | no |
| ebs\_root\_iops | The amount of provisioned IOPS | string | `"0"` | no |
| ebs\_root\_volume\_size | The size of the volume in gigabytes | string | `"100"` | no |
| ebs\_root\_volume\_type | The type of volume | string | `"gp2"` | no |
| elastic\_gpu\_specifications | Specifications of Elastic GPU to attach to the instances | list | `<list>` | no |
| enable\_monitoring | Enable/disable detailed monitoring | string | `"true"` | no |
| enabled\_metrics | A list of metrics to collect. The allowed values are `GroupMinSize`, `GroupMaxSize`, `GroupDesiredCapacity`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupTerminatingInstances`, `GroupTotalInstances` | list | `<list>` | no |
| enabled\_cloudwatch | Enable/disable installation of CloudWatch Agent | string | `false` | no |
| force\_delete | Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling | string | `"false"` | no |
| health\_check\_grace\_period | Time (in seconds) after instance comes into service before checking health | string | `"300"` | no |
| health\_check\_type | Controls how health checking is done. Valid values are `EC2` or `ELB` | string | `"EC2"` | no |
| instance\_initiated\_shutdown\_behavior | Shutdown behavior for the instances. Can be `stop` or `terminate` | string | `"terminate"` | no |
| instance\_market\_options | The market (purchasing) option for the instances | list | `<list>` | no |
| instance\_profile\_name | Name of the instance profile to use with the launch template | string | n/a | yes |
| instance\_type | Instance type to launch | string | `"m5.large"` | no |
| kernel\_id | The kernel ID | string | `""` | no |
| key\_name | SSH key name that should be used for the instance | string | `""` | no |
| kubelet\_extra\_args | Passed to the bootstrap.sh script to enable --kublet-extra-args or --use-max-pods. | string | `""` | no |
| load\_balancers | A list of elastic load balancer names to add to the autoscaling group names. Only valid for classic load balancers. For ALBs, use `target_group_arns` instead | list | `<list>` | no |
| max\_size | The maximum size of the autoscale group | string | `"1"` | no |
| metrics\_granularity | The granularity to associate with the metrics to collect. The only valid value is 1Minute | string | `"1Minute"` | no |
| min\_elb\_capacity | Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes | string | `"0"` | no |
| min\_size | The minimum size of the autoscale group | string | `"1"` | no |
| name | Name to use for creating resources | string | n/a | yes |
| on\_demand\_allocation\_strategy | Strategy to use when launching on-demand instances. | string | `"prioritized"` | no |
| on\_demand\_base\_capacity | Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances | string | `"0"` | no |
| on\_demand\_percentage\_above\_base\_capacity | Percentage split between on-demand and Spot instances above the base on-demand capacity | string | `"100"` | no |
| override\_instance\_type | Instance type to launch | string | `"t3.large"` | no |
| placement\_group | The name of the placement group into which you'll launch your instances, if any | string | `""` | no |
| placement\_tenancy | The tenancy of the instance (if the instance is running in a VPC). | string | `"default"` | no |
| protect\_from\_scale\_in | Allows setting instance protection. The autoscaling group will not select instances with this setting for terminination during scale in events | string | `"false"` | no |
| service\_linked\_role\_arn | The ARN of the service-linked role that the ASG will use to call other AWS services | string | `""` | no |
| spot\_allocation\_strategy | How to allocate capacity across the Spot pools | string | `"lowest-price"` | no |
| spot\_instance\_pools | Number of Spot pools per availability zone to allocate capacity. EC2 Auto Scaling selects the cheapest Spot pools and evenly allocates Spot capacity across the number of Spot pools that you specify | string | `"10"` | no |
| spot\_max\_price | Maximum price per unit hour that the user is willing to pay for the Spot instances | string | `""` | no |
| subnets | List of subnets to launch the cluster in | list(string) | n/a | yes |
| suspended\_processes | A list of processes to suspend for the AutoScaling Group. The allowed values are `Launch`, `Terminate`, `HealthCheck`, `ReplaceUnhealthy`, `AZRebalance`, `AlarmNotification`, `ScheduledActions`, `AddToLoadBalancer`. Note that if you suspend either the `Launch` or `Terminate` process types, it can prevent your autoscaling group from functioning properly. | list | `<list>` | no |
| tags | A map of tags to add to all resources | map | `<map>` | no |
| target\_group\_arns | A list of aws_alb_target_group ARNs, for use with Application Load Balancing | list | `<list>` | no |
| termination\_policies | A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `Default` | list | `<list>` | no |
| vpc\_id | VPC ID | string | n/a | yes |
| wait\_for\_capacity\_timeout | A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to '0' causes Terraform to skip all Capacity Waiting behavior | string | `"10m"` | no |
| wait\_for\_elb\_capacity | Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over `min_elb_capacity` behavior | string | `"0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| security\_group\_id |  |

<!---END OF PRE-COMMIT-TERRAFORM DOCS HOOK--->

# Copyright
Copyright (c) 2019 Netic A/S. All rights reserved.

# License
MIT Licened. See LICENSE for full details.

