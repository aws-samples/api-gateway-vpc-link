data "aws_caller_identity" "current" {}

data "aws_iam_policy" "managed_policy" {
  for_each = toset(var.managed_policy_arns)
  name     = each.value
}

locals {
  inline_policy_map = { for index, policy in var.inline_policy : index => policy }
}

resource "aws_iam_role" "role" {
  name = "${var.environment}-${var.role_name}"

  assume_role_policy    = file("../${var.assume_role_policy_file}")
  description           = var.description
  force_detach_policies = var.force_detach_policies
  managed_policy_arns   = length(var.managed_policy_arns) > 0 ? try(data.aws_iam_policy.managed_policy[*].arn, null) : null
  max_session_duration  = var.max_session_duration
  path                  = var.role_path
  permissions_boundary  = var.permissions_boundary

  dynamic "inline_policy" {
    for_each = local.inline_policy_map
    content {
      name   = inline_policy.value.name
      policy = file("../${inline_policy.value.file_path}")
    }
  }
}

resource "aws_iam_policy" "policy" {
  count       = var.enable_self_managed_policy ? 1 : 0
  name        = "${var.policy_name}-${var.environment}"
  path        = var.role_path
  description = var.policy_description

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = var.self_managed_policy_statements
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy[0].arn
}