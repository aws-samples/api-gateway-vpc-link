variable "environment" {
  description = "Environment to be used e.g dev/prod/stage "
  type        = string
  default     = "prod"
}

variable "name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "number_of_images" {
  description = "Number of images to keep"
  type        = number
  default     = 5
}
  
variable "lifecycle_policy" {
  description = "The lifecycle policy of the ECR repository"
  type        = string
  default     = null
}

variable "image_tag_mutability" {
  description = "The image tag mutability of the ECR repository"
  type        = string
  default     = "MUTABLE"
}
  
variable "scan_on_push" {
  description = "The scan on push of the ECR repository"
  type        = bool
  default     = false
}

variable "tags" {
  description = "The tags of the ECR repository"
  type        = map(string)
  default     = {}
}
