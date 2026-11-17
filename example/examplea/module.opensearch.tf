# holden:ignore:HLD_TF_026 example consumes the module from the repository root by design
module "opensearch" {
  source                     = "../../"
  common_tags                = var.common_tags
  domain_name                = var.domain_name
  kms_key_arn                = aws_kms_key.opensearch.arn
  log_kms_key_arn            = aws_kms_key.opensearch.arn
  master_user_arn            = data.aws_iam_role.admin.arn
  access_principal_arns      = [data.aws_iam_role.admin.arn]
  vpc_id                     = data.aws_vpc.main.id
  subnet_ids                 = slice(sort(data.aws_subnets.private.ids), 0, 3)
  security_group_ids         = [aws_security_group.opensearch.id]
  create_vpc_endpoint        = true
  vpc_endpoint_subnet_ids    = slice(sort(data.aws_subnets.private.ids), 0, 3)
  create_serverless          = true
  serverless_collection_name = "${var.domain_name}-sl"
}
