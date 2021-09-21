provider "aws" {
  region = "us-east-1"
}

module "acm" {
  source                            = "../modules/acm"
  domain_name                       = "dev.nuboverflow.com"
  subject_alternative_name_prefixes = ["www", "*"]
  hosted_zone                       = "nuboverflow.com"
  acm_certificate_domain            = "nuboverflow.com"
  preprod_env_prefixes              = ["dev", "stg"]
}



module "s3_static_website" {
  source                = "../modules/s3_static_website"
  domain_name           = "dev.nuboverflow.com"
  hosted_zone_domain    = "nuboverflow.com"
  aws_certificate_arn   = module.acm.acm_certificate_arn
  use_default_domain    = false
  logging               = true
  use_bucket_encryption = true
  enable_key_rotation   = true
  tags                  = var.tags
}