# Reusable Platform Orchestrator ECS Runner

A reusable Terraform module for setting up an ECS Runner for the Humanitec Platform Orchestrator.

## Overview

This module provides a reusable configuration for deploying an ECS-based runner that integrates with the Humanitec Platform Orchestrator. The module handles runner ID generation, AWS resource provisioning, and IAM role configuration.

The ECS runner requires an ECS cluster and a subnet where to run tasks. You may bring these resources if you have existing ones, or have the module create them for convenience. See the examples below for each case.

## Usage

### Basic example

```hcl
module "ecs_runner" {
  source = "github.com/humanitec-tf-modules/serverless-ecs-orchestrator-runner?ref=vX.Y.Z"
  
  region           = "us-east-1"
  subnet_ids       = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id = "my-org-id"
}
```

### With custom runner ID

```hcl
module "ecs_runner" {
  source = "github.com/humanitec-tf-modules/serverless-ecs-orchestrator-runner?ref=vX.Y.Z"
  
  region           = "us-east-1"
  subnet_ids       = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id = "my-org-id"
  runner_id        = "my-custom-runner"
}
```

### With custom runner ID prefix

```hcl
module "ecs_runner" {
  source = "github.com/humanitec-tf-modules/serverless-ecs-orchestrator-runner?ref=vX.Y.Z"
  
  region           = "us-east-1"
  subnet_ids       = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id = "my-org-id"
  runner_id_prefix = "prod-runner"
}
```

### With existing ECS cluster

```hcl
module "ecs_runner" {
  source = "github.com/humanitec-tf-modules/serverless-ecs-orchestrator-runner?ref=vX.Y.Z"
  
  region                    = "us-east-1"
  subnet_ids                = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id          = "my-org-id"
  existing_ecs_cluster_name = "existing-cluster"
}
```

### Without existing ECS cluster or VPC (let the module create both)

```hcl
module "ecs_runner" {
  source = "github.com/humanitec-tf-modules/serverless-ecs-orchestrator-runner?ref=vX.Y.Z"
  
  region                    = "us-east-1"
  humanitec_org_id          = "my-org-id"
}
```

### With additional tags

```hcl
module "ecs_runner" {
  source = "github.com/humanitec-tf-modules/serverless-ecs-orchestrator-runner?ref=vX.Y.Z"
  
  region           = "us-east-1"
  subnet_ids       = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id = "my-org-id"
  
  additional_tags = {
    Environment = "production"
    Team        = "platform"
    CostCenter  = "engineering"
  }
}
```

### With Subnets and Security Groups

```hcl
module "ecs_runner" {
  source = "github.com/humanitec-tf-modules/serverless-ecs-orchestrator-runner?ref=vX.Y.Z"
  
  region             = "us-east-1"
  subnet_ids         = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id   = "my-org-id"
  security_group_ids = ["sg-12345678"]
}
```

### With Existing OIDC Provider

```hcl
module "ecs_runner" {
  source = "github.com/humanitec-tf-modules/serverless-ecs-orchestrator-runner?ref=vX.Y.Z"
  
  region                     = "us-east-1"
  subnet_ids                 = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id           = "my-org-id"
  existing_oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.humanitec.dev"
}
```

### With Custom OIDC Hostname

```hcl
module "ecs_runner" {
  source = "github.com/humanitec-tf-modules/serverless-ecs-orchestrator-runner?ref=vX.Y.Z"
  
  region           = "us-east-1"
  subnet_ids       = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id = "my-org-id"
  oidc_hostname    = "custom-oidc.example.com"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_platform-orchestrator"></a> [platform-orchestrator](#requirement\_platform-orchestrator) | ~> 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.21.0 |
| <a name="provider_platform-orchestrator"></a> [platform-orchestrator](#provider\_platform-orchestrator) | 2.10.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_iam_openid_connect_provider.oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.ecs_task_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_task_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.task_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [platform-orchestrator_serverless_ecs_runner.runner](https://registry.terraform.io/providers/humanitec/platform-orchestrator/latest/docs/resources/serverless_ecs_runner) | resource |
| [random_id.runner_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags to apply to resources created by this module | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Plain text environment variables to expose in the runner | `map(string)` | `{}` | no |
| <a name="input_existing_ecs_cluster_name"></a> [existing\_ecs\_cluster\_name](#input\_existing\_ecs\_cluster\_name) | The name of an existing ECS cluster to use. If not provided, a new Fargate-compatible cluster will be created | `string` | `null` | no |
| <a name="input_existing_oidc_provider_arn"></a> [existing\_oidc\_provider\_arn](#input\_existing\_oidc\_provider\_arn) | The ARN of an existing OIDC provider to use. If not provided, a new OIDC provider will be created | `string` | `null` | no |
| <a name="input_force_delete_s3"></a> [force\_delete\_s3](#input\_force\_delete\_s3) | Force delete the S3 state files bucket on destroy even if it's not empty | `bool` | `false` | no |
| <a name="input_humanitec_org_id"></a> [humanitec\_org\_id](#input\_humanitec\_org\_id) | The Humanitec organization ID for OIDC federation | `string` | n/a | yes |
| <a name="input_oidc_hostname"></a> [oidc\_hostname](#input\_oidc\_hostname) | The hostname of the OIDC provider. Defaults to oidc.humanitec.dev | `string` | `"oidc.humanitec.dev"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region where resources will be created | `string` | n/a | yes |
| <a name="input_runner_id"></a> [runner\_id](#input\_runner\_id) | The ID of the runner. If not provided, one will be generated using runner\_id\_prefix | `string` | `null` | no |
| <a name="input_runner_id_prefix"></a> [runner\_id\_prefix](#input\_runner\_id\_prefix) | The prefix to use when generating a runner ID. Only used if runner\_id is not provided | `string` | `"runner"` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Secret environment variables to expose in the runner. Each value should be a secret or property ARN | `map(string)` | `{}` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Optional list of security group IDs to attach to ECS tasks | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs where ECS tasks will be launched. If not provided, a new VPC with private subnets for the tasks and a default security group for internet egress via a public subnet will be created | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#output\_ecs\_cluster\_arn) | The ARN of the ECS cluster |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | The name of the ECS cluster (either existing or newly created) |
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | The ARN of the ECS task execution role |
| <a name="output_humanitec_role_arn"></a> [humanitec\_role\_arn](#output\_humanitec\_role\_arn) | The ARN of the IAM role for Humanitec |
| <a name="output_runner_id"></a> [runner\_id](#output\_runner\_id) | The ID of the runner |
| <a name="output_s3_bucket"></a> [s3\_bucket](#output\_s3\_bucket) | The name of the S3 bucket for TF state storage |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | The ARN of the ECS task role |
<!-- END_TF_DOCS -->