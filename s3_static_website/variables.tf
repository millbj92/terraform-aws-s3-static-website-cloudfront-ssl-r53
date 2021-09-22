# Input variable definitions

variable "domain_name" {
  description = "Domain name. Must be unique, and already registered."
  type        = string
}

variable "hosted_zone_domain" {
  description = "The root domain of your website. No subdomains. (example.com)"
  type        = string
}

variable "tags" {
  description = "Tags to set on the resources."
  type        = map(string)
  default     = {}
}

variable "price_class" {
  description = "CloudFront distribution price class"
  type        = string
  default     = "PriceClass_100" // Only US,Canada,Europe
}

variable "use_default_domain" {
  description = "Use CloudFront website address without Route53 and ACM certificate"
  type        = string
  default     = false
}

variable "logging" {
  type        = bool
  default     = true
  description = "Use logging for resources. Will create an extra bucket."
}

variable "log_cookies" {
  type        = bool
  default     = false
  description = "Log cookies in cloudfront. Only works in logging is true."
}

variable "use_bucket_encryption" {
  type        = bool
  default     = true
  description = "Set this to true to encrypt your buckets with a KMS key."
}

variable "aws_certificate_arn" {
  type        = string
  default     = null
  description = "SSL Certificate used to link the Cloudfront resource to the dns record."
}

variable "enable_key_rotation" {
  type        = bool
  default     = true
  description = "Set this to true in order to enable key rotation. Only works if use_bucket_encryption is true. Recommend setting to true so you don't get locked out of your buckets!"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "This value will force-delete your buckets with files sill inside. You have been warned. Do not use in Prod."
}

variable "deploy_redirect_bucket" {
  description = "Set this to true to deploy a bucket what will redirect from www to non-www"
  type        = bool
  default     = false
}


