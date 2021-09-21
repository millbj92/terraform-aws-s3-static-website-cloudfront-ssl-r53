# BMIO_ACM_Cert

This module is used for the creation of ACM certificates, and verify them with the Route53 DNS.
 Usage:

 Example of 'acm_create_cert" module in `main.tf`.

 ```hcl
module "acm" {
  source                            = "../modules/acm"
  domain_name                       = "dev.example.com"
  subject_alternative_name_prefixes = ["www", "*"]
  hosted_zone                       = "example.com"
  acm_certificate_domain            = "example.com"
  preprod_env_prefixes              = ["dev", "stg"]
}
 ```

 *Please Note* While I have tried to follow the best security practices out-of-the-box, there is still some recommended setup. Please consider creating a WAF ([Web application Firewall](https://aws.amazon.com/waf/)) in front of your cloudfront distribution. It is highly recommended that you use one, especially in a production environment. That said, WAF's are very situation-specific, so I cannot guess how your setup should behave.
 [WAF Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl)

#### Requirements

No requirements.

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws) | 3.59.0 |

#### Modules

No modules.

#### Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.domain_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.route53_records](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.domain_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

#### Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_domain_name"></a> [domain_name](#input_domain_name) | Domain name. Must be unique, and already registered. | `string` |
| <a name="input_acm_certificate_domain"></a> [acm_certificate_domain](#input_acm_certificate_domain) | Domain of the ACM certificate | `string` |
| <a name="input_hosted_zone"></a> [hosted_zone](#input_hosted_zone) | Route53 Hosted Zone | `string` |
| <a name="input_preprod_env_prefixes"></a> [preprod_env_prefixes](#input_preprod_env_prefixes) | Use these to register subdomains in Route53. Leave this empty if you don't want subdomains. | `list(string)` |
| <a name="input_subject_alternative_name_prefixes"></a> [subject_alternative_name_prefixes](#input_subject_alternative_name_prefixes) | Alternative names for the domain. Wildcards mau be used. (*.example.com, etc) | `list(string)` |
| <a name="input_use_default_domain"></a> [use_default_domain](#input_use_default_domain) | Use CloudFront website address without Route53 and ACM certificate | `string` |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm_certificate_arn](#output_acm_certificate_arn) | The domain name used by your cloudfront distribution. If you are using the 'default_domain' variable, you would use this. |
