include {
  path = find_in_parent_folders()
}

locals {
  aws_region    = "us-east-1"
  environment   = yamldecode(file("common_tags.yaml"))["Environment"]
  projectname   = yamldecode(file("common_tags.yaml"))["Project"]
  email_address = yamldecode(file("common_tags.yaml"))["Contact"]
  common_tags   = yamldecode(file("common_tags.yaml"))
}

inputs = {
  aws_region    = local.aws_region
  environment   = local.environment
  projectname   = local.projectname
  email_address = local.email_address
  common_tags   = local.common_tags
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
#    bucket          = "terraform-${get_aws_account_id()}-${local.aws_region}-${local.environment}"
#    key             = "${path_relative_to_include()}/terraform.tfstate"
#    region          = local.aws_region
#    encrypt         = true
#    dynamodb_table  = "terraform-${get_aws_account_id()}-${local.aws_region}-${local.environment}"
#    
#    s3_bucket_tags = {
#      Project       = "${local.projectname}"
#      Environment   = "${local.environment}"
#    }
#    dynamodb_table_tags = {
#      Project       = "${local.projectname}"
#      Environment   = "${local.environment}"
#    }
#  }
#}