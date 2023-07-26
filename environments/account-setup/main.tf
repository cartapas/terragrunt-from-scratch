module "cloudtrail-main" {
  source = "../../modules-setup/cloudtrail-main"

  environment = var.environment
  projectname = var.projectname
  common_tags = var.common_tags
  aws_region  = var.aws_region

  cloudtrail_s3_block_public_acls       = true
  cloudtrail_s3_block_public_policy     = true
  cloudtrail_s3_ignore_public_acls      = true
  cloudtrail_s3_restrict_public_buckets = true
}


module "sns" {
  source = "../../modules-setup/sns"

  environment = var.environment
  projectname = var.projectname
  common_tags = var.common_tags
  aws_region  = var.aws_region

  email_address = var.email_address
}

module "account-password-policy" {
  source = "../../modules-setup/account-password-policy"

  minimum_password_length        = 10
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = false
  allow_users_to_change_password = true
  hard_expiry                    = false
  password_reuse_prevention      = 5
  max_password_age               = null
}

module "aws-config" {
  source = "../../modules-setup/AWSconfig"

  aws_region  = var.aws_region
  environment = var.environment
  projectname = var.projectname
  common_tags = var.common_tags

  non_compliant_sns_notification = true
  managed_rules_name = {
    DB_INSTANCE_BACKUP_ENABLED = {
      name             = "DB_INSTANCE_BACKUP_ENABLED"
      input_parameters = {}
    },
    EC2_SECURITY_GROUP_ATTACHED_TO_ENI = {
      name             = "EC2_SECURITY_GROUP_ATTACHED_TO_ENI"
      input_parameters = {}
    },
    EIP_ATTACHED = {
      name             = "EIP_ATTACHED"
      input_parameters = {}
    },
    ELASTICACHE_REDIS_CLUSTER_AUTOMATIC_BACKUP_CHECK = {
      name             = "ELASTICACHE_REDIS_CLUSTER_AUTOMATIC_BACKUP_CHECK"
      input_parameters = {}
    },
    IAM_PASSWORD_POLICY = {
      name             = "IAM_PASSWORD_POLICY"
      input_parameters = {}
    },
    IAM_ROOT_ACCESS_KEY_CHECK = {
      name             = "IAM_ROOT_ACCESS_KEY_CHECK"
      input_parameters = {}
    },
    IAM_USER_NO_POLICIES_CHECK = {
      name             = "IAM_USER_NO_POLICIES_CHECK"
      input_parameters = {}
    },
    MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS = {
      name             = "MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS"
      input_parameters = {}
    },
    MULTI_REGION_CLOUD_TRAIL_ENABLED = {
      name             = "MULTI_REGION_CLOUD_TRAIL_ENABLED"
      input_parameters = {}
    },
    RDS_INSTANCE_DELETION_PROTECTION_ENABLED = {
      name             = "RDS_INSTANCE_DELETION_PROTECTION_ENABLED"
      input_parameters = {}
    },
    RDS_INSTANCE_PUBLIC_ACCESS_CHECK = {
      name             = "RDS_INSTANCE_PUBLIC_ACCESS_CHECK"
      input_parameters = {}
    },
    RDS_SNAPSHOTS_PUBLIC_PROHIBITED = {
      name             = "RDS_SNAPSHOTS_PUBLIC_PROHIBITED"
      input_parameters = {}
    },
    ROOT_ACCOUNT_HARDWARE_MFA_ENABLED = {
      name             = "ROOT_ACCOUNT_HARDWARE_MFA_ENABLED"
      input_parameters = {}
    },
    ROOT_ACCOUNT_MFA_ENABLED = {
      name             = "ROOT_ACCOUNT_MFA_ENABLED"
      input_parameters = {}
    },
    S3_BUCKET_VERSIONING_ENABLED = {
      name             = "S3_BUCKET_VERSIONING_ENABLED"
      input_parameters = {}
    },
    VPC_SG_OPEN_ONLY_TO_AUTHORIZED_PORTS = {
      name             = "VPC_SG_OPEN_ONLY_TO_AUTHORIZED_PORTS"
      input_parameters = { authorizedTcpPorts = "80,443,22" }
    },
    VPC_DEFAULT_SECURITY_GROUP_CLOSED = {
      name             = "VPC_DEFAULT_SECURITY_GROUP_CLOSED"
      input_parameters = {}
    },
    IAM_USER_UNUSED_CREDENTIALS_CHECK = {
      name             = "IAM_USER_UNUSED_CREDENTIALS_CHECK"
      input_parameters = { maxCredentialUsageAge = "366" }
    },
    ACCESS_KEYS_ROTATED = {
      name             = "ACCESS_KEYS_ROTATED"
      input_parameters = { maxAccessKeyAge = "366" }
    }
  }
  recorder_status_is_enabled        = true
  include_global_resource_types     = true
  config_s3_block_public_acls       = true
  config_s3_block_public_policy     = true
  config_s3_ignore_public_acls      = true
  config_s3_restrict_public_buckets = true

  sns_arn = module.sns.server_admin_arn
}

module "iam-policy" {
  source = "../../modules-setup/iam-policy"
}

/*module "awx-iam-user" {
  source = "../../modules-admin/iam-user"

  common_tags = var.common_tags

  name = "awx"
  groups = [
    module.iam-Admins-group.name,
    module.iam-AllUsers-group.name
  ]
}*/

module "iam-AllUsers-group" {
  source = "../../modules-setup/iam-group"

  name = "AllUsers"
  policy_arn = [
    module.iam-policy.policy_arn["CustomMFApolicy"]
  ]
}

module "iam-Developers-group" {
  source = "../../modules-setup/iam-group"

  name = "Developers"
  policy_arn = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/IAMUserChangePassword",
    module.iam-policy.policy_arn["CustomDeveloperLocalS3Policy"]
  ]
}

module "iam-Admins-group" {
  source = "../../modules-setup/iam-group"

  name = "Admins"
  policy_arn = [
    module.iam-policy.policy_arn["CustomResourceDeletionDeny"],
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}

module "iam-ProjectManagers-group" {
  source = "../../modules-setup/iam-group"

  name = "ProjectManagers"
  policy_arn = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/job-function/Billing"
  ]
}