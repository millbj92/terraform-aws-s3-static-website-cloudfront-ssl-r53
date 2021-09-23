terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.59.0"
    }
  }
}

module "aws_static_website" {
  source = "../"
  //common
  domain_name = var.domain_name

  //s3_static_site specific
  use_default_domain     = var.use_default_domain
  logging                = var.logging
  use_bucket_encryption  = var.use_bucket_encryption
  enable_key_rotation    = var.enable_key_rotation
  tags                   = var.tags
  deploy_redirect_bucket = var.deploy_redirect_bucket
  force_destroy          = var.force_destroy

  //acm & Route53 specific
  subject_alternative_name_prefixes = var.subject_alternative_name_prefixes
  hosted_zone                       = var.hosted_zone
  acm_certificate_domain            = var.acm_certificate_domain
  preprod_env_prefixes              = var.preprod_env_prefixes
}