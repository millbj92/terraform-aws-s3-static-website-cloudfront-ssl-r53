
provider "aws" {
  region = "us-east-1"
}

module "acm" {
  source                            = "./acm"
  domain_name                       = var.domain_name
  subject_alternative_name_prefixes = var.subject_alternative_name_prefixes
  hosted_zone                       = var.hosted_zone
  acm_certificate_domain            = var.acm_certificate_domain
  preprod_env_prefixes              = var.preprod_env_prefixes
}


module "s3_static_website" {
  source                 = "./s3_static_website"
  domain_name            = var.domain_name
  aws_certificate_arn    = module.acm.acm_certificate_arn
  use_default_domain     = var.use_default_domain
  logging                = var.logging
  use_bucket_encryption  = var.use_bucket_encryption
  enable_key_rotation    = var.enable_key_rotation
  tags                   = var.tags
  deploy_redirect_bucket = var.deploy_redirect_bucket
  force_destroy          = var.force_destroy
}

data "aws_route53_zone" "main" {
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "website_cdn_root_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.s3_static_website.cloudfront_domain_name
    zone_id                = module.s3_static_website.cloudfront_zone_id
    evaluate_target_health = false
  }
}