
output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "The domain name used by your cloudfront distribution. If you are using the 'default_domain' variable, you would use this."
}

output "cloudfront_dist_id" {
  value       = aws_cloudfront_distribution.s3_distribution.id
  description = "Cloudfront Distribution ID for this site."
}

output "cloudfront_zone_id" {
  value       = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
  description = "ID of the Hosted Zone that Cloudfront is connected to."
}

output "s3_domain_name" {
  value       = aws_s3_bucket.s3_bucket.website_domain
  description = "The domain name of your S3 bucket. For reference only. Either use the Cloudfront Distrobution, or 'website_address' output."
}

output "website_address" {
  value       = var.domain_name
  description = "If not using the 'default_domain' variable, this will return your Route53 domain name."
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.s3_bucket.arn
  description = "The arn of the created s3 website bucket."
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.s3_bucket.id
  description = "The name of the created s3 website bucket."
}

output "s3_log_bucket_arn" {
  value       = aws_s3_bucket.log_bucket[0].arn
  description = "The arn of the created s3 logging bucket."
}

output "s3_log_bucket_name" {
  value       = aws_s3_bucket.log_bucket[0].id
  description = "The name of the created s3 logging bucket"
}

output "log_bucket_KMS_key_arn" {
  value       = aws_kms_key.log_bucket[0].arn
  description = "The arn of the created KMS key for the logging bucket. Used for encrypting/decrypting the bucket."
}