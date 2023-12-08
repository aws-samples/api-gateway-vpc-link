output "table_arn" {
  description = "The ARN (Amazon Resource Name) of the DynamoDB table."
  value       = aws_dynamodb_table.dynamodb_table.arn
}

output "table_name" {
  description = "The name of the DynamoDB table."
  value       = aws_dynamodb_table.dynamodb_table.id
}