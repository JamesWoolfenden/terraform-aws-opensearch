resource "aws_opensearchserverless_security_policy" "network" {
  count       = var.create_serverless ? 1 : 0
  name        = "${var.serverless_collection_name}-net"
  type        = "network"
  description = "Private VPC endpoint only access for ${var.serverless_collection_name}"
  policy = jsonencode([{
    Rules = [
      {
        ResourceType = "collection"
        Resource     = ["collection/${var.serverless_collection_name}"]
      },
      {
        ResourceType = "dashboard"
        Resource     = ["collection/${var.serverless_collection_name}"]
      },
    ]
    AllowFromPublic = false
    SourceVPCEs     = [aws_opensearchserverless_vpc_endpoint.examplea[0].id]
  }])
}
