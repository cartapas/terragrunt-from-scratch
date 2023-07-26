variable "aws_region" {
  description = "AWS region configuration"
  type        = string
}
variable "projectname" {
  description = "Name of project inserted to Project-Tag and part of Name-Tag - default is withdrawn from variables in each environment"
  type        = string
}
variable "environment" {
  description = "Name of environment - default is withdrawn from terragrunt inputs"
  type        = string
}
variable "common_tags" {
  description = "Common tags from yaml file"
  type        = any
}
variable "cidr_block" {
  description = "CIDR block IP address for VPC"
}
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
}
variable "no_of_az" {
  description = "Number of AZ-s"
  type        = number
}