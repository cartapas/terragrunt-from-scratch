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
variable "cloudtrail_s3_block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
}
variable "cloudtrail_s3_block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
}
variable "cloudtrail_s3_ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for buckets in this account."
  type        = bool
}
variable "cloudtrail_s3_restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for buckets in this account."
  type        = bool
}