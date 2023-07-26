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
variable "bootstrap_github_app" {
  description = "Flag to configure Atlantis to bootstrap a new Github App"
  type        = bool
}