output "acm_certificate_arn" {
  value       = aws_acm_certificate_validation.cert_validation.certificate_arn
  description = "The domain name used by your cloudfront distribution. If you are using the 'default_domain' variable, you would use this."
}