output "domain" {
  description = "The OpenSearch domain"
  value       = aws_opensearch_domain.examplea
}

output "domain_policy" {
  description = "The OpenSearch domain access policy"
  value       = aws_opensearch_domain_policy.examplea
}

output "vpc_endpoint" {
  description = "The OpenSearch managed VPC endpoint (empty list when create_vpc_endpoint is false)"
  value       = aws_opensearch_vpc_endpoint.examplea
}

output "log_groups" {
  description = "CloudWatch log groups receiving OpenSearch logs, keyed by log type"
  value       = aws_cloudwatch_log_group.examplea
}

output "log_resource_policy" {
  description = "CloudWatch Logs resource policy allowing OpenSearch log delivery"
  value       = aws_cloudwatch_log_resource_policy.examplea
}

output "serverless_collection" {
  description = "The OpenSearch Serverless collection (empty list when create_serverless is false)"
  value       = aws_opensearchserverless_collection.examplea
}

output "serverless_encryption_policy" {
  description = "The OpenSearch Serverless encryption security policy"
  value       = aws_opensearchserverless_security_policy.encryption
}

output "serverless_network_policy" {
  description = "The OpenSearch Serverless network security policy"
  value       = aws_opensearchserverless_security_policy.network
}

output "serverless_vpc_endpoint" {
  description = "The OpenSearch Serverless VPC endpoint"
  value       = aws_opensearchserverless_vpc_endpoint.examplea
}
