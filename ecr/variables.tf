variable "environment" {
  description = "The environment (lowercase)"
  type        = string
}

# ECR
variable "ecr_name" {
  description = "The name of the ECR repository"
  type        = list(string)
}

variable "number_of_images" {
  description = "Number of images to keep."
  type        = number
  default     = 5
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

variable "app_owner" {
  description = "The owner of the app"
  type        = string
}

variable "app" {
  description = "The name of the app"
  type        = string
}