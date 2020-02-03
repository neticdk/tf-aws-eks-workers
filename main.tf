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
}

data "aws_ami" "this" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

