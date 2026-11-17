variable "common_tags" {
  description = "This is to help you add tags to your cloud objects"
  type        = map(any)

  validation {
    condition     = length(var.common_tags) <= 50
    error_message = "common_tags can hold at most 50 tags (the AWS per-resource limit)."
  }
}

variable "domain_name" {
  description = "Name of the example OpenSearch domain"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,24}$", var.domain_name))
    error_message = "domain_name must be 3-25 lowercase letters, digits or hyphens."
  }
}

variable "vpc_id" {
  description = "VPC to deploy OpenSearch into"
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "vpc_id must start with vpc-."
  }
}

variable "admin_role_name" {
  description = "Existing IAM role used as the fine-grained access control master user"
  type        = string

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,64}$", var.admin_role_name))
    error_message = "admin_role_name must be a valid IAM role name."
  }
}
