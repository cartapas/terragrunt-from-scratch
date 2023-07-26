include {
  path = find_in_parent_folders()
}

locals {
  aws_region     = "us-east-1"
  environment    = yamldecode(file("common_tags.yaml"))["Environment"]
  projectname    = yamldecode(file("common_tags.yaml"))["Project"]
  common_tags    = yamldecode(file("common_tags.yaml"))
  
  # Atlantis environment_variables
  bootstrap_github_app    = false
}

inputs = {
  aws_region     = local.aws_region
  environment    = local.environment
  projectname    = local.projectname
  common_tags    = local.common_tags

  # Atlantis environment_variables
  bootstrap_github_app    = local.bootstrap_github_app
}