# GitHub Module

The current environment allows the creation of private repositories with at least an admin team attached to it. The main/master branch is our source of truth.

Branches:
- main/master -> Production-ready code.
- staging -> A replica of the production env.
- develop -> Used for new features/solve bugs and all that implementation entails.
- other development branches -> short-lived; merged into the develop branch.

This workflow uses three branches to record the history of the project. The *main/master* branch stores the official release history and is connected to production; the *staging* branch is a replicate of production and allows us to test all the new functionality/fixes in a prerelease state before the official release.

Finally, the *develop* branch serves as an integration branch for features or fixes. It's also convenient to mention that all the releases are tagged with a version number.

- [Directory Structure](#directory-structure)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Example](#example)
- [Obtained Configuration](#obtained-configuration)

## Directory Structure

The initial directory estructure includes the following:
- environments/
  - **github/** Folder with configuration per every environment such as develop, staging, production, github, aws-configuration, among others.
    - **common_tags.yaml.** Common variables required along the module for tagging or creating resources.
    - **provider.tf.** GitHub, AWS and Terraform providers configuration.
    - **README.md.** Module documentation.
    - **repo1.tf.** Definitions of the repo1. Copy this file to create different repositories with its own definition
    - **terragrunt.hcl** Definition of the environment variables passed to Terraform and remote state configuration.
    - **variables.tf.** Variables passed from Terragrunt to Terraform.
- .terraform-version
- .terragrunt-version
- README.md
- **terragrunt.hcl.** Extra arguments being passed to Terraform.

## Requirements

- [Terraform 1.1.3.](https://releases.hashicorp.com/terraform/1.1.3/)
- [Terrarunt 0.45.8](https://github.com/gruntwork-io/terragrunt/releases/tag/v0.45.8)

## Provriders

- [Terragrunt 0.45.8](https://github.com/gruntwork-io/terragrunt/releases/tag/v0.45.8)

## Modules

- [Mineiros GitHub 0.18.0](https://github.com/mineiros-io/terraform-github-repository/releases/tag/v0.18.0)

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

## Example
```hcl
module "repository" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.18.0"

  # General
  name               = "js-${var.projectname}-repo1"
  description        = "Next-JS Admin Front-End repository."

  # General - Default branch
  default_branch = "main"

  # General - Features
  has_wiki           = true
  has_issues         = true
  has_projects       = false
  

  # General - Pull Requests
  allow_merge_commit     = true
  allow_squash_merge     = true
  allow_rebase_merge     = false
  allow_auto_merge       = false
  delete_branch_on_merge = true

  # General - Danger Zone
  visibility         = "private"
  
  # Collaboratos and teams - Manage access
  # Role Write
  push_teams = [var.github_push_team]
  # Role Admin
  admin_teams = [var.github_admin_team]

  # Extended configuration
  auto_init          = true

  # Code - Branches
  branches = [
    {
        name = "develop"
    },
    {
        name = "staging"
    },
    {
        name = "main"
    }
  ]
  
  # Branches - Branch protection rules
  branch_protections_v4 = [
    {
      pattern                         = "main"
      # Protect matching branches
      required_pull_request_reviews = {
          # Dismiss stale pull request approvals when new commits are pushed 
        dismiss_stale_reviews           = false
        require_code_owner_reviews      = false
        required_approving_review_count = 1
      }
      required_status_checks = {
          # Require branches to be up to date before merging
        strict   = true
      }
      require_conversation_resolution = false
      require_signed_commits          = false
        # Do not allow bypassing the above settings
      enforce_admins                  = true
      
      # Rules applied to everyone including administrators
      allows_force_pushes = true
    }
  ]

  # Secrets and variables
    # Adding the AWS programmatic access when being defined 
  encrypted_secrets = {
    AWS_ACCESS_KEY          = ""
    AWS_SECRET_ACCESS_KEY   = ""
  }
}
```

## Resources created

- module.repository.github_actions_secret.repository_secret["AWS_ACCESS_KEY"] will be created
- module.repository.github_actions_secret.repository_secret["AWS_SECRET_ACCESS_KEY"] will be created
- module.repository.github_branch.branch["develop"] will be created
- module.repository.github_branch.branch["main"] will be created
- module.repository.github_branch.branch["staging"] will be created
- module.repository.github_branch_default.default[0] will be created
- module.repository.github_branch_protection.branch_protection["main"] will be created
- module.repository.github_issue_label.label["bug"] will be created
- module.repository.github_issue_label.label["documentation"] will be created
- module.repository.github_issue_label.label["duplicate"] will be created
- module.repository.github_issue_label.label["enhancement"] will be created
- module.repository.github_issue_label.label["good first issue"] will be created
- module.repository.github_issue_label.label["help wanted"] will be created
- module.repository.github_issue_label.label["invalid"] will be created
- module.repository.github_issue_label.label["question"] will be created
- module.repository.github_issue_label.label["wontfix"] will be created
- module.repository.github_repository.repository will be created
- module.repository.github_team_repository.team_repository_by_slug["push_team"] will be created
- module.repository.github_team_repository.team_repository_by_slug["admin_team"] will be created