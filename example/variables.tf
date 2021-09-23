# Input variable definitions
variable "domain_name" {
  description = "Domain name. Must be unique, and already registered."
  type        = string
}

variable "hosted_zone" {
  description = "The root domain of your website. No subdomains. (example.com)"
  type        = string
}

variable "aws_certificate_arn" {
  description = "ARN for SSL certificate. Only needed for custom domain names."
  type        = string
  default     = null
}

variable "price_class" {
  description = "CloudFront distribution price class"
  type        = string
  default     = "PriceClass_100"
}

variable "subject_alternative_name_prefixes" {
  description = "Alternative names for the domain. Wildcards mau be used. (*.example.com, etc)"
  type        = list(string)
  default     = ["www", "*"]
}

variable "preprod_env_prefixes" {
  description = "Use these to register subdomains in Route53. Leave this empty if you don't want subdomains."
  type        = list(string)
  default     = ["dev.", "stg"]
}

variable "logging" {
  description = "Use logging for resources. Will create an extra bucket."
  type        = bool
  default     = true
}

variable "log_cookies" {
  description = "Log cookies in cloudfront. Only works in logging is true."
  type        = bool
  default     = false
}

variable "use_bucket_encryption" {
  description = "Set this to true to encrypt your buckets with a KMS key."
  type        = bool
  default     = true
}

variable "enable_key_rotation" {
  description = "Set this to true in order to enable key rotation. Only works if use_bucket_encryption is true. Recommend setting to true so you don't get locked out of your buckets!"
  type        = bool
  default     = true
}

variable "use_default_domain" {
  description = "Use CloudFront website address without Route53 and ACM certificate"
  type        = string
  default     = false
}

variable "deploy_redirect_bucket" {
  description = "Set this to true to deploy a bucket what will redirect from www to non-www"
  type        = bool
  default     = false
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "This value will force-delete your buckets with files sill inside. You have been warned. Do not use in Prod."
}

variable "acm_certificate_domain" {
  description = "Domain of the ACM certificate"
  type        = string
  default     = null
}

variable "region" {
  description = "Your AWS Region. Defaults to us-east-1"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags to set on the resources."
  type        = map(string)
  default     = {}
}



