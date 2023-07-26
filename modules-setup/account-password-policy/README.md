# Account Password Policy Module

Configuring the account password policy.

## Requirements

- [Terraform 1.1.3.](https://releases.hashicorp.com/terraform/1.1.3/)
- [Terragrunt 0.45.8](https://github.com/gruntwork-io/terragrunt/releases/tag/v0.45.8)

## Providers

- [hashicorp/aws 3.71.0](https://registry.terraform.io/providers/hashicorp/aws/3.71.0)

## Inputs

- minimum_password_length
- require_lowercase_characters
- require_numbers
- require_uppercase_characters
- require_symbols
- allow_users_to_change_password
- hard_expiry
- password_reuse_prevention
- max_password_age

## Outputs

- N/A

## Resources created

- module.account-password-policy.aws_iam_account_password_policy.iam_account_password_policy

## Resources in the AWS Console

![image](https://github.com/Porsche-Digital-Inc/terraform-pdvault/assets/101673365/f989b04e-4ff8-4b04-a37d-10384d7d62ef)
