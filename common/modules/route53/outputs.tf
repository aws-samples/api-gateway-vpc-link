output "fqdn" {
  description = "The FQDN"
  value       = aws_route53_record.alias.fqdn
}