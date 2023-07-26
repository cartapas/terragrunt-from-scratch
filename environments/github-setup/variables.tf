variable "aws_region" {
  description = "AWS region configuration"
  type        = string
}
variable "projectname" {
  description = "Name of project inserted to Project-Tag and part of Name-Tag - default is withdrawn from variables in each environment"
  type        = string
}
variable "common_tags" {
  description = "Common tags from yaml file"
  type        = any
}
variable "github_push_team" {
  description = "GitHub group with a Writer role"
  type        = string
}
variable "github_admin_team" {
  description = "GitHub group with an Admin role"
  type        = string
}