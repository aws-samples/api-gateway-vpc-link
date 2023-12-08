# General
variable "environment" {
  description = "Environment to be used e.g dev/prod/stage "
  type        = string
  default     = "prod"
}

variable "role_name" {
  description = "Name of the role"
  type        = string
  default     = "sample"
}

variable "policy_name" {
  description = "Name of the policy"
  type        = string
  default     = null
}

variable "assume_role_policy_file" {
  description = "Parent directory of the assume role policy file."
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the IAM role"
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = "Whether to force detach policies from the IAM role"
  type        = bool
  default     = false
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs"
  type        = list(string)
  default     = []
}

variable "max_session_duration" {
  description = "Maximum session duration for the IAM role"
  type        = number
  default     = 43200
}

variable "role_path" {
  description = "Path for the IAM role"
  type        = string
  default     = "/"
}

variable "permissions_boundary" {
  description = "Permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "inline_policy" {
  description = "List of inline policies"
  type = list(object({
    name      = string
    file_path = string
  }))
  default = []
}

variable "policy_description" {
  description = "SelfManaged policy description"
  type        = string
}

variable "self_managed_policy_statements" {
  description = "List of policy statements"
  type = list(object({
    Resource = list(string)
    Action   = list(string)
    Effect    = string
  }))
}

variable "enable_self_managed_policy" {
  description = "Whether to create a policy resource or not."
  type        = bool
  default     = true
}