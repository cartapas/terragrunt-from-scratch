include {
  path = find_in_parent_folders()
}

locals {
  aws_region          = "us-east-1"
  projectname         = yamldecode(file("common_tags.yaml"))["Project"]
  common_tags         = yamldecode(file("common_tags.yaml"))
  github_push_team    = "XXX"
  github_admin_team   = "XXX"
}

inputs = {
  aws_region          = local.aws_region
  projectname         = local.projectname
  common_tags         = local.common_tags
  github_push_team    = local.github_push_team
  github_admin_team   = local.github_admin_team
}

#remote_state {
#  backend = "s3"
#
#  generate = {
#    path      = "backend.tf"
#    if_exists = "overwrite_terragrunt"
#  }
#
#  config = {
#    bucket          = "terraform-${get_aws_account_id()}-${local.aws_region}-github"
#    key             = "${local.projectname}/terraform.tfstate"
#    region          = local.aws_region
#    encrypt         = true
#    dynamodb_table  = "terraform-${get_aws_account_id()}-${local.aws_region}-github-${local.projectname}"
#  }
#}