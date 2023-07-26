resource "aws_iam_group" "group" {
  name = var.name
  path = "/"
}

resource "aws_iam_group_policy_attachment" "policy-attach" {
  for_each   = toset(var.policy_arn)
  group      = aws_iam_group.group.name
  policy_arn = each.value
}