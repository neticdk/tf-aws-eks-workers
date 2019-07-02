/*
 * Copyright (c) 2019 Netic A/S. All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

resource "aws_security_group" "this" {
  name        = "eks-workers-${var.name}"
  description = "Security Group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name"                                      = "eks-workers-${var.name}"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
    var.tags,
    local.tags,
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "egress" {
  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.this.*.id)
  type              = "egress"
}

resource "aws_security_group_rule" "ingress_self" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = join("", aws_security_group.this.*.id)
  source_security_group_id = join("", aws_security_group.this.*.id)
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_cluster" {
  description              = "Allow worker kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = join("", aws_security_group.this.*.id)
  source_security_group_id = var.cluster_security_group_id
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster_https" {
  description              = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane."
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  security_group_id        = join("", aws_security_group.this.*.id)
  source_security_group_id = var.cluster_security_group_id
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = var.allowed_security_groups_count
  description              = "Allow inbound traffic from existing Security Groups"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = join("", aws_security_group.this.*.id)
  source_security_group_id = element(var.allowed_security_groups, count.index)
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.this.*.id)
  type              = "ingress"
}
