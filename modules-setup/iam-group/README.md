# IAM Group Module

Configure the different default groups for Developers, Project Managers, Admins and All users with the previously created policies.

## Requirements

- [Terraform 1.1.3.](https://releases.hashicorp.com/terraform/1.1.3/)
- [Terragrunt 0.45.8](https://github.com/gruntwork-io/terragrunt/releases/tag/v0.45.8)

## Providers

- [hashicorp/aws 3.71.0](https://registry.terraform.io/providers/hashicorp/aws/3.71.0)

## Inputs

- name
- policy_arn

## Outputs

- Group name.

## Resources created

- module.iam-AllUsers-group.aws_iam_group.group -> name = "AllUsers"
- module.iam-AllUsers-group.aws_iam_group_policy_attachment.policy-attach["arn:aws:iam::189782652590:policy/WizelineMFApolicy"]
- module.iam-Developers-group.aws_iam_group.group -> name = "Developers"
- module.iam-Developers-group.aws_iam_group_policy_attachment.policy-attach["arn:aws:iam::189782652590:policy/WizelineDeveloperLocalS3Policy"]
- module.iam-Developers-group.aws_iam_group_policy_attachment.policy-attach["arn:aws:iam::aws:policy/AmazonEC2FullAccess"]
- module.iam-Developers-group.aws_iam_group_policy_attachment.policy-attach["arn:aws:iam::aws:policy/IAMUserChangePassword"]
- module.iam-Developers-group.aws_iam_group_policy_attachment.policy-attach["arn:aws:iam::aws:policy/ReadOnlyAccess"]
- module.iam-Admins-group.aws_iam_group.group -> name = "Admins"
- module.iam-Admins-group.aws_iam_group_policy_attachment.policy-attach["arn:aws:iam::189782652590:policy/WizelineResourceDeletionDeny"]
- module.iam-Admins-group.aws_iam_group_policy_attachment.policy-attach["arn:aws:iam::aws:policy/AdministratorAccess"]
- module.iam-ProjectManagers-group.aws_iam_group.group -> name = "ProjectManagers"
- module.iam-ProjectManagers-group.aws_iam_group_policy_attachment.policy-attach["arn:aws:iam::aws:policy/ReadOnlyAccess"]
- module.iam-ProjectManagers-group.aws_iam_group_policy_attachment.policy-attach["arn:aws:iam::aws:policy/job-function/Billing"]