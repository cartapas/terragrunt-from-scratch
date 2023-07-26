# CloudTrail Module

The AWS CloudTrail is an AWS services auditing tool. It saves a history of API calls for your AWS account, so that you can easily track unauthorized access to AWS account.

AWS CloudTrail is a web service that records activity made on your account and delivers log files to an Amazon S3 bucket. CloudTrail is mainly for auditing and CloudWatch is for performance monitoring. The CloudTrail helps to provide visibility into user activity by recording actions taken on your account. You can integrate CloudTrail with CloudWatch Logs to deliver data events captured by CloudTrail to a CloudWatch Logs log stream.

## Requirements

- [Terraform 1.1.3.](https://releases.hashicorp.com/terraform/1.1.3/)
- [Terragrunt 0.45.8](https://github.com/gruntwork-io/terragrunt/releases/tag/v0.45.8)

## Providers

- [hashicorp/aws 3.71.0](https://registry.terraform.io/providers/hashicorp/aws/3.71.0)

## Inputs

- environment
- projectname
- common_tags
- aws_region
- cloudtrail_s3_block_public_acls
- cloudtrail_s3_block_public_policy
- cloudtrail_s3_ignore_public_acls
- cloudtrail_s3_restrict_public_buckets

## Outputs

- N/A

## Resources created

- module.cloudtrail-main.aws_cloudtrail.cloudtrail -> name = "main-cloudtrail"
- module.cloudtrail-main.aws_s3_bucket.cloudtrail -> cloudtrail-189782652590-fork
- module.cloudtrail-main.aws_s3_bucket_policy.cloudtrail
- module.cloudtrail-main.aws_s3_bucket_public_access_block.cloudtrail_public_access_block