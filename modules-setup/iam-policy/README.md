# IAM Policy module

This module serves a purpose of distributing our custom IAM policies which can be attached to other resources then (IAM roles, users, etc.)

## Usage

```hcl
module "name_of_the_module" {
    source = "../../modules-setup/iam-policy"
}
```

By default module doesn't require any variables, but functionality can be overridden by using following:
- `policies` - will replace default list of policies included by the module
- `exclude_policies` - will exclude only certain policies from the `policies` variable

Defaults can be viewed by examining variables.tf file

## Requirements

- [Terraform 1.1.3.](https://releases.hashicorp.com/terraform/1.1.3/)
- [Terragrunt 0.45.8](https://github.com/gruntwork-io/terragrunt/releases/tag/v0.45.8)

## Providers

- [hashicorp/aws 3.71.0](https://registry.terraform.io/providers/hashicorp/aws/3.71.0)

## Inputs

- N/A

## Outputs

- Policy arn

## Resources created

- module.iam-policy.aws_iam_policy.policy["WizelineEC2StartBastionInstance"]
- module.iam-policy.aws_iam_policy.policy["WizelineMFApolicy"]
- module.iam-policy.aws_iam_policy.policy["WizelineResourceDeletionDeny"]
- module.iam-policy.aws_iam_policy.policy["WizelineDeveloperLocalS3Policy"]
