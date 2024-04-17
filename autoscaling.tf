/*
 * Copyright (c) 2019 Netic A/S. All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

resource "aws_autoscaling_group" "this" {
  name_prefix      = "eks-workers-${var.name}-"
  max_size         = var.max_size
  min_size         = var.min_size
  default_cooldown = var.default_cooldown

  mixed_instances_policy {
    instances_distribution {
      on_demand_allocation_strategy            = var.on_demand_allocation_strategy
      on_demand_base_capacity                  = var.on_demand_base_capacity
      on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
      spot_allocation_strategy                 = var.spot_allocation_strategy
      spot_instance_pools                      = var.spot_instance_pools
      spot_max_price                           = var.spot_max_price
    }

    launch_template {
      launch_template_specification {
        launch_template_id = join("", aws_launch_template.this[*].id)
        version            = "$Latest"
      }

      override {
        instance_type = var.instance_type
      }

      override {
        instance_type = var.override_instance_type
      }
    }
  }

  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete              = var.force_delete
  load_balancers            = var.load_balancers
  vpc_zone_identifier       = var.subnets
  target_group_arns         = var.target_group_arns
  termination_policies      = var.termination_policies
  suspended_processes       = var.suspended_processes
  placement_group           = var.placement_group
  metrics_granularity       = var.metrics_granularity
  enabled_metrics           = var.enabled_metrics
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  min_elb_capacity          = var.min_elb_capacity
  wait_for_elb_capacity     = var.wait_for_elb_capacity
  protect_from_scale_in     = var.protect_from_scale_in
  service_linked_role_arn   = var.service_linked_role_arn

  dynamic "tag" {
    for_each = local.eks_tags
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true

    ignore_changes = [desired_capacity]
  }
}

resource "aws_launch_template" "this" {
  name_prefix = "eks-workers-${var.name}-"

  block_device_mappings {
    device_name = data.aws_ami.this.root_device_name

    ebs {
      encrypted   = var.ebs_encrypted
      kms_key_id  = var.ebs_kms_key_id
      volume_size = var.ebs_root_volume_size

      volume_type           = var.ebs_root_volume_type
      iops                  = var.ebs_root_iops
      delete_on_termination = true
    }
  }

  dynamic "credit_specification" {
    for_each = var.credit_specification
    content {
      cpu_credits = credit_specification.cpu_credits
    }
  }

  disable_api_termination = var.disable_api_termination
  ebs_optimized           = var.ebs_optimized

  dynamic "elastic_gpu_specifications" {
    for_each = var.elastic_gpu_specifications
    content {
      type = elastic_gpu_specifications.type
    }
  }

  iam_instance_profile {
    name = var.instance_profile_name
  }

  image_id = local.ami_id

  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior

  dynamic "instance_market_options" {
    for_each = var.instance_market_options
    content {
      market_type = instance_market_options.market_type
    }
  }

  instance_type = var.instance_type
  kernel_id     = var.kernel_id
  key_name      = var.key_name

  monitoring {
    enabled = var.enable_monitoring
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = [join("", aws_security_group.this[*].id)]
    delete_on_termination       = true
  }

  placement {
    tenancy = var.placement_tenancy
  }

  user_data = base64encode(local.userdata)

  tags = merge(
    {
      "Name" = "eks-workers-${var.name}"
    },
    var.tags,
    local.tags,
  )

  lifecycle {
    create_before_destroy = true
  }
}
