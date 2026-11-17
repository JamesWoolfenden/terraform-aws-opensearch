# terraform-aws-opensearch

[![Build Status](https://github.com/JamesWoolfenden/terraform-aws-opensearch/workflows/Verify/badge.svg?branch=main)](https://github.com/JamesWoolfenden/terraform-aws-opensearch)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-aws-opensearch.svg)](https://github.com/JamesWoolfenden/terraform-aws-opensearch/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-aws-opensearch.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-aws-opensearch/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.5.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

Terraform module for Amazon OpenSearch Service. It creates a VPC-only OpenSearch domain with its
access policy, CloudWatch log groups plus the log resource policy for log delivery, an optional
OpenSearch managed VPC endpoint, and an optional OpenSearch Serverless collection with encryption
and network security policies and a serverless VPC endpoint.

Secure defaults: encryption at rest with a CMK, node-to-node encryption, HTTPS enforced with a
TLS 1.2 (PFS) policy, fine-grained access control with an IAM master user and anonymous auth off,
all four log types published to KMS-encrypted, deletion-protected log groups retained for a year,
zone awareness across 3 AZs with dedicated masters, auto software updates, an access policy scoped
to named principals, and a serverless collection that uses a CMK and is reachable only via its VPC
endpoint.

---

It's 100% Open Source and licensed under the [APACHE2](LICENSE).

## Usage

Include this repository as a module in your existing Terraform code:

```hcl
module "opensearch" {
  source                = "JamesWoolfenden/opensearch/aws"
  version               = "0.0.1"
  common_tags           = var.common_tags
  domain_name           = "examplea"
  kms_key_arn           = aws_kms_key.opensearch.arn
  log_kms_key_arn       = aws_kms_key.opensearch.arn
  master_user_arn       = aws_iam_role.admin.arn
  access_principal_arns = [aws_iam_role.admin.arn]
  vpc_id                = var.vpc_id
  subnet_ids            = var.private_subnet_ids
  security_group_ids    = [aws_security_group.opensearch.id]
}
```

A fuller example, including supporting resources, is in the **example/examplea** folder.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_cloudwatch_log_group.examplea](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.examplea](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_opensearch_domain.examplea](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain) | resource |
| [aws_opensearch_domain_policy.examplea](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain_policy) | resource |
| [aws_opensearch_vpc_endpoint.examplea](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_vpc_endpoint) | resource |
| [aws_opensearchserverless_collection.examplea](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_collection) | resource |
| [aws_opensearchserverless_security_policy.encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy) | resource |
| [aws_opensearchserverless_security_policy.network](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy) | resource |
| [aws_opensearchserverless_vpc_endpoint.examplea](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_vpc_endpoint) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_access_actions"></a> [access\_actions](#input\_access\_actions) | Actions granted by the default domain access policy | `list(string)` | <pre>[<br/>  "es:ESHttpGet",<br/>  "es:ESHttpHead",<br/>  "es:ESHttpPost",<br/>  "es:ESHttpPut",<br/>  "es:ESHttpDelete"<br/>]</pre> | no |
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | Override JSON access policy for the domain; when null a policy scoped to access\_principal\_arns is used | `string` | `null` | no |
| <a name="input_access_principal_arns"></a> [access\_principal\_arns](#input\_access\_principal\_arns) | IAM principal ARNs granted access by the default domain access policy | `list(string)` | n/a | yes |
| <a name="input_advanced_security_enabled"></a> [advanced\_security\_enabled](#input\_advanced\_security\_enabled) | Enable fine-grained access control | `bool` | `true` | no |
| <a name="input_auto_software_update_enabled"></a> [auto\_software\_update\_enabled](#input\_auto\_software\_update\_enabled) | Apply service software updates automatically in the off-peak window | `bool` | `true` | no |
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Number of AZs used when zone awareness is enabled (2 or 3) | `number` | `3` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | This is to help you add tags to your cloud objects | `map(any)` | n/a | yes |
| <a name="input_create_serverless"></a> [create\_serverless](#input\_create\_serverless) | Create an OpenSearch Serverless collection with encryption/network policies and a VPC endpoint | `bool` | `false` | no |
| <a name="input_create_vpc_endpoint"></a> [create\_vpc\_endpoint](#input\_create\_vpc\_endpoint) | Create an additional OpenSearch managed VPC endpoint (for access from another VPC/subnets) | `bool` | `false` | no |
| <a name="input_dedicated_master_count"></a> [dedicated\_master\_count](#input\_dedicated\_master\_count) | Number of dedicated master nodes (3 or 5 recommended) | `number` | `3` | no |
| <a name="input_dedicated_master_enabled"></a> [dedicated\_master\_enabled](#input\_dedicated\_master\_enabled) | Use dedicated cluster manager (master) nodes | `bool` | `true` | no |
| <a name="input_dedicated_master_type"></a> [dedicated\_master\_type](#input\_dedicated\_master\_type) | Dedicated master instance type | `string` | `"m6g.large.search"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Name of the OpenSearch domain | `string` | n/a | yes |
| <a name="input_ebs_iops"></a> [ebs\_iops](#input\_ebs\_iops) | Provisioned IOPS for gp3/io1 volumes | `number` | `3000` | no |
| <a name="input_ebs_throughput"></a> [ebs\_throughput](#input\_ebs\_throughput) | Provisioned throughput (MiB/s) for gp3 volumes | `number` | `125` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | EBS volume size (GiB) per data node | `number` | `100` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | EBS volume type for data nodes | `string` | `"gp3"` | no |
| <a name="input_encrypt_at_rest_enabled"></a> [encrypt\_at\_rest\_enabled](#input\_encrypt\_at\_rest\_enabled) | Encrypt domain data at rest | `bool` | `true` | no |
| <a name="input_enforce_https"></a> [enforce\_https](#input\_enforce\_https) | Require HTTPS for all traffic to the domain | `bool` | `true` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | OpenSearch engine version | `string` | `"OpenSearch_2.19"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of data nodes (should be a multiple of availability\_zone\_count) | `number` | `3` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Data node instance type | `string` | `"r6g.large.search"` | no |
| <a name="input_internal_user_database_enabled"></a> [internal\_user\_database\_enabled](#input\_internal\_user\_database\_enabled) | Use the OpenSearch internal user database (IAM master user is used when false) | `bool` | `false` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | IP address type for the domain endpoint: ipv4 or dualstack | `string` | `"ipv4"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Customer managed KMS key ARN for domain encryption at rest and the serverless encryption policy | `string` | n/a | yes |
| <a name="input_log_deletion_protection_enabled"></a> [log\_deletion\_protection\_enabled](#input\_log\_deletion\_protection\_enabled) | Protect the OpenSearch CloudWatch log groups from deletion | `bool` | `true` | no |
| <a name="input_log_kms_key_arn"></a> [log\_kms\_key\_arn](#input\_log\_kms\_key\_arn) | KMS key ARN used to encrypt the CloudWatch log groups | `string` | n/a | yes |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Retention for the OpenSearch CloudWatch log groups | `number` | `365` | no |
| <a name="input_log_types"></a> [log\_types](#input\_log\_types) | OpenSearch log types published to CloudWatch | `list(string)` | <pre>[<br/>  "AUDIT_LOGS",<br/>  "ES_APPLICATION_LOGS",<br/>  "INDEX_SLOW_LOGS",<br/>  "SEARCH_SLOW_LOGS"<br/>]</pre> | no |
| <a name="input_master_user_arn"></a> [master\_user\_arn](#input\_master\_user\_arn) | IAM principal ARN mapped to the fine-grained access control master user | `string` | n/a | yes |
| <a name="input_multi_az_with_standby_enabled"></a> [multi\_az\_with\_standby\_enabled](#input\_multi\_az\_with\_standby\_enabled) | Enable Multi-AZ with Standby (requires 3 AZs and dedicated masters) | `bool` | `false` | no |
| <a name="input_node_to_node_encryption_enabled"></a> [node\_to\_node\_encryption\_enabled](#input\_node\_to\_node\_encryption\_enabled) | Encrypt traffic between nodes | `bool` | `true` | no |
| <a name="input_off_peak_window_start_hour"></a> [off\_peak\_window\_start\_hour](#input\_off\_peak\_window\_start\_hour) | UTC hour the daily off-peak window starts | `number` | `2` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs attached to the domain and VPC endpoints | `list(string)` | n/a | yes |
| <a name="input_serverless_collection_name"></a> [serverless\_collection\_name](#input\_serverless\_collection\_name) | Name of the OpenSearch Serverless collection | `string` | `"examplea"` | no |
| <a name="input_serverless_collection_type"></a> [serverless\_collection\_type](#input\_serverless\_collection\_type) | Serverless collection type: SEARCH, TIMESERIES or VECTORSEARCH | `string` | `"SEARCH"` | no |
| <a name="input_serverless_standby_replicas"></a> [serverless\_standby\_replicas](#input\_serverless\_standby\_replicas) | Enable standby replicas for the serverless collection | `string` | `"ENABLED"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Private subnet IDs for the domain (one per AZ when zone awareness is enabled) and the serverless VPC endpoint | `list(string)` | n/a | yes |
| <a name="input_tls_security_policy"></a> [tls\_security\_policy](#input\_tls\_security\_policy) | TLS security policy for the domain endpoint | `string` | `"Policy-Min-TLS-1-2-PFS-2023-10"` | no |
| <a name="input_vpc_endpoint_subnet_ids"></a> [vpc\_endpoint\_subnet\_ids](#input\_vpc\_endpoint\_subnet\_ids) | Subnet IDs for the OpenSearch managed VPC endpoint | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID (used by the serverless VPC endpoint) | `string` | n/a | yes |
| <a name="input_zone_awareness_enabled"></a> [zone\_awareness\_enabled](#input\_zone\_awareness\_enabled) | Spread nodes across availability zones | `bool` | `true` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_domain"></a> [domain](#output\_domain) | The OpenSearch domain |
| <a name="output_domain_policy"></a> [domain\_policy](#output\_domain\_policy) | The OpenSearch domain access policy |
| <a name="output_log_groups"></a> [log\_groups](#output\_log\_groups) | CloudWatch log groups receiving OpenSearch logs, keyed by log type |
| <a name="output_log_resource_policy"></a> [log\_resource\_policy](#output\_log\_resource\_policy) | CloudWatch Logs resource policy allowing OpenSearch log delivery |
| <a name="output_serverless_collection"></a> [serverless\_collection](#output\_serverless\_collection) | The OpenSearch Serverless collection (empty list when create\_serverless is false) |
| <a name="output_serverless_encryption_policy"></a> [serverless\_encryption\_policy](#output\_serverless\_encryption\_policy) | The OpenSearch Serverless encryption security policy |
| <a name="output_serverless_network_policy"></a> [serverless\_network\_policy](#output\_serverless\_network\_policy) | The OpenSearch Serverless network security policy |
| <a name="output_serverless_vpc_endpoint"></a> [serverless\_vpc\_endpoint](#output\_serverless\_vpc\_endpoint) | The OpenSearch Serverless VPC endpoint |
| <a name="output_vpc_endpoint"></a> [vpc\_endpoint](#output\_vpc\_endpoint) | The OpenSearch managed VPC endpoint (empty list when create\_vpc\_endpoint is false) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Policy

This is the policy required to build this project:

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role — full permissions for terraform apply
resource "aws_iam_policy" "terraform_pike" {
  name_prefix = "terraform_pike"
  path        = "/"
  description = "Pike Autogenerated policy from IAC"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "aoss:BatchGetCollection",
                "aoss:BatchGetVpcEndpoint",
                "aoss:CreateCollection",
                "aoss:CreateSecurityPolicy",
                "aoss:CreateVpcEndpoint",
                "aoss:DeleteCollection",
                "aoss:DeleteSecurityPolicy",
                "aoss:DeleteVpcEndpoint",
                "aoss:ListTagsForResource",
                "aoss:UpdateCollection",
                "aoss:UpdateSecurityPolicy",
                "aoss:UpdateVpcEndpoint"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:CreateVpcEndpoint",
                "ec2:DeleteNetworkInterface",
                "ec2:DeleteVpcEndpoints",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeVpcEndpoints",
                "ec2:DetachNetworkInterface",
                "ec2:ModifyVpcEndpoints"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "es:AddTags",
                "es:CreateDomain",
                "es:CreateElasticsearchDomain",
                "es:CreateVpcEndpoint",
                "es:DeleteDomain",
                "es:DeleteElasticsearchDomain",
                "es:DeleteVpcEndpoint",
                "es:DescribeDomainConfig",
                "es:DescribeElasticsearchDomain",
                "es:DescribeElasticsearchDomainConfig",
                "es:DescribeVpcEndpoints",
                "es:ListTags",
                "es:RemoveTags",
                "es:UpdateDomainConfig",
                "es:UpdateElasticsearchDomainConfig",
                "es:UpdateVpcEndpoint"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor4",
            "Effect": "Allow",
            "Action": [
                "logs:AssociateKmsKey",
                "logs:CreateLogGroup",
                "logs:DeleteLogGroup",
                "logs:DeleteResourcePolicy",
                "logs:DeleteRetentionPolicy",
                "logs:DescribeLogGroups",
                "logs:DescribeResourcePolicies",
                "logs:DisassociateKmsKey",
                "logs:ListTagsForResource",
                "logs:ListTagsLogGroup",
                "logs:PutResourcePolicy",
                "logs:PutRetentionPolicy",
                "logs:TagLogGroup",
                "logs:UntagLogGroup"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor5",
            "Effect": "Allow",
            "Action": [
                "route53:AssociateVPCWithHostedZone"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
})
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->

## Help

**Got a question?**

File a GitHub [issue](https://github.com/JamesWoolfenden/terraform-aws-opensearch/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/JamesWoolfenden/terraform-aws-opensearch/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2019-2026 James Woolfenden

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage]<br/>[James Woolfenden][jameswoolfenden_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
