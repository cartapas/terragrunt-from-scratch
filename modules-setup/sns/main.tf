resource "aws_sns_topic" "server_admin" {
  name = "server-admin"
  tags = merge(
    var.common_tags
  )
}

resource "aws_sns_topic_subscription" "email_subscription" {
  provider = aws

  topic_arn                       = aws_sns_topic.server_admin.arn
  protocol                        = "email"
  endpoint                        = var.email_address
  confirmation_timeout_in_minutes = 10
  endpoint_auto_confirms          = false
}
