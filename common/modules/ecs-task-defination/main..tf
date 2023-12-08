locals {
  name = "${var.environment}-${var.name}-task"
}

resource "aws_ecs_task_definition" "app" {
  family                   = local.name
container_definitions = jsonencode([
    {
      name          = var.name
      image         = "${var.ecr_repo}:${var.commit_sha}"
      essential     = true
      portMappings  = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
      environment = [
       { "name": "LIT_SECRETS", "value": "${var.secret_name}" },
       { "name": "ENV", "value": "prod" }
     ]
      memory = var.memory
      cpu    = var.cpu
      logConfiguration = {
        logDriver = var.log_driver
        options   = {
          "awslogs-group"          = "/ecs/${local.name}"
          "awslogs-region"         = var.region
          "awslogs-create-group"   = "true"
          "awslogs-stream-prefix"  = "/ecs"
        }
      }
    }
  ])

  requires_compatibilities = var.requires_compatibilities
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  pid_mode = var.pid_mode
  ipc_mode = var.ipc_mode
  skip_destroy = var.skip_destroy

  #  proxy_configuration {
  #    container_name = var.container_name
  #    properties = var.properties
  #    type = var.proxy_type
  #  }

  # ephemeral_storage {
  #   size_in_gib = var.size_in_gib
  # }

  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture = var.cpu_architecture 
  }

}
