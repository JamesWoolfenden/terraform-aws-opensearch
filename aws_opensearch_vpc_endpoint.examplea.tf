resource "aws_opensearch_vpc_endpoint" "examplea" {
  count      = var.create_vpc_endpoint ? 1 : 0
  domain_arn = aws_opensearch_domain.examplea.arn

  vpc_options {
    subnet_ids         = var.vpc_endpoint_subnet_ids
    security_group_ids = var.security_group_ids
  }
}
