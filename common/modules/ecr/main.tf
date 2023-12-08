locals {
  default_lifecycle_policy = {
    rules = [
      {
        rulePriority = 1
        description  = "Keep only the last 5 images"
        selection = {
          tagStatus = "any"
          countType = "imageCountMoreThan"
          countNumber = var.number_of_images
        }
        action = {
          type = "expire"
        }
      }
    ]
  }
}


data "aws_caller_identity" "current" {}


resource "aws_ecr_lifecycle_policy" "repo" {
  count      = var.lifecycle_policy != null ? 1 : 0
  repository = aws_ecr_repository.repo.name
  policy     = var.lifecycle_policy == null ? jsonencode(local.default_lifecycle_policy) : var.lifecycle_policy
}

resource "aws_ecr_repository" "repo" {
  name = "${var.environment}-${var.name}"

  image_tag_mutability = var.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}