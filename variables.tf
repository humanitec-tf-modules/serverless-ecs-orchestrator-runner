variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
}

variable "runner_id" {
  description = "The ID of the runner. If not provided, one will be generated using runner_id_prefix"
  type        = string
  default     = null
}

variable "runner_id_prefix" {
  description = "The prefix to use when generating a runner ID. Only used if runner_id is not provided"
  type        = string
  default     = "runner"
}

variable "existing_ecs_cluster_name" {
  description = "The name of an existing ECS cluster to use. If not provided, a new Fargate-compatible cluster will be created"
  type        = string
  default     = null
}

variable "additional_tags" {
  description = "Additional tags to apply to resources created by this module"
  type        = map(string)
  default     = {}
}

variable "subnet_ids" {
  description = "List of subnet IDs where ECS tasks will be launched. If not provided, a new VPC with private subnets for the tasks and a default security group for internet egress via a public subnet will be created"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Optional list of security group IDs to attach to ECS tasks"
  type        = list(string)
  default     = []
}

variable "orchestrator_org_id" {
  description = "The Platform Orchestrator organization ID for OIDC federation"
  type        = string
  default     = null
  nullable    = true
}

variable "humanitec_org_id" {
  description = "Deprecated alias for orchestrator_org_id"
  type        = string
  default     = null
  nullable    = true
}

variable "existing_oidc_provider_arn" {
  description = "The ARN of an existing OIDC provider to use. If not provided, a new OIDC provider will be created"
  type        = string
  default     = null
}

variable "oidc_hostname" {
  description = "The hostname of the OIDC issuer exposed by your Platform Orchestrator installation"
  type        = string
}

variable "environment" {
  description = "Plain text environment variables to expose in the runner"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secret environment variables to expose in the runner. Each value should be a secret or property ARN"
  type        = map(string)
  default     = {}
}

variable "nats_url" {
  description = "TLS NATS endpoint used by runner tasks for durable results and logs"
  type        = string
}

variable "nats_token_secret_arn" {
  description = "Secrets Manager or SSM ARN containing the NATS token injected as NATS_TOKEN"
  type        = string

  validation {
    condition = (
      can(regex("^arn:[^:]+:secretsmanager:[^:]+:[0-9]{12}:secret:.+$", var.nats_token_secret_arn)) ||
      can(regex("^arn:[^:]+:ssm:[^:]+:[0-9]{12}:parameter/.+$", var.nats_token_secret_arn))
    )
    error_message = "nats_token_secret_arn must be a Secrets Manager secret ARN or SSM parameter ARN."
  }
}

variable "nats_token_kms_key_arn" {
  description = "Optional customer-managed KMS key ARN used to encrypt the NATS token secret"
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.nats_token_kms_key_arn == null || can(regex("^arn:[^:]+:kms:[^:]+:[0-9]{12}:key/.+$", var.nats_token_kms_key_arn))
    error_message = "nats_token_kms_key_arn must be a customer-managed KMS key ARN."
  }
}

variable "force_delete_s3" {
  description = "Force delete the S3 state files bucket on destroy even if it's not empty"
  type        = bool
  default     = false
}
