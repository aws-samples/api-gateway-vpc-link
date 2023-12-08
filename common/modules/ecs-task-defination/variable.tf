variable "name" {
  description = "The family name to use for the ECS task definition."
  type        = string
}

variable "region" {
  description = "Region for the resources"
  type = string
}

variable "secret_name" {
  description = "Secret name passed to sample Application"
  type = string
}
variable "environment" {
  description = "Environment to be used e.g dev/prod/stage "
  type        = string
  default     = "prod"
}

# variable "template_file_path" {
# 	description = "Path to template for task defiantion in .JSON file extension"
# 	type = string
# }

variable "requires_compatibilities" {
  description = "The compatibilities required by the ECS task definition."
  type        = list(string)
}

variable "network_mode" {
  description = "The network mode for the ECS task definition."
  type        = string
}

variable "cpu" {
  description = "The CPU units for the ECS task definition."
  type        = number
}

variable "memory" {
  description = "The memory limit (in MiB) for the ECS task definition."
  type        = number
}

variable "pid_mode" {
  description = "The process namespace mode for the ECS task definition."
  type        = string
  default = null
}

variable "ipc_mode" {
  description = "The IPC namespace mode for the ECS task definition."
  type        = string
  default = null
}

variable "skip_destroy" {
  description = "Whether to skip the ECS task definition resource during destroy."
  type        = bool
	default = false
}

# variable "container_name" {
# 	description = "Name of the container that will serve as the App Mesh proxy."
# 	type = string
# 	default = null
# }

# variable "properties" {
# 	description = "Set of network configuration parameters to provide the Container Network Interface (CNI) plugin, specified a key-value mapping."
# 	type = map(string)
# 	default = null
# }

# variable "proxy_type" {
# 	description = "Proxy type. The default value is APPMESH. The only supported value is APPMESH."
# 	type = string
# 	default = null
# }

# variable "size_in_gib" {
# 	description = " The total amount, in GiB, of ephemeral storage to set for the task. The minimum supported value is 21 GiB and the maximum supported value is 200 GiB."
# 	type = number
# 	default = null
# }

variable "operating_system_family" {
	#https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#runtime-platform
	description = "If the requires_compatibilities is FARGATE this field is required; must be set to a valid option."
	type = string
	default ="LINUX"
}

variable "cpu_architecture" {
	description = "Must be set to either X86_64 or ARM64."
	type = string

	default = "X86_64"
	validation {
		condition = var.cpu_architecture != "X86_64" || var.cpu_architecture != "ARM64"
		error_message = "cpu_architecture must be set to either X86_64 or ARM64."
	}
}

variable "execution_role_arn" {
  description = "The ARN of the application IAM role."
  type        = string
}

variable "task_role_arn" {
  description = "The ARN of the application IAM role for task."
  type        = string
}

variable "ecr_repo" {
  description = "ECR repository for the API"
  type        = string
}

variable "image_tag" {
  description = "Image tag for the API"
  type        = string
}


variable "log_driver" {
  description = "The log driver to use for the container."
  type = string
  default = "awslogs"
}

variable "container_port" {
  description = "container port that is exposed inside container"
  type        = number
}

variable "host_port" {
  description = "host port that is mapped to container port"
  type        = number
}

variable "commit_sha" {
  description = "Git commit sha for docker image used for task defination"
  default = "123"
}