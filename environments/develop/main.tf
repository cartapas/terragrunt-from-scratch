module "network" {
  source = "../../modules/network"

  environment = var.environment
  projectname = var.projectname
  aws_region  = var.aws_region
  common_tags = var.common_tags

  single_nat_gateway = true
  cidr_block         = "10.0.0.0/16"
  no_of_az           = 3
}