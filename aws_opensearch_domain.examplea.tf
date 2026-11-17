resource "aws_opensearch_domain" "examplea" {
  domain_name     = var.domain_name
  engine_version  = var.engine_version
  ip_address_type = var.ip_address_type

  cluster_config {
    instance_type                 = var.instance_type
    instance_count                = var.instance_count
    dedicated_master_enabled      = var.dedicated_master_enabled
    dedicated_master_type         = local.dedicated_master_type
    dedicated_master_count        = local.dedicated_master_count
    zone_awareness_enabled        = var.zone_awareness_enabled
    multi_az_with_standby_enabled = var.multi_az_with_standby_enabled

    dynamic "zone_awareness_config" {
      for_each = local.zone_awareness_az_count
      content {
        availability_zone_count = zone_awareness_config.value
      }
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_type = var.ebs_volume_type
    volume_size = var.ebs_volume_size
    iops        = var.ebs_iops
    throughput  = var.ebs_throughput
  }

  encrypt_at_rest {
    enabled    = var.encrypt_at_rest_enabled
    kms_key_id = var.kms_key_arn
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }

  domain_endpoint_options {
    enforce_https       = var.enforce_https
    tls_security_policy = var.tls_security_policy
  }

  advanced_security_options {
    enabled                        = var.advanced_security_enabled
    anonymous_auth_enabled         = false
    internal_user_database_enabled = var.internal_user_database_enabled

    master_user_options {
      master_user_arn = var.master_user_arn
    }
  }

  dynamic "log_publishing_options" {
    for_each = local.log_group_arns
    content {
      log_type                 = log_publishing_options.key
      cloudwatch_log_group_arn = log_publishing_options.value
      enabled                  = true
    }
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  software_update_options {
    auto_software_update_enabled = var.auto_software_update_enabled
  }

  off_peak_window_options {
    enabled = true
    off_peak_window {
      window_start_time {
        hours   = var.off_peak_window_start_hour
        minutes = 0
      }
    }
  }

  tags = var.common_tags

  depends_on = [aws_cloudwatch_log_resource_policy.examplea]
}
