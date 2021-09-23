

provider "aws" {
  //This provider is needed as cloudfront needs us-east-1
  region = "us-east-1"
  alias  = "aws_cloudfront"
}

locals {
  default_certs = var.use_default_domain ? ["default"] : []
  acm_certs     = var.use_default_domain ? [] : ["acm"]
  domain_name   = var.use_default_domain ? [] : [var.domain_name]
}
resource "aws_kms_key" "log_bucket" {
  count                   = var.logging && var.use_bucket_encryption ? 1 : 0
  description             = "KMS Key for log bucket"
  deletion_window_in_days = 30
  enable_key_rotation     = var.enable_key_rotation
}

resource "aws_s3_bucket" "log_bucket" {
  count  = var.logging ? 1 : 0
  bucket = "${var.domain_name}-logs"
  acl    = "log-delivery-write"
  tags   = var.tags
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    dynamic "rule" {
      for_each = var.use_bucket_encryption ? [1] : [0]
      content {
        apply_server_side_encryption_by_default {
          kms_master_key_id = aws_kms_key.log_bucket[0].arn
          sse_algorithm     = "aws:kms"
        }
      }
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = "1"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.domain_name}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn,
      ]
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_policy2" {
  count = var.deploy_redirect_bucket ? 1 : 0
  statement {
    sid = "1"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::www.${var.domain_name}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_cloudfront_origin_access_identity.origin_access_identity2.iam_arn,
      ]
    }
  }
}


resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.domain_name
  acl    = "private"
  versioning {
    enabled = true
  }
  dynamic "logging" {
    for_each = var.logging == true ? [1] : []
    content {
      target_bucket = aws_s3_bucket.log_bucket[0].id
      target_prefix = "website/"
    }
  }
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
  tags   = var.tags

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket" "s3_www_bucket2" {
  count  = var.deploy_redirect_bucket ? 1 : 0
  bucket = "www.${var.domain_name}"
  acl    = "private"
  versioning {
    enabled = true
  }

  force_destroy = var.force_destroy
  dynamic "logging" {
    for_each = var.logging == true ? [1] : []
    content {
      target_bucket = aws_s3_bucket.log_bucket[0].id
      target_prefix = "www-website/"
    }
  }
  policy = data.aws_iam_policy_document.s3_bucket_policy2[0].json
  tags   = var.tags

  website {
    redirect_all_requests_to = var.domain_name
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${var.domain_name}.s3.amazonaws.com"
    origin_id   = "s3-cloudfront"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  dynamic "logging_config" {
    for_each = var.logging == true ? [1] : []
    content {
      include_cookies = var.log_cookies
      bucket          = aws_s3_bucket.log_bucket[0].bucket_domain_name
      prefix          = "cloudfront/"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = local.domain_name

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    target_origin_id = "s3-cloudfront"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  dynamic "viewer_certificate" {
    for_each = local.default_certs
    content {
      cloudfront_default_certificate = true
    }
  }

  dynamic "viewer_certificate" {
    for_each = local.acm_certs
    content {
      acm_certificate_arn      = var.aws_certificate_arn
      ssl_support_method       = "sni-only"
      minimum_protocol_version = "TLSv1.2_2021"
    }
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 0
    response_page_path    = "/"
  }

  wait_for_deployment = false
  tags                = var.tags
}

resource "aws_cloudfront_distribution" "s3_distribution2" {
  count = var.deploy_redirect_bucket ? 1 : 0
  origin {
    domain_name = "www.${var.domain_name}.s3.amazonaws.com"
    origin_id   = "s3-cloudfront"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity2.cloudfront_access_identity_path
    }
  }

  dynamic "logging_config" {
    for_each = var.logging == true ? [1] : []
    content {
      include_cookies = var.log_cookies
      bucket          = aws_s3_bucket.log_bucket[0].bucket_domain_name
      prefix          = "cloudfront-www/"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    target_origin_id = "s3-cloudfront"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  dynamic "viewer_certificate" {
    for_each = local.default_certs
    content {
      cloudfront_default_certificate = true
    }
  }

  dynamic "viewer_certificate" {
    for_each = local.acm_certs
    content {
      acm_certificate_arn      = var.aws_certificate_arn
      ssl_support_method       = "sni-only"
      minimum_protocol_version = "TLSv1.2_2021"
    }
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 0
    response_page_path    = "/"
  }

  wait_for_deployment = false
  tags                = var.tags
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${var.domain_name}.s3.amazonaws.com"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity2" {
  comment = "access-identity-www.${var.domain_name}.s3.amazonaws.com"
}