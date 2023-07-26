
resource "aws_iam_user" "user" {
  name = lower(var.name)
  tags = merge(
    var.common_tags
  )
}

resource "aws_iam_group_membership" "team" {
  for_each = toset(var.groups)
  name = each.value

  users = [
    aws_iam_user.user.name
  ]

  group = each.value
}