/*
 * Copyright (c) 2019 Netic A/S. All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

output "security_group_id" {
  description = "ID of security group for the workers"
  value       = aws_security_group.this.id
}

