// Connects ECS Cluster to the ASG so that
// the cluster can use EC2 instances to deploy containers

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "${var.ecs_cluster_name}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers" {
  cluster_name = var.ecs_cluster_name
  capacity_providers = [
    aws_ecs_capacity_provider.ecs_capacity_provider.name
  ]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    base              = 1
    weight            = 100
  }
}
