resource "aws_opensearchserverless_collection" "examplea" {
  count            = var.create_serverless ? 1 : 0
  name             = var.serverless_collection_name
  description      = "OpenSearch Serverless collection ${var.serverless_collection_name}"
  type             = var.serverless_collection_type
  standby_replicas = var.serverless_standby_replicas
  tags             = var.common_tags

  depends_on = [
    aws_opensearchserverless_security_policy.encryption,
    aws_opensearchserverless_security_policy.network,
  ]
}
