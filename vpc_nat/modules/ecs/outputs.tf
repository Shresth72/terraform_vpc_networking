// Not required by other modules for now
output "ecs_tasks_execution_role_arn" {
  value = aws_iam_role.ecs_tasks_execution_role.arn
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_app_cluster.id
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.ecs_task_definition.arn
}

output "ecs_service_id" {
  value = aws_ecs_service.ecs_app_service.id
}
