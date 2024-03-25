resource "aws_ecs_cluster" "ecs_app_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "ecs_app_task" {
  family                   = var.ecs_app_task_family
  container_definitions    = <<DEFINITION
    [
      {
        "name": "${var.ecs_app_task_name}
        "image": "${var.ecr_repo_url}",
        "essential": true,
        "portMappings": [
          {
            "containerPort": ${var.container_port},
            "hostPort": ${var.host_port}
          }
        ],
        "memory": 512,
        "cpu": 256
      }
    ]
    DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn
}
