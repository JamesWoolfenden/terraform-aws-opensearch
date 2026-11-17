data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "logs" {
  statement {
    sid    = "OpenSearchLogDelivery"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [for group in aws_cloudwatch_log_group.examplea : "${group.arn}:*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:es:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}"]
    }
  }
}

data "aws_iam_policy_document" "domain" {
  statement {
    sid    = "AccountPrincipals"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = var.access_principal_arns
    }
    actions   = var.access_actions
    resources = ["${aws_opensearch_domain.examplea.arn}/*"]
  }
}
