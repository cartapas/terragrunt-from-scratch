resource "aws_iam_role" "infinum_iam_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.task_assume.json
  tags = merge(
    var.common_tags
  )
}
resource "aws_iam_role_policy_attachment" "administrator_access" {
  count      = var.administrator_access == true ? 1 : 0
  role       = aws_iam_role.infinum_iam_role.id
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
resource "aws_iam_role_policy_attachment" "billing_access" {
  count      = var.billing_access == true ? 1 : 0
  role       = aws_iam_role.infinum_iam_role.id
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}
resource "aws_iam_role_policy_attachment" "iam_user_password_change" {
  count      = var.iam_user_password_change == true ? 1 : 0
  role       = aws_iam_role.infinum_iam_role.id
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}
resource "aws_iam_role_policy_attachment" "read_only_access" {
  count      = var.readonly_access == true ? 1 : 0
  role       = aws_iam_role.infinum_iam_role.id
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}