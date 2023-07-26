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
variable "non_compliant_sns_notification" {
  description = "Resive email with NON-COMPLIANT resource true or false"
  type        = bool
}
variable "managed_rules_name" {
  description = "For AWS Config managed rules, a predefined identifier, e.g IAM_PASSWORD_POLICY"
  type = map(object({
    name             = string
    input_parameters = any
  }))
}
variable "recorder_status_is_enabled" {
  description = "Whether the configuration recorder should be enabled or disabled."
  type        = bool
}
variable "include_global_resource_types" {
  description = "Specifies whether AWS Config includes all supported types of global resources with the resources that it records."
  type        = bool
}
variable "config_s3_block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
}
variable "config_s3_block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
}
variable "config_s3_ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for buckets in this account."
  type        = bool
}
variable "config_s3_restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for buckets in this account."
  type        = bool
}
variable "sns_arn" {
  description = "The Amazon Resource Name (ARN) associated of the target"
  type        = string
}