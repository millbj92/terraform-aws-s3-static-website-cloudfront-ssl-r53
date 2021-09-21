provider "aws" {
  region = "us-east-1"
}

module "acm" {
  source                            = "../modules/acm"
  domain_name                       = "dev.example.com"
  subject_alternative_name_prefixes = ["www", "*"]
  hosted_zone                       = "example.com"
  acm_certificate_domain            = "example.com"
  preprod_env_prefixes              = ["dev", "stg"]
}



module "s3_static_website" {
  source                = "../modules/s3_static_website"
  domain_name           = "dev.example.com"
  hosted_zone_domain    = "example.com"
  aws_certificate_arn   = module.acm.acm_certificate_arn
  use_default_domain    = false
  logging               = true
  use_bucket_encryption = true
  enable_key_rotation   = true
  tags                  = var.tags
}