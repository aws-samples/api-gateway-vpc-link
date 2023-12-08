
variable "domain_name" {
  description = "The domain name to create Route 53 records for."
  type        = string
}

variable "dns_name" {
  description = "The DNS name."
  type        = string
}

variable "ttl" {
  description = "The TTL (time to live) value for the Route 53 records."
  type        = number
  default     = 300
}

variable "hosted_zone_id" {
  description = "The Hosted ZOne ID."
  type        = string
}

variable "lb_zone_id" {
  description = "The ALB zone ID."
  type        = string
}