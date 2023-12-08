variable "sqs_api_role_name" {
  description = "Role name for API GW for SQS"
  type = string
}

variable "aws_sqs_queue_arn" {
  description = "ARN of the SQS Queue"
  type = string

}