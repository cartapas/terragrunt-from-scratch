# Terragrunt from scratch

This project was created to document the Terragrunt/Terraform project creation from scratch.

- [Requirements](#requirements)
- [Directory Structure](#directory-structure)
- [AWS Credentials](#aws-credentials)
- [GitHub Credentials](#github-credentials)

## Requirements

The code in this project was tested using the following tooling version:
- [Terraform 1.1.3.](https://releases.hashicorp.com/terraform/1.1.3/)
- [Terragrunt 0.45.8](https://github.com/gruntwork-io/terragrunt/releases/tag/v0.45.8)

## Directory Structure

The initial directory estructure includes the following:
- **environments/**
  - **account-setup/**
    - **common_tags.yaml.** Common variables required along the module for tagging or creating resources.
    - **main.tf.** Module calling with the custom variables from environment.
    - **provider.tf.** AWS and Terraform providers configuration.
    - **terragrunt.hcl.** Definition of the environment variables passed to Terragrunt and remote state configuration.
    - **variables.tf.** Variables passed from Terragrunt to Terraform according to the environment.
  - **develop/**
    - **common_tags.yaml.** Common variables required along the module for tagging or creating resources.
    - **data.tf.** Data resources required in the environment
    - **main.tf.** Module calling with the custom variables from environment.
    - **provider.tf.** AWS and Terraform providers configuration.
    - **terragrunt.hcl.** Definition of the environment variables passed to Terragrunt and remote state configuration.
    - **variables.tf.** Variables passed from Terragrunt to Terraform according to the environment.
  - **github-setup/** Folder with configuration per every environment such as develop, staging, production, github, aws-configuration, among others.
    - **common_tags.yaml.** Common variables required along the module for tagging or creating resources.
    - **provider.tf.** GitHub, AWS and Terraform providers configuration.
    - **README.md.** Module documentation.
    - **repo1.tf.** Definitions of the repo1. Copy this file to create different repositories with its own definitions.s
    - **terragrunt.hcl** Definition of the environment variables passed to Terragrunt and remote state configuration.
    - **variables.tf.** Variables passed from Terragrunt to Terraform according to the environment.
- **modules/**
  - **network/**
    - outputs.
    - provider.
    - README.md
    - variables.tf
    - vpc.tf
- **modules-setup/**
  - account-password-policy
  - AWSconfig
  - cloudtrail-main
  - iam-group
  - iam-policy
  - iam-role
  - iam-user
  - sns
- .gitignore
- .terraform-version
- .terragrunt-version
- README.md
- **terragrunt.hcl.** Extra arguments being passed to Terraform.

## AWS Credentials

Configuring the **AWS Vault** tool to securely store and access AWS credentials in your development environment.

Choose the prefered method for install aws-vault from https://github.com/99designs/aws-vault#installing

Once installed, listing the current stored credentials.
```
$ aws-vault list
Profile                  Credentials              Sessions                         
=======                  ===========              ========                                                        
testing                  testing                  sts.GetSessionToken:-165h22m34s
```

If you have AWS credentials for programmatic access, adding the new key pair to the vault. The profile name will be **terragrunt**.
```
$ aws-vault add terragrunt
  Enter Access Key ID: AKIASXXXXXXXGI7AYYYA
  Enter Secret Access Key: 
  Added credentials to profile "terragrunt" in vault

Listing again the stored credentials
$ aws-vault list
Profile                  Credentials              Sessions                         
=======                  ===========              ========                         
testing                  testing                  sts.GetSessionToken:-165h23m22s  
terragrunt               terragrunt               -
```

After this, you can run several commands, for example, a terragrunt plan:
```
$ aws-vault exec marqued2 --no-session -- terragrunt plan
```
## GitHub Credentials

In order to use the GitHub API, create a Personal Access token (PAT) with the following permissions:
```
 repo Full control of private repositories
 admin:org Full control of orgs and teams, read and write org projects
 delete_repo Delete repositories
```
Pass the parameters with the through the OS ENVIRONMENT vars.
```
$ export GITHUB_TOKEN="XXXXXXXXX"
$ export GITHUB_OWNER="Porsche-Digital-Inc"
```

## Environments deployment

Deploying every environment and its modules in the following order:

1. **github-setup.** Allows the creation of private repositories with at least an admin team attached to it. The main/master branch is our source of truth.
2. **account-setup.** Use this environment to customize some AWS account parameters such as:
  1. **AWS CloudTrail.** AWS services auditing tool. It saves a history of API calls for your AWS account, so that you can easily track unauthorized access to AWS account.
  2. **AWS SNS.** Enabling SNS notifications to the server admin email configured in the common_tags file.
  3. **AWS Account Password Policy.** Define password strength specifications.
  4. **AWS Config.** Several customizations regarding the AWS Config service. Some rules included:
    - ACCESS_KEYS_ROTATED
    - DB_INSTANCE_BACKUP_ENABLED
    - IAM_PASSWORD_POLICY
    - MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS
    - RDS_INSTANCE_DELETION_PROTECTION_ENABLED
    - RDS_INSTANCE_PUBLIC_ACCESS_CHECK
    - S3_BUCKET_VERSIONING_ENABLED
  5. **AWS IAM Policy.** Its purpose is distributing the custom IAM policies which can be attached to other resources then (IAM roles, users, etc.)
  6. **IAM User Groups.**
    - All users.
    - Developers.
    - Admin.
    - Project Managers.
3. **develop.** Environment used for new features/solve bugs and all that implementation entails.
  1. **network.** VPC, subnets, Internet Gateway, NAT Gateway, Elastic IP, Routing Tables and Internal subdomain zone definitions.