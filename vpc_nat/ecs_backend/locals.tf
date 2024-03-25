locals {
  bucket_name = "${var.project_name}-tf-state-bucket"
  table_name  = "${var.project_name}-tf-state-lock-table"

  ecr_repo_name = "${var.project_name}-ecr-repo"

  ecs_cluster_name    = "${var.project_name}-ecs-cluster"
  ecs_app_task_family = "${var.project_name}-ecs-app-task-family"
  ecs_app_task_name   = "${var.project_name}-ecs-app-task"
  container_port      = 3000
}
