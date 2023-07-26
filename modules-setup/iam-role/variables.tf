variable "administrator_access" {
  description = "attachment for AdministratorAccess policy"
  type        = bool
}
variable "billing_access" {
  description = "attachment for Billing policy"
  type        = bool
}
variable "readonly_access" {
  description = "attachment for ReadOnly policy"
  type        = bool
}
variable "iam_user_password_change" {
  description = "attachment for IAMUserChangePassword policy"
  type        = bool
}
variable "iam_policy_account_id" {
  description = "Account ID tor root policy"
  type        = string
}
variable "role_name" {
  description = "Name for role"
  type        = string
}
variable "common_tags" {
  description = "Common tags from yaml file"
  type        = any
}