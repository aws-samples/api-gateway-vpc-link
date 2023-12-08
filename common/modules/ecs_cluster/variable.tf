variable "environment" {
  description = "Environment to be used e.g dev/prod/stage "
  type        = string
}

variable "cluster_name" {
  description = "Name of the application"
  type        = string
  default     = "sample"
}
