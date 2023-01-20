/*
 * Copyright (c) 2019 Netic A/S. All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

locals {
  ami_id = var.ami_id == "" ? data.aws_ami.this.id : var.ami_id

  tags = {
    Terraform = "true"
  }

  all_tags = merge(var.tags, local.tags)

  eks_tags = merge(
    local.all_tags,
    {
      "Name" = "eks-workers-${var.cluster_name}"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
    var.autoscaling_enabled ? {
      "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"             = "true"
    } : {},
  )
}

data "aws_ami" "this" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

