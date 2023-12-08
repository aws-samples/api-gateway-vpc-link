variable "table_name" {
  description = "The name of the DynamoDB table."
  type        = string
}

variable "read_capacity" {
  description = " Number of read units for this table. If the billing_mode is PROVISIONED, this field is required.."
  type        = number
  default     = null
}

variable "write_capacity" {
  description = "Number of write units for this table. If the billing_mode is PROVISIONED, this field is required."
  type        = number
  default     = null
}

variable "hash_key" {
  description = "Required, Forces new resource) Attribute to use as the hash (partition) key. Must also be defined as an attribute."
  type        = string
  default     = "id"
}

variable "range_key" {
  description = "Name of the range key; must be defined"
  type        = string
  default     = null
}

variable "billing_mode" {
  description = "The valid values are PROVISIONED and PAY_PER_REQUEST. Defaults to PROVISIONED."
  type = string
  default = "PROVISIONED"
  validation {
    condition     = var.billing_mode == "PROVISIONED" || var.billing_mode == "PAY_PER_REQUEST"
    error_message = "Invalid billing_mode value. Valid values are PROVISIONED or PAY_PER_REQUEST."
  }
}

variable "environment" {
  description = "The environment (lowercase)"
  type        = string
  default     = "dev"
}

variable "deletion_protection_enabled" {
  description = "Enables deletion protection for table."
  type = bool
  default = false
}

variable "attributes" {
  description = "Set of nested attribute definitions. Only required for hash_key and range_key attributes. Attribute type. Valid values are S (string), N (number), B (binary)."
  type        = list(object({
    name = string
    type = string
  }))
}

variable "ttl_enabled" {
  description = "Whether TTL is enabled."
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "Name of the table attribute to store the TTL timestamp"
  type        = string
  default     = null
}

variable "app" {
  description = "The name of the app"
  type        = string
}