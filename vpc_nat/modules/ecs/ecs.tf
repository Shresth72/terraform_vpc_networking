resource "aws_ecs_cluster" "ecs_app_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "ecs_app_task" {
  family                   = var.ecs_app_task_family
  execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsondecode([{
    name : var.ecs_app_task_name,
    image : var.ecr_repo_url,
    essential : true,
    portMappings : [{
      containerPort : var.container_port,
      hostPort : var.container_port
    }],
    memory : 512,
    cpu : 256,
    logConfiguration : {
      logDriver : "awslogs",
      options : {
        "awslogs-group" : aws_cloudwatch_log_group.ecs_log_group.name,
        "awslogs-region" : var.region,
        "awslogs-stream-prefix" : "ecs"
      }
    },
    # environment: [{
    #   name: "ENV_VAR",
    #   value: "value"
    # }],
  }])
}

resource "aws_ecs_service" "ecs_app_service" {
  name            = "${var.ecs_cluster_name}-service"
  cluster         = aws_ecs_cluster.ecs_app_cluster.id
  task_definition = aws_ecs_task_definition.ecs_app_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    container_name   = aws_ecs_task_definition.ecs_app_task.family
    container_port   = var.container_port
  }

  network_configuration {
    subnets = [
      var.public_subnet_az1_id,
      var.public_subnet_az2_id
    ]
    assign_public_ip = true
    security_groups  = [var.ecs_security_group_id]
  }
}
