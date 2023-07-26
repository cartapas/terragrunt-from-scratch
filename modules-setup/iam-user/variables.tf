variable "groups" {
  description = "IAM Group name"
  type        = list(string)
}
variable "name" {
  description = "IAM User name"
  type        = string
}
variable "common_tags" {
  description = "Common tags from yaml file"
  type        = any
}