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
  # encode list(string) -> JSON for the template
  kubelet_flags_json = jsonencode(var.kubelet_extra_args)

  userdata = templatefile("${path.module}/templates/userdata.tpl",
  {
    cluster_endpoint           = var.cluster_endpoint
    certificate_authority_data = var.cluster_certificate_authority_data
    cluster_name               = var.cluster_name
    bootstrap_extra_args       = var.bootstrap_extra_args
    enable_cloudwatch          = var.enable_cloudwatch
    eks_cluster_ip_range       = var.eks_cluster_ip_range
    kubelet_flags_json         = local.kubelet_flags_json
  })
}

data "aws_ami" "this" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

