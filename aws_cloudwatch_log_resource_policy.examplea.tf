resource "aws_cloudwatch_log_resource_policy" "examplea" {
  policy_name     = "${var.domain_name}-opensearch-logs"
  policy_document = data.aws_iam_policy_document.logs.json
}
