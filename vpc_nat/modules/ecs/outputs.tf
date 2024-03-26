// Not required by other modules for now
output "ecs_tasks_execution_role_arn" {
  value = aws_iam_role.ecs_tasks_execution_role.arn
}

output "ecs_cluster_name" {
  value = var.ecs_cluster_name
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_app_cluster.id
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.ecs_app_task.arn
}

output "ecs_service_id" {
  value = aws_ecs_service.ecs_app_service.id
}

output "alb_target_group_arn" {
  value = aws_alb_target_group.alb_target_group.arn
}

output "alb_dns_name" {
  value = aws_alb.application_load_balancer.dns_name
}

output "application_load_balancer_zone_id" {
  value = aws_alb.application_load_balancer.zone_id
}

output "aws_iam_instance_profile_name" {
  value = aws_iam_instance_profile.ecs_instance_profile.name
}
