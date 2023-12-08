data "aws_caller_identity" "current" {}


resource "aws_ecs_service" "service" {
  name                               = "${var.environment}-${var.name}-service"
  cluster                            = var.cluster
  task_definition                    = var.task_definition
  desired_count                      = var.desired_count
  iam_role                           = var.iam_role_arn
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  force_new_deployment               = var.force_new_deployment
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  launch_type                        = var.launch_type
  platform_version                   = var.platform_version
  wait_for_steady_state              = var.wait_for_steady_state
  propagate_tags                     = var.propagate_tags

  load_balancer {
    elb_name         = var.elb_name
    target_group_arn = var.load_balancer_target_group_arn
    container_name   = var.load_balancer_container_name
    container_port   = var.load_balancer_container_port
  }

  network_configuration {
    subnets = var.subnets
    security_groups = var.security_groups
    assign_public_ip = var.assign_public_ip
  }


}
