environment = "dev"
app         = "sample"
app_owner   = "Umair"
region      = "us-east-1"

# # DynamoDB
table_name                  = "dynamo-table-sample"
billing_mode                = "PAY_PER_REQUEST"
hash_key                    = "request_id"
deletion_protection_enabled = true

attributes = [{
  name = "request_id"
  type = "S"
}]

# # ECS CLuster
cluster_name = "sample"

# ECS Task Defination
cpu_api    = 256
memory_api = 512

cpu_processing    = 1024
memory_processing = 2048

# ECS Task Defination API
api_td_name        = "api"
api_image_tag      = "latest"
api_container_port = 5000
api_host_port      = 5000

# # ECS Task Defination PROCESSING
processing_td_name        = "processing"
processing_image_tag      = "latest"
processing_container_port = 9090
processing_host_port      = 9090

# ECS Task Defination Common
requires_compatibilities = ["FARGATE"]
network_mode             = "awsvpc"
operating_system_family  = "LINUX"
cpu_architecture         = "X86_64"
log_driver               = "awslogs"

# # IAM role for execution
execution_role_name               = "task_execution_role"
execution_assume_role_policy_file = "../terraform/app-infra/ecs-execution-trust-policy.json"
execution_policy_name             = "exection_policy_ecs_task"
execution_policy_description      = "Policy for ecr and log group"

# IAM Role for task
task_role_name               = "task_role"
task_assume_role_policy_file = "../terraform/app-infra/ecs-task-trust-policy.json"
task_policy_name             = "ecs_task_policy"
task_policy_description      = "Policy for sqs and secret manager."


# # ECS Service API
api_service_name                 = "sample-api"
api_load_balancer_container_name = "api"
api_load_balancer_container_port = 5000

# ECS Service Procssing
processing_service_name                 = "sample-processing"
processing_load_balancer_container_name = "processing"
processing_load_balancer_container_port = 9090

#ECS Service Common
desired_count                     = 1
enable_ecs_managed_tags           = true
health_check_grace_period_seconds = 30
launch_type                       = "FARGATE"
platform_version                  = "LATEST"
propagate_tags                    = "TASK_DEFINITION"

#ALB
internal                                    = true
api_target_group_port                       = 5000
api_target_group_protocol                   = "HTTP"
api_health_check_interval                   = 30
api_health_check_path                       = "/health"
api_health_check_healthy_threshold          = 3
api_health_check_unhealthy_threshold        = 3
api_health_check_timeout                    = 5
api_listener_port                           = 443
api_listener_protocol                       = "HTTPS"
api_https_listener_ssl_policy               = "ELBSecurityPolicy-2016-08"
api_https_listener_certificate_arn          = "arn:aws:acm:us-east-1:123456789:certificate/exxxx-xxxxx-xxxxx-xxxxx"
processing_target_group_port                = 9090
processing_target_group_protocol            = "HTTP"
processing_health_check_interval            = 30
processing_health_check_path                = "/health"
processing_health_check_healthy_threshold   = 3
processing_health_check_unhealthy_threshold = 3
processing_health_check_timeout             = 5
processing_listener_port                    = 9090
processing_listener_protocol                = "HTTPS"
processing_https_listener_ssl_policy        = "ELBSecurityPolicy-2016-08"
processing_https_listener_certificate_arn   = "arn:aws:acm:us-east-1:123456789:certificate/exxxx-xxxxx-xxxxx-xxxxx"
hosted_zone_id                              = "Z00000000000000000"
api_resource_path_get                       = "lookup_status"
api_resource_path_post                      = "lookup"