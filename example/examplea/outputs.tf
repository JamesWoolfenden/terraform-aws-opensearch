output "domain" {
  description = "The OpenSearch domain"
  value       = module.opensearch.domain
}

output "vpc_endpoint" {
  description = "The OpenSearch managed VPC endpoint"
  value       = module.opensearch.vpc_endpoint
}

output "serverless_collection" {
  description = "The OpenSearch Serverless collection"
  value       = module.opensearch.serverless_collection
}
