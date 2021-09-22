# BMIO_S3_Static_Website

#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement_aws) | 3.59.0 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws) | 3.59.0 |

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module_acm) | ./acm | n/a |
| <a name="module_s3_static_website"></a> [s3_static_website](#module_s3_static_website) | ./s3_static_website | n/a |

#### Resources

| Name | Type |
|------|------|
| [aws_route53_record.website_cdn_root_record](https://registry.terraform.io/providers/hashicorp/aws/3.59.0/docs/resources/route53_record) | resource |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/3.59.0/docs/data-sources/route53_zone) | data source |

#### Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_domain_name"></a> [domain_name](#input_domain_name) | Domain name. Must be unique, and already registered. | `string` |
| <a name="input_hosted_zone"></a> [hosted_zone](#input_hosted_zone) | The root domain of your website. No subdomains. (example.com) | `string` |
| <a name="input_acm_certificate_domain"></a> [acm_certificate_domain](#input_acm_certificate_domain) | Domain of the ACM certificate | `string` |
| <a name="input_aws_certificate_arn"></a> [aws_certificate_arn](#input_aws_certificate_arn) | ARN for SSL certificate. Only needed for custom domain names. | `string` |
| <a name="input_deploy_redirect_bucket"></a> [deploy_redirect_bucket](#input_deploy_redirect_bucket) | Set this to true to deploy a bucket what will redirect from www to non-www | `bool` |
| <a name="input_enable_key_rotation"></a> [enable_key_rotation](#input_enable_key_rotation) | Set this to true in order to enable key rotation. Only works if use_bucket_encryption is true. Recommend setting to true so you don't get locked out of your buckets! | `bool` |
| <a name="input_log_cookies"></a> [log_cookies](#input_log_cookies) | Log cookies in cloudfront. Only works in logging is true. | `bool` |
| <a name="input_logging"></a> [logging](#input_logging) | Use logging for resources. Will create an extra bucket. | `bool` |
| <a name="input_preprod_env_prefixes"></a> [preprod_env_prefixes](#input_preprod_env_prefixes) | Use these to register subdomains in Route53. Leave this empty if you don't want subdomains. | `list(string)` |
| <a name="input_price_class"></a> [price_class](#input_price_class) | CloudFront distribution price class | `string` |
| <a name="input_subject_alternative_name_prefixes"></a> [subject_alternative_name_prefixes](#input_subject_alternative_name_prefixes) | Alternative names for the domain. Wildcards mau be used. (*.example.com, etc) | `list(string)` |
| <a name="input_tags"></a> [tags](#input_tags) | Tags to set on the resources. | `map(string)` |
| <a name="input_use_bucket_encryption"></a> [use_bucket_encryption](#input_use_bucket_encryption) | Set this to true to encrypt your buckets with a KMS key. | `bool` |
| <a name="input_use_default_domain"></a> [use_default_domain](#input_use_default_domain) | Use CloudFront website address without Route53 and ACM certificate | `string` |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm_certificate_arn](#output_acm_certificate_arn) | n/a |
| <a name="output_cloudfront_dist_id"></a> [cloudfront_dist_id](#output_cloudfront_dist_id) | Cloudfront Distribution ID for this site. |
| <a name="output_cloudfront_domain_name"></a> [cloudfront_domain_name](#output_cloudfront_domain_name) | The domain name used by your cloudfront distribution. If you are using the 'default_domain' variable, you would use this. |
| <a name="output_log_bucket_KMS_key_arn"></a> [log_bucket_KMS_key_arn](#output_log_bucket_KMS_key_arn) | The arn of the created KMS key for the logging bucket. Used for encrypting/decrypting the bucket. |
| <a name="output_s3_domain_name"></a> [s3_domain_name](#output_s3_domain_name) | The domain name of your S3 bucket. For reference only. Either use the Cloudfront Distrobution, or 'website_address' output. |
| <a name="output_s3_log_bucket_arn"></a> [s3_log_bucket_arn](#output_s3_log_bucket_arn) | The arn of the created s3 logging bucket. |
| <a name="output_s3_log_bucket_name"></a> [s3_log_bucket_name](#output_s3_log_bucket_name) | The name of the created s3 logging bucket |
| <a name="output_website_address"></a> [website_address](#output_website_address) | If not using the 'default_domain' variable, this will return your Route53 domain name. |
| <a name="output_website_bucket_arn"></a> [website_bucket_arn](#output_website_bucket_arn) | The arn of the created s3 website bucket. |
| <a name="output_website_bucket_name"></a> [website_bucket_name](#output_website_bucket_name) | The name of the created s3 website bucket. |
