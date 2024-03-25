locals {
  bucket_name = "${var.project_name}-tf-state-bucket"
  table_name  = "${var.project_name}-tf-state-lock-table"

  ecr_repo_name = "${var.project_name}-ecr-repo"
}
