locals {
  # Terraform State Locals
  bucket_name = "${var.project_name}-tf-state-bucket"
  table_name  = "${var.project_name}-tf-state-lock-table"

  # ECR Locals
  ecr_repo_name = "${var.project_name}-ecr-repo"

  # ECS Locals
  ecs_cluster_name    = "${var.project_name}-ecs-cluster"
  ecs_app_task_family = "${var.project_name}-ecs-app-task-family"
  ecs_app_task_name   = "${var.project_name}-ecs-app-task"
  container_port      = 3000

  # ACM Locals 
  domain_name              = "myproject.com"
  subject_alternative_name = "*.myproject.com"
}
