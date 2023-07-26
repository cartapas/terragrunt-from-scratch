data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "main-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  is_multi_region_trail         = true
  depends_on = [
    aws_s3_bucket_policy.cloudtrail,
    aws_s3_bucket.cloudtrail
  ]
  tags = merge(
    var.common_tags
  )
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = "cloudtrail-${data.aws_caller_identity.current.id}-${var.projectname}"
  force_destroy = true
  tags = merge(
    var.common_tags
  )

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_public_access_block" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = var.cloudtrail_s3_block_public_acls
  block_public_policy     = var.cloudtrail_s3_block_public_policy
  ignore_public_acls      = var.cloudtrail_s3_ignore_public_acls
  restrict_public_buckets = var.cloudtrail_s3_restrict_public_buckets

  depends_on = [
    aws_s3_bucket_policy.cloudtrail
  ]
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.cloudtrail.id}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.cloudtrail.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
