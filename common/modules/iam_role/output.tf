output "role_arn" {
  value = aws_iam_role.role.arn
}

output "role_id" {
  value = aws_iam_role.role.id
}

output "role_create_date" {
  value = aws_iam_role.role.create_date
}

output "role_path" {
  value = aws_iam_role.role.path
}

output "role_unique_id" {
  value = aws_iam_role.role.unique_id
}

output "policy_arn" {
  value = aws_iam_policy.policy[*].arn
}

output "policy_path" {
  value = aws_iam_policy.policy[*].path
}

output "policy_id" {
  value = aws_iam_policy.policy[*].id
}
