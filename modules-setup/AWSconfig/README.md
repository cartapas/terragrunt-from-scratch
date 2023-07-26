# AWS Config Module

The current module is in charge of several customizations regarding the AWS Config service. Some main resources:

- *DeliveryChannel*. The channel through which AWS Config delivers notifications and updated configuration states.
- *ConfigurationRecorder*. Records configuration changes to specified resource types.
- *ConfigRule*. AWS Config rules evaluate the configuration settings of your AWS resources.

## Requirements

- [Terraform 1.1.3.](https://releases.hashicorp.com/terraform/1.1.3/)
- [Terragrunt 0.45.8](https://github.com/gruntwork-io/terragrunt/releases/tag/v0.45.8)

## Providers

- [hashicorp/aws 3.71.0](https://registry.terraform.io/providers/hashicorp/aws/3.71.0)

## Inputs

- aws_region
- environment
- projectname
- common_tags

## Outputs

- N/A

## Resources created

- module.aws-config.aws_cloudwatch_event_rule.config_event_rule[0] -> name = "capture-AWS-config-NON_COMPLIANT"
  - When a resource configuration changes, an event is generated and a message is sent to the SNS target configured. AWS CloudWatch -> Events -> Rules.
- module.aws-config.aws_cloudwatch_event_target.sns[0] -> sns = "server-admin"
  - SNS target configured to receive the formatted notification on event generation. AWS CloudWatch -> Events -> Rules -> Targets.
- module.aws-config.aws_config_config_rule.managed_rules["ACCESS_KEYS_ROTATED"] -> maxAccessKeyAge = "366"
  - Checks whether the active access keys are rotated within the number of days specified in maxAccessKeyAge. The rule is non-compliant if the access keys have not been rotated for more than maxAccessKeyAge number of days.
  - Maximum number of days without rotation. Default 90.
- module.aws-config.aws_config_config_rule.managed_rules["DB_INSTANCE_BACKUP_ENABLED"] -> N/A
  - Checks whether RDS DB instances have backups enabled. Parameters:
    - *backupRetentionPeriod*. Retention period for backups.
    - *backupRetentionMinimum*. Minimum retention period for backups.
    - *preferredBackupWindow*. Time range in which backups are created.
    - *checkReadReplicas*. Checks whether RDS DB instances have backups enabled for read replicas.
- module.aws-config.aws_config_config_rule.managed_rules["EC2_SECURITY_GROUP_ATTACHED_TO_ENI"] -> N/A
  - Checks if non-default security groups are attached to elastic network interfaces. The rule is NON_COMPLIANT if the security group is not associated with a network interface.
- module.aws-config.aws_config_config_rule.managed_rules["EIP_ATTACHED"] -> N/A
  - Checks if all Elastic IP addresses that are allocated to an AWS account are attached to EC2 instances or in-use elastic network interfaces. The rule is NON_COMPLIANT if the 'AssociationId' is null for the Elastic IP address.
- module.aws-config.aws_config_config_rule.managed_rules["ELASTICACHE_REDIS_CLUSTER_AUTOMATIC_BACKUP_CHECK"] -> N/A
  - The rule is NON_COMPLIANT if SnapshotRetentionLimit for Redis cluster is less than the SnapshotRetentionPeriod parameter, i.e from 0 to 15 as the default is 15. Parameters:
    - *snapshotRetentionPeriod*. Minimum snapshot retention period in days for Redis cluster. Default is 15 days.
- module.aws-config.aws_config_config_rule.managed_rules["IAM_PASSWORD_POLICY"] -> N/A
  - Checks if the account password policy for AWS Identity and Access Management (IAM) users meets the specified requirements indicated in the parameters. The rule is NON_COMPLIANT if the account password policy does not meet the specified requirements. Parameters:
    - *RequireUppercaseCharacters*. Require at least one uppercase character in password.
    - *RequireLowercaseCharacters*. boolean	-	Require at least one lowercase character in password.
    - *RequireSymbols*. Require at least one symbol in password.
    - *RequireNumbers*. Require at least one number in password.
    - *MinimumPasswordLength**. Password minimum length.
    - *PasswordReusePrevention*. Number of passwords before allowing reuse.
    - *MaxPasswordAge*. Number of days before password expiration.
- module.aws-config.aws_config_config_rule.managed_rules["IAM_ROOT_ACCESS_KEY_CHECK"] -> N/A
  - Checks whether the root user access key is available. The rule is compliant if the user access key does not exist.
- module.aws-config.aws_config_config_rule.managed_rules["IAM_USER_NO_POLICIES_CHECK"] -> N/A
  - Checks if none of your AWS Identity and Access Management (IAM) users have policies attached. IAM users must inherit permissions from IAM groups or roles. The rule is NON_COMPLIANT if there is at least one IAM user with policies attached.
- module.aws-config.aws_config_config_rule.managed_rules["IAM_USER_UNUSED_CREDENTIALS_CHECK"] -> maxCredentialUsageAge = "366"
  - Checks whether your AWS Identity and Access Management (IAM) users have passwords or active access keys that have not been used within the specified number of days you provided.
  - Maximum number of days a credential cannot be used. The default value is 90 days.
- module.aws-config.aws_config_config_rule.managed_rules["MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS"] -> N/A
  - Checks if AWS multi-factor authentication (MFA) is enabled for all AWS Identity and Access Management (IAM) users that use a console password. The rule is COMPLIANT if MFA is enabled.
- module.aws-config.aws_config_config_rule.managed_rules["MULTI_REGION_CLOUD_TRAIL_ENABLED"] -> N/A
  - Checks that there is at least one multi-region AWS CloudTrail. The rule is non-compliant if the trails do not match input parameters. Parameters:
    - *s3BucketName*. Name of Amazon S3 bucket for AWS CloudTrail to deliver log files to.
    - *snsTopicArn*. Amazon SNS topic ARN for AWS CloudTrail to use for notifications.
    - *cloudWatchLogsLogGroupArn*. Amazon CloudWatch log group ARN for AWS CloudTrail to send data to.
    - *includeManagementEvents*. Event selector to include management events for the AWS CloudTrail.
    - *readWriteType*. Type of events to record. Valid values are ReadOnly, WriteOnly and ALL
- module.aws-config.aws_config_config_rule.managed_rules["RDS_INSTANCE_DELETION_PROTECTION_ENABLED"] -> N/A
  - Checks if an Amazon Relational Database Service (Amazon RDS) instance has deletion protection enabled. The rule is NON_COMPLIANT if an Amazon RDS instance does not have deletion protection enabled; for example, deletionProtection is set to false. Parameters:
    - *databaseEngines*. Comma-separated list of RDS database engines to include in the evaluation of the rule.
- module.aws-config.aws_config_config_rule.managed_rules["RDS_INSTANCE_PUBLIC_ACCESS_CHECK"] -> N/A
  - Checks if the Amazon Relational Database Service (Amazon RDS) instances are not publicly accessible. The rule is NON_COMPLIANT if the publiclyAccessible field is true in the instance configuration item.
- module.aws-config.aws_config_config_rule.managed_rules["RDS_SNAPSHOTS_PUBLIC_PROHIBITED"] -> N/A
  - Checks if Amazon Relational Database Service (Amazon RDS) snapshots are public. The rule is non-compliant if any existing and new Amazon RDS snapshots are public.
- module.aws-config.aws_config_config_rule.managed_rules["ROOT_ACCOUNT_HARDWARE_MFA_ENABLED"] -> N/A
  - Checks whether your AWS account is enabled to use multi-factor authentication (MFA) hardware device to sign in with root credentials.
- module.aws-config.aws_config_config_rule.managed_rules["ROOT_ACCOUNT_MFA_ENABLED"] -> N/A
  - Checks if the root user of your AWS account requires multi-factor authentication for console sign-in. The rule is NON_COMPLIANT if the AWS Identity and Access Management (IAM) root account user does not have multi-factor authentication (MFA) enabled.
- module.aws-config.aws_config_config_rule.managed_rules["S3_BUCKET_VERSIONING_ENABLED"] -> N/A
  - Checks whether versioning is enabled for your S3 buckets.
- module.aws-config.aws_config_config_rule.managed_rules["VPC_DEFAULT_SECURITY_GROUP_CLOSED"] -> N/A
  - Checks if the default security group of any Amazon Virtual Private Cloud (Amazon VPC) does not allow inbound or outbound traffic. The rule is NON_COMPLIANT if the default security group has one or more inbound or outbound traffic rules.
- module.aws-config.aws_config_config_rule.managed_rules["VPC_SG_OPEN_ONLY_TO_AUTHORIZED_PORTS"] -> authorizedTcpPorts = "80,443,22"
  - Checks if security groups allowing unrestricted incoming traffic ('0.0.0.0/0' or '::/0') only allow inbound TCP or UDP connections on authorized ports. The rule is NON_COMPLIANT if such security groups do not have ports specified in the rule parameters. Parameters:
    - *authorizedUdpPorts*. Comma-separated list of UDP ports authorized to be open to 0.0.0.0/0. Ranges are defined by dash, for example, "500,1020-1025".
    - *authorizedTcpPorts*. Comma-separated list of TCP ports authorized to be open to 0.0.0.0/0. Ranges are defined by dash, for example, "443,1020-1025".
- module.aws-config.aws_config_configuration_recorder.config_configuration_recorder -> name = "fork-account-setup-config-configuration-recorder"
  - AWS Config -> Settings.
- module.aws-config.aws_config_configuration_recorder_status.config_configuration_recorder_status
- module.aws-config.aws_config_delivery_channel.config_delivery_channel -> s3_bucket_name = "fork-account-setup-us-east-1-s3-config"
- module.aws-config.aws_iam_role.config_role -> name = "fork-account-setup-config-role"
  - Identity and Access Management (IAM) -> Access management -> Roles.
- module.aws-config.aws_iam_role_policy.config_policy -> name = "fork-account-setup-config-policy"
  - Identity and Access Management (IAM) -> Access management -> Roles -> fork-account-setup-config-role.
- module.aws-config.aws_iam_role_policy.s3_config_policy -> name = "fork-account-setup-s3-config-policy"
  - Identity and Access Management (IAM) -> Access management -> Roles -> fork-account-setup-config-role.
- module.aws-config.aws_iam_role_policy_attachment.a -> policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
  - Identity and Access Management (IAM) -> Access management -> Roles -> fork-account-setup-config-role.
- module.aws-config.aws_s3_bucket.s3_config_bucket -> bucket = "fork-account-setup-us-east-1-s3-config"
  - Amazon S3 -> Buckets.
- module.aws-config.aws_s3_bucket_public_access_block.s3_config_public_access_block
  - Amazon S3 -> Buckets -> fork-account-setup-us-east-1-s3-config -> Permissions.
