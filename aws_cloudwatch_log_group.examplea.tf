resource "aws_cloudwatch_log_group" "examplea" {
  for_each                    = toset(var.log_types)
  name                        = "/aws/opensearch/${var.domain_name}/${lower(each.value)}"
  retention_in_days           = var.log_retention_in_days
  kms_key_id                  = var.log_kms_key_arn
  deletion_protection_enabled = var.log_deletion_protection_enabled
  tags                        = var.common_tags
}
