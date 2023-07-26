resource "aws_config_delivery_channel" "config_delivery_channel" {
  name           = "${var.projectname}-${var.environment}-config-delivery-channel"
  s3_bucket_name = aws_s3_bucket.s3_config_bucket.bucket
  depends_on     = [aws_config_configuration_recorder.config_configuration_recorder]
}

resource "aws_s3_bucket" "s3_config_bucket" {
  bucket        = lower("${var.projectname}-${var.environment}-${var.aws_region}-s3-config")
  force_destroy = true

  tags = merge(
    var.common_tags
  )

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_config_public_access_block" {
  bucket = aws_s3_bucket.s3_config_bucket.id

  block_public_acls       = var.config_s3_block_public_acls
  block_public_policy     = var.config_s3_block_public_policy
  ignore_public_acls      = var.config_s3_ignore_public_acls
  restrict_public_buckets = var.config_s3_restrict_public_buckets
}

resource "aws_config_configuration_recorder" "config_configuration_recorder" {
  name     = "${var.projectname}-${var.environment}-config-configuration-recorder"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = var.include_global_resource_types
  }
}

resource "aws_config_configuration_recorder_status" "config_configuration_recorder_status" {
  name       = aws_config_configuration_recorder.config_configuration_recorder.name
  is_enabled = var.recorder_status_is_enabled

  depends_on = [aws_config_delivery_channel.config_delivery_channel]
}

resource "aws_config_config_rule" "managed_rules" {
  for_each = var.managed_rules_name
  name     = each.value.name

  source {
    owner             = "AWS"
    source_identifier = each.value.name
  }

  input_parameters = length(each.value.input_parameters) > 0 ? jsonencode(each.value.input_parameters) : null

  depends_on = [aws_config_configuration_recorder.config_configuration_recorder]

  tags = merge(
    var.common_tags
  )
}

resource "aws_iam_role" "config_role" {
  name               = "${var.projectname}-${var.environment}-config-role"
  assume_role_policy = data.aws_iam_policy_document.config_assume.json
  tags = merge(
    var.common_tags
  )
}

resource "aws_iam_role_policy" "config_policy" {
  name   = "${var.projectname}-${var.environment}-config-policy"
  role   = aws_iam_role.config_role.id
  policy = data.aws_iam_policy_document.config_permissions.json
}

resource "aws_iam_role_policy" "s3_config_policy" {
  name   = "${var.projectname}-${var.environment}-s3-config-policy"
  role   = aws_iam_role.config_role.id
  policy = data.aws_iam_policy_document.s3_config_permissions.json
}

resource "aws_iam_role_policy_attachment" "a" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_cloudwatch_event_rule" "config_event_rule" {
  count       = var.non_compliant_sns_notification == true ? 1 : 0
  name        = "capture-AWS-config-NON_COMPLIANT"
  description = "Capture each AWS NON_COMPLIANT resource from AWS Config rules"

  event_pattern = <<EOF
{
  "source": [
    "aws.config"
  ],
  "detail-type": [
    "Config Rules Compliance Change"
  ],
  "detail": {
    "messageType": [
      "ComplianceChangeNotification"
    ],
    "newEvaluationResult": {
      "complianceType": [
        "NON_COMPLIANT"
      ]
    }
  }
}
EOF
  tags = merge(
    var.common_tags
  )
}

resource "aws_cloudwatch_event_target" "sns" {
  count = var.non_compliant_sns_notification == true ? 1 : 0
  rule  = aws_cloudwatch_event_rule.config_event_rule[count.index].name
  arn   = var.sns_arn

  input_transformer {
    input_paths = {
      "awsRegion" : "$.detail.awsRegion",
      "resourceId" : "$.detail.resourceId",
      "awsAccountId" : "$.detail.awsAccountId",
      "compliance" : "$.detail.newEvaluationResult.complianceType",
      "rule" : "$.detail.configRuleName",
      "time" : "$.detail.newEvaluationResult.resultRecordedTime",
      "resourceType" : "$.detail.resourceType"
    }
    input_template = "\" ${var.projectname} - On <time> AWS Config rule <rule> evaluated the <resourceType> with Id <resourceId> in the account <awsAccountId> - ${var.projectname} region <awsRegion> as <compliance> For more details open the AWS Config console at https://console.aws.amazon.com/config/home?region=<awsRegion>#/timeline/<resourceType>/<resourceId>/configuration\""
  }
}