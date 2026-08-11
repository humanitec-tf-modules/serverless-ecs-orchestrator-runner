mock_provider "aws" {

  mock_data "aws_availability_zones" {
    defaults = {
      names = ["zone-1a", "zone-1b", "zone-1c"]
    }
  }
  mock_resource "aws_iam_role" {
    defaults = {
      arn = "arn:aws:iam::123456789012:role/mock-role"
    }
  }
  mock_resource "aws_ecs_cluster" {
    defaults = {
      arn = "arn:aws:eks:eu-north-1:123456789012:cluster/mock-cluster"
    }
  }
}

mock_provider "platform-orchestrator" {}

variables {
  oidc_hostname         = "oidc.orchestrator.example.com"
  nats_url              = "tls://nats.example.test:4222"
  nats_token_secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:nats-token-AbCdEf"
}

run "test_with_explicit_runner_id" {
  command = plan

  variables {
    region              = "us-east-1"
    subnet_ids          = ["subnet-12345678", "subnet-87654321"]
    runner_id           = "test-runner"
    orchestrator_org_id = "test-org-123"
  }

  assert {
    condition     = output.runner_id == "test-runner"
    error_message = "Runner ID should match the provided value"
  }
}

run "test_with_custom_prefix" {
  command = plan

  variables {
    region              = "eu-west-1"
    subnet_ids          = ["subnet-12345678"]
    runner_id_prefix    = "test-prefix"
    orchestrator_org_id = "test-org-456"
  }

  # Note: runner_id and ecs_cluster_name contain random values only known at apply time
  # so we can't assert on them in plan mode
}

run "test_with_defaults" {
  command = plan

  variables {
    region              = "ap-southeast-1"
    subnet_ids          = ["subnet-abc123"]
    orchestrator_org_id = "test-org-789"
  }

  # Note: runner_id and ecs_cluster_name contain random values only known at apply time
  # so we can't assert on them in plan mode
}

run "test_deprecated_org_id_alias" {
  command = plan

  variables {
    region           = "ap-southeast-1"
    subnet_ids       = ["subnet-abc123"]
    humanitec_org_id = "test-org-legacy"
  }

  assert {
    condition     = local.orchestrator_org_id == "test-org-legacy"
    error_message = "The deprecated organization ID alias should remain functional"
  }
}

run "test_with_existing_cluster" {
  command = plan

  variables {
    region                    = "us-west-2"
    subnet_ids                = ["subnet-xyz789"]
    existing_ecs_cluster_name = "existing-cluster"
    orchestrator_org_id       = "test-org-abc"
  }

  assert {
    condition     = output.ecs_cluster_name == "existing-cluster"
    error_message = "ECS cluster name should match the provided existing cluster"
  }

  # Note: runner_id contains random values only known at apply time when not explicitly provided
}

run "test_without_existing_ecs_cluster_or_vpc" {
  command = plan

  variables {
    region              = "us-east-1"
    orchestrator_org_id = "test-org-def"
  }

  assert {
    condition     = aws_ecs_cluster.main[0] != null
    error_message = "An ECS cluster was created"
  }
  assert {
    condition     = module.vpc[0] != null
    error_message = "A VPC was created"
  }
}

run "test_with_additional_tags" {
  command = plan

  variables {
    region              = "us-east-1"
    subnet_ids          = ["subnet-test123"]
    orchestrator_org_id = "test-org-def"
    additional_tags = {
      Environment = "test"
      Team        = "platform"
    }
  }

  # Note: runner_id and ecs_cluster_name contain random values only known at apply time
  # This test just validates that the plan succeeds with additional tags
}

run "test_with_security_groups" {
  command = plan

  variables {
    region              = "us-east-1"
    subnet_ids          = ["subnet-test456"]
    security_group_ids  = ["sg-12345678", "sg-87654321"]
    orchestrator_org_id = "test-org-ghi"
  }

  # This test validates that the plan succeeds with security groups specified
}

run "test_with_existing_oidc_provider" {
  command = plan

  variables {
    region                     = "us-east-1"
    subnet_ids                 = ["subnet-test789"]
    orchestrator_org_id        = "test-org-jkl"
    existing_oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.orchestrator.example.com"
  }

  # This test validates that the plan succeeds when using an existing OIDC provider
}

run "test_with_custom_oidc_hostname" {
  command = plan

  variables {
    region              = "eu-central-1"
    subnet_ids          = ["subnet-test012"]
    orchestrator_org_id = "test-org-mno"
    oidc_hostname       = "custom-oidc.example.com"
  }

  # This test validates that the plan succeeds with a custom OIDC hostname
}

run "test_with_existing_oidc_and_custom_hostname" {
  command = plan

  variables {
    region                     = "ap-northeast-1"
    subnet_ids                 = ["subnet-test345"]
    orchestrator_org_id        = "test-org-pqr"
    existing_oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/custom-oidc.example.com"
    oidc_hostname              = "custom-oidc.example.com"
  }

  # This test validates that the plan succeeds when using an existing OIDC provider with custom hostname
}

run "test_with_nats_transport" {
  command = plan

  variables {
    region                     = "us-east-1"
    subnet_ids                 = ["subnet-nats"]
    orchestrator_org_id        = "test-org-nats"
    oidc_hostname              = "oidc.example.com"
    existing_oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.example.com"
    nats_url                   = "tls://nats.example.com:4222"
    nats_token_secret_arn      = "arn:aws:secretsmanager:us-east-1:123456789012:secret:nats-token-AbCdEf"
    nats_token_kms_key_arn     = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  assert {
    condition     = platform-orchestrator_serverless_ecs_runner.runner.runner_configuration.job.environment.NATS_URL == "tls://nats.example.com:4222"
    error_message = "NATS_URL must be passed to serverless runner tasks."
  }

  assert {
    condition     = platform-orchestrator_serverless_ecs_runner.runner.runner_configuration.job.secrets.NATS_TOKEN == "arn:aws:secretsmanager:us-east-1:123456789012:secret:nats-token-AbCdEf"
    error_message = "NATS_TOKEN must be sourced from the configured AWS secret."
  }

  assert {
    condition     = jsondecode(aws_iam_role_policy.execution_nats_token.policy).Statement[0].Action == "secretsmanager:GetSecretValue"
    error_message = "The execution role must be able to read the configured Secrets Manager secret."
  }

  assert {
    condition     = jsondecode(aws_iam_role_policy.execution_nats_token.policy).Statement[0].Resource == "arn:aws:secretsmanager:us-east-1:123456789012:secret:nats-token-AbCdEf"
    error_message = "Secrets Manager access must be scoped to the configured NATS token secret."
  }

  assert {
    condition     = jsondecode(aws_iam_role_policy.execution_nats_token.policy).Statement[1].Action == "kms:Decrypt"
    error_message = "The execution role must be able to decrypt a NATS token encrypted with a customer-managed KMS key."
  }

  assert {
    condition     = jsondecode(aws_iam_role_policy.execution_nats_token.policy).Statement[1].Resource == "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    error_message = "KMS decrypt access must be scoped to the configured customer-managed key."
  }
}

run "test_with_ssm_nats_token" {
  command = plan

  variables {
    region                     = "us-east-1"
    subnet_ids                 = ["subnet-nats-ssm"]
    orchestrator_org_id        = "test-org-nats-ssm"
    oidc_hostname              = "oidc.example.com"
    existing_oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.example.com"
    nats_url                   = "tls://nats.example.com:4222"
    nats_token_secret_arn      = "arn:aws:ssm:us-east-1:123456789012:parameter/runners/nats-token"
  }

  assert {
    condition     = length(jsondecode(aws_iam_role_policy.execution_nats_token.policy).Statement) == 1
    error_message = "The execution role must not receive KMS access when no customer-managed key is configured."
  }

  assert {
    condition     = jsondecode(aws_iam_role_policy.execution_nats_token.policy).Statement[0].Action == "ssm:GetParameters"
    error_message = "The execution role must be able to read the configured SSM parameter."
  }

  assert {
    condition     = jsondecode(aws_iam_role_policy.execution_nats_token.policy).Statement[0].Resource == "arn:aws:ssm:us-east-1:123456789012:parameter/runners/nats-token"
    error_message = "SSM access must be scoped to the configured NATS token parameter."
  }
}
