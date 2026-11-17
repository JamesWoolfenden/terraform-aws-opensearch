terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.43.0"
    }
  }
  required_version = ">=1.5"

  # local state is intentional for this example; use a remote backend in real deployments
  backend "local" {}
}
