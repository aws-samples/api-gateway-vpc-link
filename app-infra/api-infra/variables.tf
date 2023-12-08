variable "environment" {
  description = "The environment (lowercase)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Region for the resources"
  type        = string
  default     = "us-east-1"
}

variable "app" {
  description = "The name of the app"
  type        = string
}

variable "app_owner" {
  description = "The owner of the app"
  type        = string
}

# DynamoDB
variable "table_name" {
  description = "The name of the DynamoDB table."
  type        = string
}

variable "hash_key" {
  description = "Required, Forces new resource) Attribute to use as the hash (partition) key. Must also be defined as an attribute."
  type        = string
  default     = "id"
}

variable "billing_mode" {
  description = "The valid values are PROVISIONED and PAY_PER_REQUEST. Defaults to PROVISIONED."
  type        = string
  default     = "PROVISIONED"
  validation {
    condition     = var.billing_mode == "PROVISIONED" || var.billing_mode == "PAY_PER_REQUEST"
    error_message = "Invalid billing_mode value. Valid values are PROVISIONED or PAY_PER_REQUEST."
  }
}

variable "deletion_protection_enabled" {
  description = "Enables deletion protection for table."
  type        = bool
  default     = false
}

variable "attributes" {
  description = "Set of nested attribute definitions. Only required for hash_key and range_key attributes. Attribute type. Valid values are S (string), N (number), B (binary)."
  type = list(object({
    name = string
    type = string
  }))
}


# Cluster
variable "cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
}

# task defination API
variable "api_td_name" {
  description = "The name of the task defination."
  type        = string
}

variable "api_image_tag" {
  description = "Image tag for the API"
  type        = string
}

variable "api_container_port" {
  description = "container port that is exposed inside container"
  type        = number
}

variable "api_host_port" {
  description = "host port that is mapped to container port"
  type        = number
}

# Task Defination Processing
variable "processing_td_name" {
  description = "The name of the task defination."
  type        = string
}

variable "processing_image_tag" {
  description = "Image tag for processing"
  type        = string
}

variable "processing_container_port" {
  description = "container port that is exposed inside container"
  type        = number
}

variable "processing_host_port" {
  description = "host port that is mapped to container port"
  type        = number
}

# Task Defination Common
variable "log_driver" {
  description = "The log driver to use for the container."
  type        = string
}

variable "requires_compatibilities" {
  description = "The compatibilities required by the ECS task definition."
  type        = list(string)
}

variable "network_mode" {
  description = "The network mode for the ECS task definition."
  type        = string
}

variable "operating_system_family" {
  #https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#runtime-platform
  description = "If the requires_compatibilities is FARGATE this field is required; must be set to a valid option."
  type        = string
  default     = "LINUX"
}

variable "cpu_architecture" {
  description = "Must be set to either X86_64 or ARM64."
  type        = string
}

# Execution Role

variable "execution_role_name" {
  description = "Name of the role to be attached with task."
  type        = string
}
variable "execution_policy_description" {
  description = "IAM Policy description."
  type        = string
}

variable "execution_assume_role_policy_file" {
  description = "Path to assume role policy file."
  type        = string
  default     = ""
}

variable "execution_policy_name" {
  description = "Name of the policy"
  type        = string
}

# Task Role
variable "task_role_name" {
  description = "Name of the role to be attached with task."
  type        = string
}

variable "task_policy_description" {
  description = "Name of the role to be attached with task."
  type        = string
}

variable "task_assume_role_policy_file" {
  description = "Path to assume role policy file."
  type        = string
  default     = ""
}

variable "task_policy_name" {
  description = "Name of the policy"
  type        = string
}


# ECS Service API
variable "api_service_name" {
  description = "Name for ecs service."
  type        = string
}

variable "api_load_balancer_container_name" {
  description = "Name of the container to associate with the target group"
  type        = string
}

variable "api_load_balancer_container_port" {
  description = "Port on the container to associate with the load balancer."
  type        = string
}

# ECS Service PROCESSING
variable "processing_service_name" {
  description = "Name for ecs service."
  type        = string
}

variable "processing_load_balancer_container_name" {
  description = "Name of the container to associate with the target group"
  type        = string
}

variable "processing_load_balancer_container_port" {
  description = "Port on the container to associate with the load balancer."
  type        = string
}

# ECS Service Common
variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the DAEMON scheduling strategy."
  type        = number
}

variable "enable_ecs_managed_tags" {
  description = "(Optional) Specifies whether to enable Amazon ECS managed tags for the tasks within the service."
  type        = bool
  default     = false
}

variable "health_check_grace_period_seconds" {
  description = "(Optional) Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers."
  type        = number
}

variable "launch_type" {
  description = " (Optional) Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL. Defaults to EC2."
  type        = string
}

variable "platform_version" {
  description = "(Optional) Platform version on which to run your service. Only applicable for launch_type set to FARGATE."
  type        = string
  default     = "LATEST"
}

variable "propagate_tags" {
  description = "(Optional) Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-0c7292a31534b6168"
}

# ALB

variable "internal" {
  description = "Whether the Application Load Balancer should be internal or public"
  type        = bool
  default     = false
}


variable "api_target_group_port" {
  description = "Port on which the target group will receive traffic"
  type        = number
}

variable "api_target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}


variable "api_health_check_interval" {
  description = "Interval between health checks"
  type        = number
  default     = 30
}

variable "api_health_check_path" {
  description = "Path for the health check"
  type        = string
  default     = "/"
}

variable "api_health_check_healthy_threshold" {
  description = "Number of consecutive successful health checks required to consider a target healthy"
  type        = number
  default     = 3
}

variable "api_health_check_unhealthy_threshold" {
  description = "Number of consecutive failed health checks required to consider a target unhealthy"
  type        = number
  default     = 3
}

variable "api_health_check_timeout" {
  description = "Amount of time before the health check times out"
  type        = number
  default     = 5
}

variable "api_listener_port" {
  description = "Port for the ALB listener"
  type        = number
}

variable "api_listener_protocol" {
  description = "Protocol for the ALB listener"
  type        = string
  default     = "HTTP"
}

variable "api_https_listener_ssl_policy" {
  description = "The SSL policy for the HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "api_https_listener_certificate_arn" {
  description = "The ARN of the SSL certificate for the HTTPS listener."
  type        = string
}


variable "processing_target_group_port" {
  description = "Port on which the target group will receive traffic"
  type        = number
}

variable "processing_target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "processing_health_check_interval" {
  description = "Interval between health checks"
  type        = number
  default     = 30
}

variable "processing_health_check_path" {
  description = "Path for the health check"
  type        = string
  default     = "/"
}

variable "processing_health_check_healthy_threshold" {
  description = "Number of consecutive successful health checks required to consider a target healthy"
  type        = number
  default     = 3
}

variable "processing_health_check_unhealthy_threshold" {
  description = "Number of consecutive failed health checks required to consider a target unhealthy"
  type        = number
  default     = 3
}

variable "processing_health_check_timeout" {
  description = "Amount of time before the health check times out"
  type        = number
  default     = 5
}

variable "processing_listener_port" {
  description = "Port for the ALB listener"
  type        = number
}

variable "processing_listener_protocol" {
  description = "Protocol for the ALB listener"
  type        = string
  default     = "HTTP"
}

variable "processing_https_listener_ssl_policy" {
  description = "The SSL policy for the HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "processing_https_listener_certificate_arn" {
  description = "The ARN of the SSL certificate for the HTTPS listener."
  type        = string
}

variable "hosted_zone_id" {
  description = "The Hosted ZOne ID."
  type        = string
}

# ecs task defination
variable "cpu_api" {
  description = "The CPU units for the ECS task definition."
  type        = number
}

variable "memory_api" {
  description = "The memory limit (in MiB) for the ECS task definition."
  type        = number
}
variable "cpu_processing" {
  description = "The CPU units for the ECS task definition."
  type        = number
}

variable "memory_processing" {
  description = "The memory limit (in MiB) for the ECS task definition."
  type        = number
}
variable "commit_sha" {
  description = "Git commit sha for docker image used for task defination"
  default = "123"
}

# APi gateway


variable "api_gateway_description" {
  description = "The description of the API Gateway."
  type        = string
  default     = " API gateway"
}

variable "api_resource_path_get" {
  description = "The resource path of the API Gateway Get method."
  type        = string
}

variable "api_resource_path_post" {
  description = "The resource path of the API Gateway Post method."
  type        = string
}