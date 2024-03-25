output "domain_name" {
  value = var.domain_name
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.acm_certificate.arn
}
