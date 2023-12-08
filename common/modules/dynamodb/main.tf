data "aws_caller_identity" "current" {}

resource "aws_dynamodb_table" "dynamodb_table" {
  name           = "${var.app}-${var.environment}-${var.table_name}"
  billing_mode   = var.billing_mode
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  hash_key       = var.hash_key
  range_key      = var.range_key
  deletion_protection_enabled = var.deletion_protection_enabled

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "ttl" {
    for_each = var.ttl_enabled ? [1] : []
    content {
      enabled         = var.ttl_enabled
      attribute_name  = var.ttl_attribute_name
    }
  }

  tags = {
    Name        = var.table_name
  }

}

