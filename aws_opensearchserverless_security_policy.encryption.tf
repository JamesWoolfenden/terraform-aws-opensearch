resource "aws_opensearchserverless_security_policy" "encryption" {
  count       = var.create_serverless ? 1 : 0
  name        = "${var.serverless_collection_name}-enc"
  type        = "encryption"
  description = "Customer managed KMS encryption for ${var.serverless_collection_name}"
  policy = jsonencode({
    Rules = [{
      ResourceType = "collection"
      Resource     = ["collection/${var.serverless_collection_name}"]
    }]
    AWSOwnedKey = false
    KmsARN      = var.kms_key_arn
  })
}
