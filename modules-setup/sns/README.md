# SNS Module

Enabling SNS notifications to the server admin email configured in the common_tags file.

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
- email_address

## Outputs

- server_admin_arn -> aws_sns_topic.server_admin.arn

## Resources created

- module.sns.aws_sns_topic.server_admin -> name = "server-admin"
- module.sns.aws_sns_topic_subscription.email_subscription -> endpoint = "carlos.tapasco@wizeline.com"