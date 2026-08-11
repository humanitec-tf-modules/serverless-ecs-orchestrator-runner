resource "platform-orchestrator_serverless_ecs_runner" "runner" {
  id          = local.runner_id
  description = "Deploys using the ${local.ecs_cluster_name} ECS cluster in ${var.region}"

  runner_configuration = {
    auth = {
      role_arn = aws_iam_role.ecs_task_manager.arn
    }
    job = {
      region             = var.region
      cluster            = local.ecs_cluster_name
      execution_role_arn = aws_iam_role.execution.arn
      task_role_arn      = aws_iam_role.task.arn

      subnets              = local.create_vpc ? module.vpc[0].private_subnets : var.subnet_ids
      security_groups      = local.create_vpc ? concat(var.security_group_ids, [module.vpc[0].default_security_group_id]) : var.security_group_ids
      is_public_ip_enabled = false

      environment = var.environment
      secrets     = var.secrets
    }
  }

  state_storage_configuration = {
    type = "s3"
    s3_configuration = {
      bucket = aws_s3_bucket.state.bucket
    }
  }
}
