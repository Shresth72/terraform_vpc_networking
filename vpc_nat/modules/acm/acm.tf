resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = ""
  subject_alternative_names = ""
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
