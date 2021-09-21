provider "aws" {
  region = "us-east-1"
  alias  = "aws_cloudfront"
}

locals {
  default_certs             = var.use_default_domain ? ["default"] : []
  acm_certs                 = var.use_default_domain ? [] : ["acm"]
  domain_name               = var.use_default_domain ? [] : [var.domain_name]
  joined_list               = concat(var.subject_alternative_name_prefixes, var.preprod_env_prefixes)
  subject_alternative_names = var.use_default_domain ? formatlist("%s.${var.domain_name[0]}", local.joined_list) : []
}

# This creates an SSL certificate
resource "aws_acm_certificate" "domain_name" {
  count                     = var.use_default_domain ? 0 : 1
  domain_name               = var.domain_name
  subject_alternative_names = local.subject_alternative_names
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "domain_name" {
  count        = var.use_default_domain ? 0 : 1
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "route53_records" {
  for_each = {
    for dvo in aws_acm_certificate.domain_name[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain_name[0].zone_id
}


resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.domain_name[0].arn
  validation_record_fqdns = [for record in aws_route53_record.route53_records : record.fqdn]
}