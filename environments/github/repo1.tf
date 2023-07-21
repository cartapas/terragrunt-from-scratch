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
        #contexts = ["ci/travis"]
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