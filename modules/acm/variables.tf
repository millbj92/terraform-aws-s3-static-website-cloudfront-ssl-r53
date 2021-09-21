variable "domain_name" {
  description = "Domain name. Must be unique, and already registered."
  type        = string
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

variable "use_default_domain" {
  description = "Use CloudFront website address without Route53 and ACM certificate"
  type        = string
  default     = false
}

variable "acm_certificate_domain" {
  description = "Domain of the ACM certificate"
  type        = string
  default     = null
}

variable "hosted_zone" {
  description = "Route53 Hosted Zone"
  type        = string
  default     = null
}