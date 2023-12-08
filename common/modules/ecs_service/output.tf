output "ecs_cluster_arn" {
  value = aws_ecs_service.service.id
}

output "ecs_cluster" {
  value = aws_ecs_service.service.cluster
}

output "ecs_desired_count" {
  value = aws_ecs_service.service.desired_count
}

output "ecs_service_name" {
  value = aws_ecs_service.service.name
}

output "ecs_service_role" {
  value = aws_ecs_service.service.iam_role
}
