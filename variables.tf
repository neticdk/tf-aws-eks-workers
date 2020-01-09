/*
 * Copyright (c) 2019 Netic A/S. All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "name" {
  description = "Name to use for creating resources"
}

// Cluster
variable "cluster_name" {
  description = "EKS Cluster Name"
}

variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
}

variable "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data required to communicate with the cluster"
}

variable "cluster_version" {
  description = "Cluster Version"
}

// Userdata
variable "kubelet_extra_args" {
  description = "Passed to the bootstrap.sh script to enable --kublet-extra-args or --use-max-pods."
  default     = ""
}

variable "bootstrap_extra_args" {
  description = "Extra arguments passed to the bootstrap.sh."
  default     = ""
}

// VPC
variable "vpc_id" {
  description = "VPC ID"
}

variable "subnets" {
  description = "List of subnets to launch the cluster in"
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "Security group ID of the EKS Cluster"
}

variable "allowed_security_groups" {
  description = "List of additoinal security group ids allowed to allow traffic from"
  default     = []
}

variable "allowed_security_groups_count" {
  description = "Count of allowed security groups"
  default     = 0
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to allow traffic from"
  default     = []
}

// Common
variable "instance_type" {
  description = "Instance type to launch"
  default     = "m5.large"
}

variable "override_instance_type" {
  description = "Instance type to launch"
  default     = "t3.large"
}

// Launch Template
variable "ebs_root_volume_size" {
  description = "The size of the volume in gigabytes"
  default     = "100"
}

variable "ebs_root_volume_type" {
  description = "The type of volume"
  default     = "gp2"
}

variable "ebs_root_iops" {
  description = "The amount of provisioned IOPS"
  default     = "0"
}

variable "ebs_encrypted" {
  description = "Enables EBS encryption on the volume"
  default     = false
}

variable "ebs_kms_key_id" {
  description = "AWS Key Management Service (AWS KMS) customer master key (CMK) to use when creating the encrypted volume"
  type        = string
  default     = null
}

variable "credit_specification" {
  description = "Customize the credit specification of the instances"
  default     = []
}

variable "disable_api_termination" {
  description = "If `true`, enables EC2 Instance Termination Protection"
  default     = false
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  default     = false
}

variable "elastic_gpu_specifications" {
  description = "Specifications of Elastic GPU to attach to the instances"
  default     = []
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instances. Can be `stop` or `terminate`"
  default     = "terminate"
}

variable "instance_market_options" {
  description = "The market (purchasing) option for the instances"
  default     = []
}

variable "kernel_id" {
  description = "The kernel ID"
  default     = ""
}

variable "key_name" {
  description = "SSH key name that should be used for the instance"
  default     = ""
}

variable "enable_monitoring" {
  description = "Enable/disable detailed monitoring"
  default     = true
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with an instance in a VPC"
  default     = false
}

variable "placement_tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC)."
  default     = "default"
}

variable "instance_profile_name" {
  description = "Name of the instance profile to use with the launch template"
}

// Autoscaling Group
variable "max_size" {
  description = "The maximum size of the autoscale group"
  default     = 1
}

variable "min_size" {
  description = "The minimum size of the autoscale group"
  default     = 1
}

variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  default     = 300
}

variable "desired_capacity" {
  description = "The desired size of the autoscale group"
  default     = 1
}

variable "force_delete" {
  description = "Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
  default     = false
}

variable "target_group_arns" {
  description = "A list of aws_alb_target_group ARNs, for use with Application Load Balancing"
  default     = []
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `Default`"
  default     = ["Default"]
}

variable "suspended_processes" {
  description = "A list of processes to suspend for the AutoScaling Group. The allowed values are `Launch`, `Terminate`, `HealthCheck`, `ReplaceUnhealthy`, `AZRebalance`, `AlarmNotification`, `ScheduledActions`, `AddToLoadBalancer`. Note that if you suspend either the `Launch` or `Terminate` process types, it can prevent your autoscaling group from functioning properly."
  default     = []
}

variable "placement_group" {
  description = "The name of the placement group into which you'll launch your instances, if any"
  default     = ""
}

variable "metrics_granularity" {
  description = "The granularity to associate with the metrics to collect. The only valid value is 1Minute"
  default     = "1Minute"
}

variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are `GroupMinSize`, `GroupMaxSize`, `GroupDesiredCapacity`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupTerminatingInstances`, `GroupTotalInstances`"

  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  default     = 300
}

variable "health_check_type" {
  description = "Controls how health checking is done. Valid values are `EC2` or `ELB`"
  default     = "EC2"
}

variable "load_balancers" {
  description = "A list of elastic load balancer names to add to the autoscaling group names. Only valid for classic load balancers. For ALBs, use `target_group_arns` instead"
  default     = []
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to '0' causes Terraform to skip all Capacity Waiting behavior"
  default     = "10m"
}

variable "min_elb_capacity" {
  description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
  default     = 0
}

variable "wait_for_elb_capacity" {
  description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over `min_elb_capacity` behavior"
  default     = 0
}

variable "protect_from_scale_in" {
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for terminination during scale in events"
  default     = false
}

variable "service_linked_role_arn" {
  description = "The ARN of the service-linked role that the ASG will use to call other AWS services"
  default     = ""
}

variable "autoscaling_enabled" {
  description = "Sets whether policy and matching tags will be added to allow autoscaling."
  default     = false
}

// Autoscaling Group - Instance Distribution
variable "on_demand_allocation_strategy" {
  description = "Strategy to use when launching on-demand instances."
  default     = "prioritized"
}

variable "on_demand_base_capacity" {
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances"
  default     = "0"
}

variable "on_demand_percentage_above_base_capacity" {
  description = "Percentage split between on-demand and Spot instances above the base on-demand capacity"
  default     = "100"
}

variable "spot_allocation_strategy" {
  description = "How to allocate capacity across the Spot pools"
  default     = "lowest-price"
}

variable "spot_instance_pools" {
  description = "Number of Spot pools per availability zone to allocate capacity. EC2 Auto Scaling selects the cheapest Spot pools and evenly allocates Spot capacity across the number of Spot pools that you specify"
  default     = 10
}

variable "spot_max_price" {
  description = "Maximum price per unit hour that the user is willing to pay for the Spot instances"
  default     = ""
}

variable "enable_cloudwatch" {
  description = "Enable CloudWatch Agent installation"
  default     = false
}

