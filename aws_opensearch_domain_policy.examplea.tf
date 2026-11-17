resource "aws_opensearch_domain_policy" "examplea" {
  domain_name     = aws_opensearch_domain.examplea.domain_name
  access_policies = local.domain_access_policies
}
