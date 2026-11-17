variable "common_tags" {
  description = "This is to help you add tags to your cloud objects"
  type        = map(any)

  validation {
    condition     = length(var.common_tags) <= 50
    error_message = "common_tags can hold at most 50 tags (the AWS per-resource limit)."
  }
}

variable "domain_name" {
  description = "Name of the OpenSearch domain"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,27}$", var.domain_name))
    error_message = "domain_name must be 3-28 lowercase letters, digits or hyphens, starting with a letter."
  }
}

variable "engine_version" {
  description = "OpenSearch engine version"
  type        = string
  default     = "OpenSearch_2.19"

  validation {
    condition     = can(regex("^(OpenSearch|Elasticsearch)_[0-9]+\\.[0-9]+$", var.engine_version))
    error_message = "engine_version must look like OpenSearch_2.19."
  }
}

variable "ip_address_type" {
  description = "IP address type for the domain endpoint: ipv4 or dualstack"
  type        = string
  default     = "ipv4"

  validation {
    condition     = contains(["ipv4", "dualstack"], var.ip_address_type)
    error_message = "ip_address_type must be ipv4 or dualstack."
  }
}

variable "instance_type" {
  description = "Data node instance type"
  type        = string
  default     = "r6g.large.search"

  validation {
    condition     = can(regex("\\.search$", var.instance_type))
    error_message = "instance_type must be an OpenSearch instance type ending in .search."
  }
}

variable "instance_count" {
  description = "Number of data nodes (should be a multiple of availability_zone_count)"
  type        = number
  default     = 3

  validation {
    condition     = var.instance_count >= 1
    error_message = "instance_count must be at least 1."
  }
}

variable "dedicated_master_enabled" {
  description = "Use dedicated cluster manager (master) nodes"
  type        = bool
  default     = true
}

variable "dedicated_master_type" {
  description = "Dedicated master instance type"
  type        = string
  default     = "m6g.large.search"

  validation {
    condition     = can(regex("\\.search$", var.dedicated_master_type))
    error_message = "dedicated_master_type must be an OpenSearch instance type ending in .search."
  }
}

variable "dedicated_master_count" {
  description = "Number of dedicated master nodes (3 or 5 recommended)"
  type        = number
  default     = 3

  validation {
    condition     = contains([3, 5], var.dedicated_master_count)
    error_message = "dedicated_master_count should be 3 or 5 for quorum."
  }
}

variable "zone_awareness_enabled" {
  description = "Spread nodes across availability zones"
  type        = bool
  default     = true
}

variable "availability_zone_count" {
  description = "Number of AZs used when zone awareness is enabled (2 or 3)"
  type        = number
  default     = 3

  validation {
    condition     = contains([2, 3], var.availability_zone_count)
    error_message = "availability_zone_count must be 2 or 3."
  }
}

variable "multi_az_with_standby_enabled" {
  description = "Enable Multi-AZ with Standby (requires 3 AZs and dedicated masters)"
  type        = bool
  default     = false
}

variable "ebs_volume_type" {
  description = "EBS volume type for data nodes"
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["gp2", "gp3", "io1", "standard"], var.ebs_volume_type)
    error_message = "ebs_volume_type must be gp2, gp3, io1 or standard."
  }
}

variable "ebs_volume_size" {
  description = "EBS volume size (GiB) per data node"
  type        = number
  default     = 100

  validation {
    condition     = var.ebs_volume_size >= 10
    error_message = "ebs_volume_size must be at least 10 GiB."
  }
}

variable "ebs_iops" {
  description = "Provisioned IOPS for gp3/io1 volumes"
  type        = number
  default     = 3000

  validation {
    condition     = var.ebs_iops == null || var.ebs_iops >= 1000
    error_message = "ebs_iops must be null or at least 1000."
  }
}

variable "ebs_throughput" {
  description = "Provisioned throughput (MiB/s) for gp3 volumes"
  type        = number
  default     = 125

  validation {
    condition     = var.ebs_throughput == null || var.ebs_throughput >= 125
    error_message = "ebs_throughput must be null or at least 125."
  }
}

variable "encrypt_at_rest_enabled" {
  description = "Encrypt domain data at rest"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "Customer managed KMS key ARN for domain encryption at rest and the serverless encryption policy"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-z-]*:kms:", var.kms_key_arn))
    error_message = "kms_key_arn must be a KMS key ARN."
  }
}

variable "node_to_node_encryption_enabled" {
  description = "Encrypt traffic between nodes"
  type        = bool
  default     = true
}

variable "enforce_https" {
  description = "Require HTTPS for all traffic to the domain"
  type        = bool
  default     = true
}

variable "tls_security_policy" {
  description = "TLS security policy for the domain endpoint"
  type        = string
  default     = "Policy-Min-TLS-1-2-PFS-2023-10"

  validation {
    condition     = contains(["Policy-Min-TLS-1-2-2019-07", "Policy-Min-TLS-1-2-PFS-2023-10"], var.tls_security_policy)
    error_message = "tls_security_policy must enforce TLS 1.2 or higher."
  }
}

variable "advanced_security_enabled" {
  description = "Enable fine-grained access control"
  type        = bool
  default     = true
}

variable "internal_user_database_enabled" {
  description = "Use the OpenSearch internal user database (IAM master user is used when false)"
  type        = bool
  default     = false
}

variable "master_user_arn" {
  description = "IAM principal ARN mapped to the fine-grained access control master user"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-z-]*:iam::[0-9]{12}:(role|user)/", var.master_user_arn))
    error_message = "master_user_arn must be an IAM role or user ARN."
  }
}

variable "log_types" {
  description = "OpenSearch log types published to CloudWatch"
  type        = list(string)
  default     = ["AUDIT_LOGS", "ES_APPLICATION_LOGS", "INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS"]

  validation {
    condition     = alltrue([for t in var.log_types : contains(["AUDIT_LOGS", "ES_APPLICATION_LOGS", "INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS"], t)])
    error_message = "log_types must be drawn from AUDIT_LOGS, ES_APPLICATION_LOGS, INDEX_SLOW_LOGS, SEARCH_SLOW_LOGS."
  }
}

variable "log_retention_in_days" {
  description = "Retention for the OpenSearch CloudWatch log groups"
  type        = number
  default     = 365

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.log_retention_in_days)
    error_message = "log_retention_in_days must be a CloudWatch supported retention value."
  }
}

variable "log_kms_key_arn" {
  description = "KMS key ARN used to encrypt the CloudWatch log groups"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-z-]*:kms:", var.log_kms_key_arn))
    error_message = "log_kms_key_arn must be a KMS key ARN."
  }
}

variable "vpc_id" {
  description = "VPC ID (used by the serverless VPC endpoint)"
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "vpc_id must start with vpc-."
  }
}

variable "subnet_ids" {
  description = "Private subnet IDs for the domain (one per AZ when zone awareness is enabled) and the serverless VPC endpoint"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 1 && alltrue([for s in var.subnet_ids : can(regex("^subnet-", s))])
    error_message = "subnet_ids must be a list of subnet IDs."
  }
}

variable "security_group_ids" {
  description = "Security group IDs attached to the domain and VPC endpoints"
  type        = list(string)

  validation {
    condition     = alltrue([for s in var.security_group_ids : can(regex("^sg-", s))])
    error_message = "security_group_ids must be security group IDs (sg-...)."
  }
}

variable "auto_software_update_enabled" {
  description = "Apply service software updates automatically in the off-peak window"
  type        = bool
  default     = true
}

variable "off_peak_window_start_hour" {
  description = "UTC hour the daily off-peak window starts"
  type        = number
  default     = 2

  validation {
    condition     = var.off_peak_window_start_hour >= 0 && var.off_peak_window_start_hour <= 23
    error_message = "off_peak_window_start_hour must be 0-23."
  }
}

variable "access_principal_arns" {
  description = "IAM principal ARNs granted access by the default domain access policy"
  type        = list(string)

  validation {
    condition     = length(var.access_principal_arns) > 0 && alltrue([for p in var.access_principal_arns : can(regex("^arn:aws[a-z-]*:iam::[0-9]{12}:", p))])
    error_message = "access_principal_arns must be a non-empty list of IAM ARNs (no wildcards)."
  }
}

variable "access_actions" {
  description = "Actions granted by the default domain access policy"
  type        = list(string)
  default     = ["es:ESHttpGet", "es:ESHttpHead", "es:ESHttpPost", "es:ESHttpPut", "es:ESHttpDelete"]

  validation {
    condition     = alltrue([for a in var.access_actions : can(regex("^es:ESHttp", a))])
    error_message = "access_actions must be es:ESHttp* data plane actions."
  }
}

variable "access_policies" {
  description = "Override JSON access policy for the domain; when null a policy scoped to access_principal_arns is used"
  type        = string
  default     = null

  validation {
    condition     = var.access_policies == null || can(jsondecode(var.access_policies))
    error_message = "access_policies must be valid JSON."
  }
}

variable "create_vpc_endpoint" {
  description = "Create an additional OpenSearch managed VPC endpoint (for access from another VPC/subnets)"
  type        = bool
  default     = false
}

variable "vpc_endpoint_subnet_ids" {
  description = "Subnet IDs for the OpenSearch managed VPC endpoint"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for s in var.vpc_endpoint_subnet_ids : can(regex("^subnet-", s))])
    error_message = "vpc_endpoint_subnet_ids must be subnet IDs."
  }
}

variable "create_serverless" {
  description = "Create an OpenSearch Serverless collection with encryption/network policies and a VPC endpoint"
  type        = bool
  default     = false
}

variable "serverless_collection_name" {
  description = "Name of the OpenSearch Serverless collection"
  type        = string
  default     = "examplea"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,27}$", var.serverless_collection_name))
    error_message = "serverless_collection_name must be 3-28 lowercase letters, digits or hyphens."
  }
}

variable "serverless_collection_type" {
  description = "Serverless collection type: SEARCH, TIMESERIES or VECTORSEARCH"
  type        = string
  default     = "SEARCH"

  validation {
    condition     = contains(["SEARCH", "TIMESERIES", "VECTORSEARCH"], var.serverless_collection_type)
    error_message = "serverless_collection_type must be SEARCH, TIMESERIES or VECTORSEARCH."
  }
}

variable "serverless_standby_replicas" {
  description = "Enable standby replicas for the serverless collection"
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.serverless_standby_replicas)
    error_message = "serverless_standby_replicas must be ENABLED or DISABLED."
  }
}

variable "log_deletion_protection_enabled" {
  description = "Protect the OpenSearch CloudWatch log groups from deletion"
  type        = bool
  default     = true
}
