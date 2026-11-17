locals {
  dedicated_master_type   = var.dedicated_master_enabled ? var.dedicated_master_type : null
  dedicated_master_count  = var.dedicated_master_enabled ? var.dedicated_master_count : null
  zone_awareness_az_count = var.zone_awareness_enabled ? [var.availability_zone_count] : []
  log_group_arns          = { for type, group in aws_cloudwatch_log_group.examplea : type => group.arn }
  domain_access_policies  = var.access_policies != null ? var.access_policies : data.aws_iam_policy_document.domain.json
}
