# Reusable Platform Orchestrator ECS Runner

A reusable Terraform module for setting up an ECS Runner for the Humanitec Platform Orchestrator.

## Overview

This module provides a reusable configuration for deploying an ECS-based runner that integrates with the Humanitec Platform Orchestrator. The module handles runner ID generation, AWS resource provisioning, and IAM role configuration.

## Requirements

| Name                  | Version  |
| --------------------- | -------- |
| terraform             | >= 1.8.0 |
| aws                   | >= 4.0   |
| random                | >= 3.0   |
| platform-orchestrator | ~> 2.0   |

## Usage

### Basic Example

```hcl
module "ecs_runner" {
  source = "github.com/humanitec/platform-orchestrator-tf-modules//orchestrator-configuration/runner/serverless-ecs"
  
  region           = "us-east-1"
  subnet_ids       = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id = "my-org-id"
}
```

### With Custom Runner ID

```hcl
module "ecs_runner" {
  source = "github.com/humanitec/platform-orchestrator-tf-modules//orchestrator-configuration/runner/serverless-ecs"
  
  region           = "us-east-1"
  subnet_ids       = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id = "my-org-id"
  runner_id        = "my-custom-runner"
}
```

### With Custom Runner ID Prefix

```hcl
module "ecs_runner" {
  source = "github.com/humanitec/platform-orchestrator-tf-modules//orchestrator-configuration/runner/serverless-ecs"
  
  region           = "us-east-1"
  subnet_ids       = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id = "my-org-id"
  runner_id_prefix = "prod-runner"
}
```

### With Existing ECS Cluster

```hcl
module "ecs_runner" {
  source = "github.com/humanitec/platform-orchestrator-tf-modules//orchestrator-configuration/runner/serverless-ecs"
  
  region                    = "us-east-1"
  subnet_ids                = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id          = "my-org-id"
  existing_ecs_cluster_name = "existing-cluster"
}
```

### With Additional Tags

```hcl
module "ecs_runner" {
  source = "github.com/humanitec/platform-orchestrator-tf-modules//orchestrator-configuration/runner/serverless-ecs"
  
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
  source = "github.com/humanitec/platform-orchestrator-tf-modules//orchestrator-configuration/runner/serverless-ecs"
  
  region             = "us-east-1"
  subnet_ids         = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id   = "my-org-id"
  security_group_ids = ["sg-12345678"]
}
```

### With Existing OIDC Provider

```hcl
module "ecs_runner" {
  source = "github.com/humanitec/platform-orchestrator-tf-modules//orchestrator-configuration/runner/serverless-ecs"
  
  region                     = "us-east-1"
  subnet_ids                 = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id           = "my-org-id"
  existing_oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.humanitec.dev"
}
```

### With Custom OIDC Hostname

```hcl
module "ecs_runner" {
  source = "github.com/humanitec/platform-orchestrator-tf-modules//orchestrator-configuration/runner/serverless-ecs"
  
  region           = "us-east-1"
  subnet_ids       = ["subnet-12345678", "subnet-87654321"]
  humanitec_org_id = "my-org-id"
  oidc_hostname    = "custom-oidc.example.com"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->