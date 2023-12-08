variable "environment" {
  description = "The environment (lowercase)"
  type        = string
  default     = "dev"
}

variable "app" {
  description = "The name of the app"
  type        = string
}

variable "queue_name" {
  description = "Name of the SQS queue"
  type        = string
  default     = ""
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed"
  type        = number
  default     = 0
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain"
  type        = number
  default     = 262144
}

variable "message_retention_seconds" {
  description = "The number of seconds that Amazon SQS retains a message"
  type        = number
  default     = 345600  # 4 days
}

variable "visibility_timeout_seconds" {
  description = "The duration (in seconds) that the received messages are hidden from subsequent retrieve requests"
  type        = number
  default     = 30
}

variable "receive_wait_time_seconds" {
  description = "The duration (in seconds) for which the call waits for a message to arrive in the queue before returning"
  type        = number
  default     = 0
}

variable "fifo_queue" {
  description = "Designates a FIFO (first-in-first-out) queue"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication"
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SQS"
  type        = string
  default     = ""
}

variable "redrive_policy" {
  description = "The JSON policy string specifying the parameters for the dead-letter queue functionality"
  type        = string
  default     = ""
}