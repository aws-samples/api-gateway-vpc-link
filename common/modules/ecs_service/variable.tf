# General
variable "environment" {
  description = "Environment to be used e.g dev/prod/stage "
  type        = string
  default     = "prod"
}

variable "name" {
  description = "Name for all resources in this module."
  type        = string
  default     = null
}

# ECS Service
variable "cluster" {
  description = "The ARN of the ECS cluster"
  type        = string
}

variable "task_definition" {
  description = "Family and revision (family:revision) or full ARN of the task definition that you want to run in your service. Required unless using the EXTERNAL deployment controller. If a revision is not specified, the latest ACTIVE revision is used."
  type        = string
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the DAEMON scheduling strategy."
  type        = number
  default = 1
}

variable "iam_role_arn" {
  description = "ARN of the IAM role that allows Amazon ECS to make calls to your load balancer on your behalf. This parameter is required if you are using a load balancer with your service."
  type        = string
  default = null
}

variable "enable_ecs_managed_tags" {
  description = "(Optional) Specifies whether to enable Amazon ECS managed tags for the tasks within the service."
  type        = bool
  default     = false
}

variable "force_new_deployment" {
  description = "(Optional) Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g., myimage:latest)"
  type        = bool
  default     = false
}

variable "health_check_grace_period_seconds" {
  description = "(Optional) Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers."
  type        = number
  default     = null
}

variable "launch_type" {
  description = " (Optional) Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL. Defaults to EC2."
  type        = string
}

variable "platform_version" {
  description = "(Optional) Platform version on which to run your service. Only applicable for launch_type set to FARGATE."
  type        = string
  default = "LATEST"
}

variable "wait_for_steady_state" {
  description = "(Optional) If true, Terraform will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing. Default false."
  type        = bool
  default     = false
}

variable "propagate_tags" {
  description = "(Optional) Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION."
  type        = string
  validation {
     condition     = upper(var.propagate_tags) == "SERVICE" || upper(var.propagate_tags) == "TASK_DEFINITION"
    error_message = "Invalid propagate_tags value. Valid values are SERVICE or TASK_DEFINITION."
  }
}

# Load balancer
variable "load_balancer_target_group_arn" {
  description = "ARN of the target group to associate with the service"
  type        = string
}

variable "load_balancer_container_name" {
  description = "Name of the container to associate with the target group"
  type        = string
}

variable "load_balancer_container_port" {
  description = "Port on the container to associate with the load balancer."
  type        = string
}

variable "elb_name" {
  description = "(Required for ELB Classic) Name of the ELB (Classic) to associate with the service."
  type        = string
  default     = null
}

variable "subnets" {
  description = " Subnets associated with the task or service."
  type = list(string)
}

variable "security_groups" {
  description = "Security groups associated with the task or service. If you do not specify a security group, the default security group for the VPC is used"
  type = list(string)
}

variable "assign_public_ip" {
  description = " Assign a public IP address to the ENI (Fargate launch type only). Valid values are true or false. Default false."
  type = bool
  default = false
}