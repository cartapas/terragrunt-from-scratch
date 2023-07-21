provider "github" {}

terraform {
  # branch_protections_v3 are broken in >= 5.3
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 4.20, < 6.0"
    }
  }

  required_version = "~> 1.1.3"
}
