variable "policies" {
  description = "List of the policies that should be included"
  type        = list(any)
  default = [
    "CustomEC2StartBastionInstance",
    "CustomResourceDeletionDeny",
    "CustomMFApolicy",
    "CustomDeveloperLocalS3Policy"
  ]
}

variable "exclude_policies" {
  description = "List of the policies that should be excluded"
  type        = list(any)
  default     = []
}
