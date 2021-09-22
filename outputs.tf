output "acm_certificate_arn" {
  value       = module.acm.acm_certificate_arn
  description = "The ARN of the SSL certificate returned from ACM."
}
output "cloudfront_domain_name" {
  value       = module.s3_static_website.cloudfront_domain_name
  description = "The domain name used by your cloudfront distribution. If you are using the 'default_domain' variable, you would use this."
}

output "cloudfront_dist_id" {
  value       = module.s3_static_website.cloudfront_dist_id
  description = "Cloudfront Distribution ID for this site."
}

output "s3_domain_name" {
  value       = module.s3_static_website.s3_domain_name
  description = "The domain name of your S3 bucket. For reference only. Either use the Cloudfront Distrobution, or 'website_address' output."
}

output "website_address" {
  value       = var.domain_name
  description = "If not using the 'default_domain' variable, this will return your Route53 domain name."
}

output "website_bucket_arn" {
  value       = module.s3_static_website.s3_bucket_arn
  description = "The arn of the created s3 website bucket."
}

output "website_bucket_name" {
  value       = module.s3_static_website.s3_bucket_name
  description = "The name of the created s3 website bucket."
}

output "s3_log_bucket_arn" {
  value       = module.s3_static_website.s3_log_bucket_arn
  description = "The arn of the created s3 logging bucket."
}

output "s3_log_bucket_name" {
  value       = module.s3_static_website.s3_log_bucket_name
  description = "The name of the created s3 logging bucket"
}

output "log_bucket_KMS_key_arn" {
  value       = module.s3_static_website.log_bucket_KMS_key_arn
  description = "The arn of the created KMS key for the logging bucket. Used for encrypting/decrypting the bucket."
}