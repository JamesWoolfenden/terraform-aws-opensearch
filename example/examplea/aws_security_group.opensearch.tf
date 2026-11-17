resource "aws_security_group" "opensearch" {
  name        = "${var.domain_name}-opensearch"
  description = "OpenSearch domain and VPC endpoints"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "HTTPS from within the VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  egress {
    description = "HTTPS within the VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  tags = var.common_tags
}
