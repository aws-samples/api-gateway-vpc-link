data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
module "dynamodb" {
  source = "../../common/modules/dynamodb"

  table_name                  = var.table_name
  billing_mode                = var.billing_mode
  hash_key                    = var.hash_key
  deletion_protection_enabled = var.deletion_protection_enabled
  attributes                  = var.attributes
  environment                 = var.environment
  app                         = var.app
}

module "ecs_cluster" {
  source       = "../../common/modules/ecs_cluster"
  environment  = var.environment
  cluster_name = var.cluster_name
}

module "execution_role" {
  source = "../../common/modules/iam_role"

  role_name               = var.execution_role_name
  assume_role_policy_file = var.execution_assume_role_policy_file
  policy_name             = var.execution_policy_name
  policy_description      = var.execution_policy_description
  environment             = var.environment
  self_managed_policy_statements = [
    {
      Resource = ["*"]
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:CreateLogGroup",
        "ecr:GetAuthorizationToken"
      ]
      Effect = "Allow"
    },
    {
      Resource = [
        "*"
      ]
      Action = [
        "ssm:GetParameter"
      ]
      Effect = "Allow"
    },
    {
      Resource = [
        "*"
      ]
      Action = [
        "kms:GetPublicKey",
        "kms:Decrypt",
        "kms:GenerateDataKey",
        "kms:DescribeKey"
      ]
      Effect = "Allow"
    },
    {
      Resource = [
        "*"
      ]
      Action = [
        "secretsmanager:GetSecretValue"
      ]
      Effect = "Allow"
    }
  ]
}

module "task_role" {
  source = "../../common/modules/iam_role"

  role_name               = var.task_role_name
  policy_name             = var.task_policy_name
  assume_role_policy_file = var.task_assume_role_policy_file
  policy_description      = var.task_policy_description
  environment             = var.environment
  self_managed_policy_statements = [
    {
      Resource = [
        "${module.my_sqs_queue.queue_arn}"
      ]
      Action = [
        "sqs:GetQueueUrl",
        "sqs:ReceiveMessage",
        "sqs:SendMessage",
        "sqs:ChangeMessageVisibility",
        "sqs:deletemessage"
      ]
      Effect = "Allow"
    },
    {
      Resource = [
        "*"
      ]
      Action = [
        "secretsmanager:GetSecretValue"
      ]
      Effect = "Allow"
    },
    {
      Resource = [
        "*"
      ]
      Action = [
        "apigateway:GET"
      ]
      Effect = "Allow"
    },
    {
      "Action": [
          "dynamodb:GetItem",
          "dynamodb:PutItem"
      ],
      "Effect": "Allow",
      "Resource": [
          "*"
      ]
    }
  ]
}

module "api_task_defination" {
  source                   = "../../common/modules/ecs-task-defination"
  name                     = var.api_td_name
  container_port           = var.api_container_port
  host_port                = var.api_host_port
  ecr_repo                 = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.environment}-sample-api"
  image_tag                = var.api_image_tag
  region                   = var.region
  requires_compatibilities = var.requires_compatibilities
  network_mode             = var.network_mode
  execution_role_arn       = module.execution_role.role_arn
  task_role_arn            = module.task_role.role_arn
  operating_system_family  = var.operating_system_family
  cpu_architecture         = var.cpu_architecture
  log_driver               = var.log_driver
  environment              = var.environment
  cpu                      = var.cpu_api
  memory                   = var.memory_api
  secret_name              = aws_secretsmanager_secret.sample.name
  commit_sha               = var.commit_sha

}

module "processing_task_defination" {
  source = "../../common/modules/ecs-task-defination"

  name           = var.processing_td_name
  container_port = var.processing_container_port
  host_port      = var.processing_host_port
  ecr_repo       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.environment}-sample-processing"
  image_tag      = var.processing_image_tag

  region                   = var.region
  requires_compatibilities = var.requires_compatibilities
  network_mode             = var.network_mode
  execution_role_arn       = module.execution_role.role_arn
  task_role_arn            = module.task_role.role_arn
  operating_system_family  = var.operating_system_family
  cpu_architecture         = var.cpu_architecture
  log_driver               = var.log_driver
  environment              = var.environment
  cpu                      = var.cpu_processing
  memory                   = var.memory_processing
  secret_name              = aws_secretsmanager_secret.sample.name
  commit_sha               = var.commit_sha
}

module "api_ecs_service" {

  source = "../../common/modules/ecs_service"

  name                              = var.api_service_name
  task_definition                   = module.api_task_defination.task_defination_arn
  load_balancer_container_name      = var.api_load_balancer_container_name
  load_balancer_container_port      = var.api_load_balancer_container_port
  load_balancer_target_group_arn    = aws_lb_target_group.api_target_group.arn
  cluster                           = module.ecs_cluster.ecs_cluster_arn
  desired_count                     = var.desired_count
  enable_ecs_managed_tags           = var.enable_ecs_managed_tags
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  launch_type                       = var.launch_type
  platform_version                  = var.platform_version
  propagate_tags                    = var.propagate_tags
  subnets                           = data.aws_subnets.private.ids
  security_groups                   = [aws_security_group.api_ecs_task_sg.id]

}

module "processing_ecs_service" {

  source = "../../common/modules/ecs_service"

  name                              = var.processing_service_name
  task_definition                   = module.processing_task_defination.task_defination_arn
  load_balancer_container_name      = var.processing_load_balancer_container_name
  load_balancer_container_port      = var.processing_load_balancer_container_port
  load_balancer_target_group_arn    = aws_lb_target_group.processing_target_group.arn
  cluster                           = module.ecs_cluster.ecs_cluster_arn
  desired_count                     = var.desired_count
  enable_ecs_managed_tags           = var.enable_ecs_managed_tags
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  launch_type                       = var.launch_type
  platform_version                  = var.platform_version
  propagate_tags                    = var.propagate_tags

  subnets         = data.aws_subnets.private.ids
  security_groups = [aws_security_group.processing_ecs_task_sg.id]

}

module "my_sqs_queue" {
  source = "../../common/modules/sqs"

  environment = var.environment
  app         = var.app
}

module "sqs_api_role" {
  source            = "../../common/modules/sqs_api_role"
  sqs_api_role_name = "${var.app}-${var.environment}-sqs-api"
  aws_sqs_queue_arn = module.my_sqs_queue.queue_arn
}

resource "aws_secretsmanager_secret" "sample" {
  name = "${var.environment}-${var.app}"

}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id     = aws_secretsmanager_secret.sample.id
  secret_string = <<EOF
   {
    "API_KEY_ID": "${aws_api_gateway_api_key.sample.id}",
    "DYNAMO_DB_TABLE_NAME": "${module.dynamodb.table_name}",
    "SQS_QUEUE_URL":"${module.my_sqs_queue.queue_url}"
   }
EOF
}