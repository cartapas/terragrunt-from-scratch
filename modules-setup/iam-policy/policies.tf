resource "aws_iam_policy" "policy" {
  for_each = toset(setsubtract(var.policies, var.exclude_policies))

  name   = each.key
  policy = file("${path.module}/policies/${each.key}.json")
}
